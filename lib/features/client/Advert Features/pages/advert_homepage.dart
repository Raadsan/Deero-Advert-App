import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:deero_advert_app/core/constant.dart';
import 'package:deero_advert_app/core/widgets/safe_network_image.dart';
import 'package:deero_advert_app/core/themes/color_page.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/check_domain_provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/hosting_provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/portfolio_provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/achievement_provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/major_client_provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_portfoliopage.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_project_details.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/service_provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/cart_provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/navigation_provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_cart_page.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_domains_page.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/widgets/advert_achievment_card_widget.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/widgets/advert_drawer.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/widgets/advert_slider_card.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/widgets/bonus_progress_card.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/notification_provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/widgets/service_card.dart';
import 'package:deero_advert_app/features/auth/controllers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:after_layout/after_layout.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:iconly/iconly.dart';
import 'package:get_storage/get_storage.dart';

class AdvertHomepage extends StatefulWidget {
  const AdvertHomepage({super.key});

  @override
  State<AdvertHomepage> createState() => _AdvertHomepageState();
}

class _AdvertHomepageState extends State<AdvertHomepage>
    with AfterLayoutMixin<AdvertHomepage> {
  final TextEditingController _domainController = TextEditingController();
  final GetStorage _box = GetStorage();
  static const String _bonusSeenKey = "advert_bonus_seen_points";
  int _currentIndex = 0;
  int? _lastProcessedBonus;

  @override
  void dispose() {
    _domainController.dispose();
    super.dispose();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    // Parallelize core data fetching with slight delays to avoid main thread spikes
    _initData();
  }

  Future<void> _initData() async {
    final sp = Provider.of<ServiceProvider>(context, listen: false);
    final hp = Provider.of<HostingProvider>(context, listen: false);
    final np = Provider.of<NotificationProvider>(context, listen: false);
    final pp = Provider.of<PortfolioProvider>(context, listen: false);
    final ap = Provider.of<AchievementProvider>(context, listen: false);
    final mcp = Provider.of<MajorClientProvider>(context, listen: false);
    final up = Provider.of<UserProvider>(context, listen: false);

    // Initial important data — global discounts work without login
    await Future.wait([up.refreshUser(), up.fetchGlobalDiscounts()]);
    sp.getAllServices();

    // Defer non-critical sections slightly to ensure smooth UI interaction
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      hp.getAllHosting();
      np.activeNotification();
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      pp.getPortfolio();
      ap.getAchievements();
      mcp.getMajorClients();
    });
  }

  void _searchDomain(BuildContext context) {
    final domainName = _domainController.text.trim();

    // Check if domain name is empty
    if (domainName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please enter a domain name",
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: const Color(0xFFEB4724),
        ),
      );
      return;
    }

    // Remove strict TLD requirements since we will auto-generate all extensions
    if (domainName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please enter a domain name idea",
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: const Color(0xFFEB4724),
        ),
      );
      return;
    }

    final domainProvider = Provider.of<CheckDomainProvider>(
      context,
      listen: false,
    );
    domainProvider.checkDomain(domainName);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdvertDomainsPage(searchedDomain: domainName),
      ),
    );
  }

  void _maybeShowBonusCelebration(int currentBonus) {
    if (_lastProcessedBonus == currentBonus || !mounted) return;
    _lastProcessedBonus = currentBonus;

    final storedValue = _box.read(_bonusSeenKey);
    final previousBonus = storedValue is int
        ? storedValue
        : int.tryParse("$storedValue") ?? 0;

    if (currentBonus > previousBonus) {
      final addedPoints = currentBonus - previousBonus;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        showDialog(
          context: context,
          barrierColor: Colors.black.withOpacity(0.45),
          builder: (context) => Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 26),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF7B1710),
                    Color(0xFFB52E1D),
                    Color(0xFFE24122),
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.celebration,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Congratulations!",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 21,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "You earned +$addedPoints bonus points",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.95),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Total: $currentBonus/${Provider.of<UserProvider>(context, listen: false).minBonusForDiscount}",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFFB52E1D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Awesome!",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
    }

    _box.write(_bonusSeenKey, currentBonus);
  }

  Future<void> _onRefresh() async {
    await Future.wait([
      Provider.of<ServiceProvider>(context, listen: false).getAllServices(),
      Provider.of<HostingProvider>(context, listen: false).getAllHosting(),
      Provider.of<NotificationProvider>(
        context,
        listen: false,
      ).activeNotification(),
      Provider.of<PortfolioProvider>(context, listen: false).getPortfolio(),
      Provider.of<AchievementProvider>(
        context,
        listen: false,
      ).getAchievements(),
      Provider.of<MajorClientProvider>(
        context,
        listen: false,
      ).getMajorClients(),
      Provider.of<UserProvider>(context, listen: false).refreshUser(),
      Provider.of<UserProvider>(context, listen: false).fetchGlobalDiscounts(),
    ]);
  }

  List<_HomeSliderItem> _defaultSliderItems() => const [
    _HomeSliderItem(
      title: "Web Solution",
      description:
          "We offer complete web services, including web design, domain registration, domain transfer, SSL certificates, and web hosting. We create responsive websites that look wonderful on any device, including smartphones, tablets, and desktop computers.",
      imagePath: "images/advertimages/web.png",
    ),
    _HomeSliderItem(
      title: "Graphic Design",
      description:
          "We offer range of graphic design services encompasses logo design, UI design, event branding, and brand identity. With our expertise, we create captivating and memorable brands that resonate with the public, leaving a lasting impression",
      imagePath: "images/advertimages/graphic.png",
    ),
    _HomeSliderItem(
      title: "Digital Marketing",
      description:
          "We offer complete digital marketing services, including social media marketing strategy, social media analytics, branding, content writing and social media management. The strategy team understands business cases and how to align digital marketing activities to ensure they deliver on your objectives.",
      imagePath: "images/advertimages/marketing.png",
    ),
    _HomeSliderItem(
      title: "Event Branding",
      description:
          "Full suite of event branding and consulting, from digital strategy and social media to on-site branding and highlight videos.",
      imagePath: "images/advertimages/event.png",
    ),
    _HomeSliderItem(
      title: "Digital Consulting",
      description:
          "We offer a full suite of digital consulting services, including digital marketing, branding consulting, event consulting, assisting with content creation, digital media, and communication consulting.",
      imagePath: "images/advertimages/digital.png",
    ),
  ];

  /// One offer slide per service (not per sub-package). Defaults if none.
  List<_HomeSliderItem> _buildSliderItems(
    ServiceProvider serviceProvider,
    UserProvider userProvider,
  ) {
    final offers = <_HomeSliderItem>[];
    final services = serviceProvider.serviceModel?.data ?? [];

    for (var serviceIndex = 0; serviceIndex < services.length; serviceIndex++) {
      final service = services[serviceIndex];
      final serviceId = service.sId ?? "";
      final packages = service.packages ?? [];
      final packageIds = packages
          .map((p) => p.sId ?? "")
          .where((id) => id.isNotEmpty)
          .toList();

      // Best discount for this service (service id or any of its packages)
      final best = userProvider.getBestDiscount(
        "service",
        serviceId.isNotEmpty ? serviceId : "all",
        alsoMatchIds: packageIds,
      );
      if (best == null) continue;

      // Use cheapest package price for fixed→% conversion when needed
      double refPrice = 0;
      for (final pkg in packages) {
        final p = (pkg.price ?? 0).toDouble();
        if (p > 0 && (refPrice == 0 || p < refPrice)) refPrice = p;
      }

      String offerTitle;
      if (best.discountType == "percentage") {
        final value = best.discountValue ?? 0;
        offerTitle =
            "${value % 1 == 0 ? value.toInt() : value.toStringAsFixed(0)}% OFF";
      } else {
        final value = best.discountValue ?? 0;
        final pct = refPrice > 0 ? ((value / refPrice) * 100).clamp(0, 100) : 0;
        offerTitle = pct > 0
            ? "${pct.round()}% OFF"
            : "\$${value % 1 == 0 ? value.toInt() : value} OFF";
      }

      String imagePath = "";
      final icon = service.serviceIcon;
      if (icon != null && icon.isNotEmpty) {
        imagePath = icon.startsWith("http") ? icon : "${BaseUrl}uploads/$icon";
      }

      offers.add(
        _HomeSliderItem(
          title: offerTitle,
          description: service.serviceTitle ?? "Service",
          imagePath: imagePath.isNotEmpty
              ? imagePath
              : "images/advertimages/web.png",
          isNetworkImage: imagePath.isNotEmpty,
          isOffer: true,
          serviceIndex: serviceIndex,
        ),
      );
    }

    if (offers.isNotEmpty) return offers;
    return _defaultSliderItems();
  }

  Widget build(BuildContext context) {
    return Consumer3<ServiceProvider, PortfolioProvider, UserProvider>(
      builder: (context, serviceprovider, portfolioProvider, userProvider, _) {
        final service = serviceprovider.serviceModel?.data ?? [];
        final loggedUser = userProvider.userModel?.user;
        final bonus = loggedUser?.bonus ?? 0;
        final bonusStatus = loggedUser?.bonusStatus ?? "BonusNotAvailable";
        final registerSource = loggedUser?.registerSource ?? "website";
        _maybeShowBonusCelebration(bonus);
        final sliderItems = _buildSliderItems(serviceprovider, userProvider);
        if (_currentIndex >= sliderItems.length) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _currentIndex = 0);
          });
        }

        return Scaffold(
          backgroundColor: bgColor,
          drawer: const AdvertDrawer(),
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarColor: bgColor,
            ),
            surfaceTintColor: const Color(0xFFF9FAFB),
            backgroundColor: bgColor,
            centerTitle: true,
            actions: [
              Consumer<CartProvider>(
                builder: (context, cartProvider, _) {
                  return IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdvertCartPage(),
                        ),
                      );
                    },
                    icon: Badge(
                      isLabelVisible: cartProvider.totalItems > 0,
                      label: Text(
                        "${cartProvider.totalItems}",
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: const Color(0xFFEB4724),
                      child: const Icon(
                        IconlyLight.buy,
                        color: Color(0xff660E0D),
                        size: 24,
                      ),
                    ),
                  );
                },
              ),
            ],
            title: SizedBox(
              height: 40,
              child: TextFormField(
                controller: _domainController,
                onFieldSubmitted: (_) => _searchDomain(context),
                decoration: InputDecoration(
                  prefixIcon: Icon(IconlyLight.search, color: Colors.grey),
                  hintText: "Search your domain",
                  fillColor: Colors.white,
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(46),
                  ),
                ),
              ),
            ),
            leading: Builder(
              builder: (context) => IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: Image.asset("images/advertimages/menu.png"),
              ),
            ),
            automaticallyImplyLeading: false,
          ),
          body: RefreshIndicator(
            onRefresh: _onRefresh,
            color: const Color(0xffEF7044),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),

                    BonusProgressCard(
                      bonus: bonus,
                      bonusStatus: bonusStatus,
                      registerSource: registerSource,
                      minBonus: Provider.of<UserProvider>(
                        context,
                      ).minBonusForDiscount,
                      discount: Provider.of<UserProvider>(
                        context,
                      ).discountPercentage,
                    ),
                    SizedBox(height: 16),
                    serviceprovider.isLoading && service.isEmpty
                        ? const AdvertSliderShimmer()
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              height: 150,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF5C0F0C),
                                    Color(0xFFB52E1D),
                                    Color(0xFFE24122),
                                    Color(0xFFF3664C),
                                  ],
                                  stops: [0.0, 0.38, 0.72, 1.0],
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: CarouselSlider(
                                      items: sliderItems.map((item) {
                                        return AdvertSliderCard(
                                          title: item.title,
                                          description: item.description,
                                          imagePath: item.imagePath,
                                          isNetworkImage: item.isNetworkImage,
                                          isOffer: item.isOffer,
                                          onTap: item.serviceIndex != null
                                              ? () {
                                                  Provider.of<
                                                        NavigationProvider
                                                      >(context, listen: false)
                                                      .navigateToService(
                                                        item.serviceIndex!,
                                                      );
                                                }
                                              : null,
                                        );
                                      }).toList(),
                                      options: CarouselOptions(
                                        height: 160,
                                        viewportFraction: 1,
                                        aspectRatio: 16 / 9,
                                        autoPlay: true,
                                        autoPlayInterval: const Duration(
                                          seconds: 4,
                                        ),
                                        autoPlayAnimationDuration:
                                            const Duration(milliseconds: 800),
                                        autoPlayCurve: Curves.fastOutSlowIn,
                                        enlargeCenterPage: true,
                                        scrollDirection: Axis.horizontal,
                                        onPageChanged: (index, reason) {
                                          setState(() {
                                            _currentIndex = index;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  // Indicator dots
                                  Positioned(
                                    bottom: 12,
                                    left: 0,
                                    right: 0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(
                                        sliderItems.length,
                                        (index) {
                                          return AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 300,
                                            ),
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                            ),
                                            width: _currentIndex == index
                                                ? 20
                                                : 8,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              color: _currentIndex == index
                                                  ? const Color(
                                                      0xFFF3664C,
                                                    ) // Active button-like color
                                                  : Colors.white.withOpacity(
                                                      0.5,
                                                    ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    SizedBox(height: 20),
                    Text(
                      "Our Services",
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      // Note: Removed the grey/orange background box to match the clean look of the new mock-up.
                      child: serviceprovider.isLoading
                          ? const Center(child: ServiceCardShimmer())
                          : (serviceprovider.error != null || service.isEmpty)
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 24),
                                child: Text(
                                  "No services available yet.",
                                  style: GoogleFonts.poppins(color: Colors.grey),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                alignment: WrapAlignment.center,
                                children: service.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  var s = entry.value;
                                  final userProvider =
                                      Provider.of<UserProvider>(context);
                                  final packageIds = (s.packages ?? [])
                                      .map((p) => p.sId ?? "")
                                      .where((id) => id.isNotEmpty)
                                      .toList();
                                  final discountLabel = userProvider
                                      .getServiceDiscountBadge(
                                        s.sId,
                                        packageIds: packageIds,
                                      );
                                  return ServiceCard(
                                    ImageUrl: () {
                                      final icon = s.serviceIcon;
                                      if (icon == null || icon.trim().isEmpty) return "";
                                      if (icon.startsWith('http')) return icon;
                                      final clean = icon.replaceAll('\\', '/');
                                      if (clean.startsWith('uploads/')) return BaseUrl + clean;
                                      return "${BaseUrl}uploads/$clean";
                                    }(),
                                    serviceTitle: s.serviceTitle,
                                    discountLabel: discountLabel,
                                    onTap: () {
                                      Provider.of<NavigationProvider>(
                                        context,
                                        listen: false,
                                      ).navigateToService(index);
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                    ),

                    SizedBox(height: 15),

                    // Our Portfolio Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Our Portfolio",
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            color: Colors.grey,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AdvertPortfoliopage(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(50, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            "See All",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: const Color(
                                0xFFE24122,
                              ), // Matching light orange text
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    portfolioProvider.isLoading
                        ? Container(
                            height: 140,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.only(
                              left: 18,
                              top: 20,
                              bottom: 20,
                              right: 8,
                            ),
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 20,
                                          width: double.infinity,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(height: 12),
                                        Container(
                                          height: 10,
                                          width: double.infinity,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(height: 6),
                                        Container(
                                          height: 10,
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.4,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(height: 6),
                                        Container(
                                          height: 10,
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.2,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : (portfolioProvider.error.isNotEmpty ||
                            (portfolioProvider.portfolioModel?.portfolios?.isEmpty ?? true))
                        ? Container(
                            height: 140,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                "No portfolio projects yet.",
                                style: GoogleFonts.poppins(color: Colors.grey),
                              ),
                            ),
                          )
                        : CarouselSlider(
                            items:
                                (portfolioProvider.portfolioModel?.portfolios ??
                                        [])
                                    .map((project) {
                                      final imageUrl = project.mainImage != null
                                          ? (project.mainImage!.startsWith(
                                                  'http',
                                                )
                                                ? project.mainImage!
                                                : BaseUrl + project.mainImage!)
                                          : "";
                                      final title = project.title ?? "Our Work";
                                      final description =
                                          (project.description ?? "")
                                              .trim()
                                              .isNotEmpty
                                          ? project.description!
                                          : "Explore this featured project from our portfolio.";

                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AdvertProjectDetailsPage(
                                                    project: project,
                                                  ),
                                            ),
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: Stack(
                                            children: [
                                              // Background image with shimmer + error fallback
                                              Positioned.fill(
                                                child: imageUrl.isNotEmpty
                                                    ? SafeNetworkImage(
                                                        imageUrl: imageUrl,
                                                        fit: BoxFit.cover,
                                                        shimmerBase: Colors.grey.shade900,
                                                        shimmerHighlight: Colors.grey.shade800,
                                                        errorWidget: Image.asset(
                                                          "images/advertimages/1.png",
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )
                                                    : Image.asset(
                                                        "images/advertimages/1.png",
                                                        fit: BoxFit.cover,
                                                      ),
                                              ),
                                              // Dark overlay
                                              Positioned.fill(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black.withValues(alpha: 0.5),
                                                  ),
                                                ),
                                              ),
                                              // Text content
                                              Container(
                                                width: double.infinity,
                                                height: 140,
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 18,
                                                  vertical: 16,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      title,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      description,
                                                      textAlign: TextAlign.justify,
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        height: 1.4,
                                                        color: Colors.white.withValues(alpha: 0.9),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    })
                                    .toList(),
                            options: CarouselOptions(
                              height: 140,
                              viewportFraction: 1.0,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 4),
                              enlargeCenterPage: false,
                            ),
                          ),

                    SizedBox(height: 40),

                    Text(
                      "Our Major Clients",
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        letterSpacing: 1,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Consumer<MajorClientProvider>(
                      builder: (context, clientProvider, child) {
                        if (clientProvider.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final clients =
                            clientProvider.majorClientModel?.clients ?? [];
                        if (clients.isEmpty) return const SizedBox.shrink();

                        return SizedBox(
                          height: 80,
                          width: double.infinity,
                          child: CarouselSlider(
                            items: clients.map((client) {
                              String imagePath =
                                  (client.images != null &&
                                      client.images!.isNotEmpty)
                                  ? client.images![0].replaceAll('\\', '/')
                                  : "";

                              String fullUrl = imagePath.startsWith('http')
                                  ? imagePath
                                  : "${EndPoint.replaceAll('api/', '')}$imagePath";

                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.1),
                                    width: 1.0,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.02),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                  child: SafeNetworkImage(
                                    imageUrl: fullUrl,
                                    fit: BoxFit.contain,
                                    shimmerBase: const Color(0xFFEEEEEE),
                                    shimmerHighlight: const Color(0xFFFAFAFA),
                                    errorWidget: const Icon(
                                      Icons.business,
                                      color: Colors.grey,
                                    ),
                                  ),
                              );
                            }).toList(),
                            options: CarouselOptions(
                              height: 80,
                              viewportFraction: 0.32,
                              autoPlay: true,
                              scrollDirection: Axis.horizontal,
                              enableInfiniteScroll: true,
                              enlargeCenterPage: false,
                              scrollPhysics: const BouncingScrollPhysics(),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 40),
                    Text(
                      "Our Achievements",
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        letterSpacing: 1,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    AdvertAchievmentCardWidget(),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AnimatedAchievementCard extends StatelessWidget {
  final dynamic achievement;
  final int styleType;

  const AnimatedAchievementCard({
    super.key,
    required this.achievement,
    required this.styleType,
  });

  @override
  Widget build(BuildContext context) {
    double height;
    Color bgColor;
    Color? borderColor;
    Color textColor;

    // Style Mapping:
    // 0 -> Tall Card (Happy Clients Style - FFF6F0)
    // 1 -> Short Card (Pro Team Style - FFE0D2)
    // 2 -> Short Card (Completed Projects Style - EF7044)
    // 3 -> Tall Card (Awards Won Style - FFF6F0)

    if (styleType == 0 || styleType == 3) {
      height = 130;
      bgColor = const Color(0xFFFFF6F0);
      borderColor = const Color(0xFFF3D0C3);
      textColor = const Color(0xFF5C1B1B);
    } else if (styleType == 1) {
      height = 80;
      bgColor = const Color(0xFFFFE0D2);
      borderColor = const Color(0xFFF3A086);
      textColor = const Color(0xFF5C1B1B);
    } else {
      height = 80;
      bgColor = const Color(0xffEF7044);
      borderColor = null;
      textColor = Colors.white;
    }

    int targetValue = achievement.count ?? 0;

    Widget tweenNumber = TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: targetValue),
      duration: const Duration(seconds: 2),
      builder: (context, value, child) {
        return Text(
          "${value.toString()}+",
          style: GoogleFonts.poppins(
            fontSize: height == 130 ? 22 : 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
            color: textColor,
            height: 1.1,
          ),
        );
      },
    );

    Widget iconWidget = const SizedBox();
    if (achievement.icon != null && achievement.icon!.isNotEmpty) {
      String fullUrl = achievement.icon!;
      if (!fullUrl.startsWith('http')) {
        String imagePath = achievement.icon!.replaceAll('\\', '/');
        fullUrl = "${EndPoint.replaceAll('api/', '')}$imagePath";
      }

      iconWidget = SafeNetworkImage(
        imageUrl: fullUrl,
        width: 55,
        height: 55,
        fit: BoxFit.contain,
        shimmerBase: const Color(0xFF2A2A2A),
        shimmerHighlight: const Color(0xFF3D3D3D),
        errorWidget: const SizedBox(),
      );
    }

    Widget content;
    if (styleType == 0) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: SizedBox(height: 55, width: 55, child: iconWidget)),
          tweenNumber,
          Text(
            achievement.title ?? "",
            style: GoogleFonts.poppins(
              fontSize: 12,
              letterSpacing: 1,
              color: textColor,
            ),
          ),
        ],
      );
    } else if (styleType == 1) {
      content = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              tweenNumber,
              Text(
                achievement.title ?? "",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  letterSpacing: 1,
                  color: textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 25, width: 25, child: iconWidget),
        ],
      );
    } else if (styleType == 2) {
      content = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 35, width: 35, child: iconWidget),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                tweenNumber,
                Text(
                  achievement.title ?? "",
                  style: GoogleFonts.poppins(
                    fontSize: 9,
                    letterSpacing: 1,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      // styleType == 3
      content = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              tweenNumber,
              Text(
                achievement.title ?? "",
                style: GoogleFonts.poppins(fontSize: 12, color: textColor),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(height: 35, width: 35, child: iconWidget),
          ),
        ],
      );
    }

    return Container(
      height: height,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: height == 130 ? 16 : 10,
        vertical: height == 130 ? 16 : 8,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: borderColor != null
            ? Border.all(color: borderColor, width: 1)
            : null,
      ),
      child: content,
    );
  }
}

class AchievementShimmer extends StatelessWidget {
  const AchievementShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                _buildShimmerBox(130),
                const SizedBox(height: 10),
                _buildShimmerBox(80),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                _buildShimmerBox(80),
                const SizedBox(height: 10),
                _buildShimmerBox(130),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerBox(double height) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class ServiceCardShimmer extends StatelessWidget {
  final int itemCount;

  const ServiceCardShimmer({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(itemCount, (index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: (MediaQuery.of(context).size.width - 50) / 3,
            child: SizedBox(
              width: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 50,
                      width: 50,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Container(height: 12, width: 60, color: Colors.grey.shade300),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _HomeSliderItem {
  final String title;
  final String description;
  final String imagePath;
  final bool isNetworkImage;
  final bool isOffer;
  final int? serviceIndex;

  const _HomeSliderItem({
    required this.title,
    required this.description,
    required this.imagePath,
    this.isNetworkImage = false,
    this.isOffer = false,
    this.serviceIndex,
  });
}
