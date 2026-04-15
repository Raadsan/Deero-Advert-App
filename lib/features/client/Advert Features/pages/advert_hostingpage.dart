import 'package:deero_enterprise_app/core/themes/color_page.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/widgets/pricing_toggle.dart';
import 'package:deero_enterprise_app/core/constant.dart';
import 'package:deero_enterprise_app/features/auth/controllers/user_provider.dart';
import 'package:deero_enterprise_app/features/auth/pages/login_page.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/hosting_provider.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/transaction_provider.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/models/hosting_model.dart'
    as hosting;
import 'package:deero_enterprise_app/core/widgets/custom_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:iconly/iconly.dart';

class AdvertHostingpage extends StatefulWidget {
  const AdvertHostingpage({super.key});

  @override
  State<AdvertHostingpage> createState() => _AdvertHostingpageState();
}

class _AdvertHostingpageState extends State<AdvertHostingpage> {
  bool isYearly = false; // false = Monthly, true = Yearly

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<HostingProvider>();
      if (provider.hostingModel == null && !provider.isLoading) {
        provider.getAllHosting();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HostingProvider>(
      builder: (context, hostingProvider, child) {
        final hostingData = hostingProvider.hostingModel?.data ?? [];

        return Scaffold(
          backgroundColor: const Color(0xFFF9FAFB),
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: bgColor,
        ),
            backgroundColor: const Color(0xFFF9FAFB),
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text(
              "Hosting Plans",
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: const Color(0xff651313),
              ),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 25),
              PricingToggle(
                isYearly: isYearly,
                onChanged: (value) {
                  setState(() {
                    isYearly = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              Expanded(
                child: hostingProvider.isLoading
                    ? const HostingPackageCardShimmer()
                    : hostingData.isEmpty
                    ? Center(
                        child: Text(
                          "No hosting packages available yet.",
                          style: GoogleFonts.poppins(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        itemCount: hostingData.length,
                        itemBuilder: (context, index) {
                          final hostingPackage = hostingData[index];
                          final maxPrice = hostingData
                              .map((h) => h.price ?? 0.0)
                              .reduce((a, b) => a > b ? a : b);

                          return HostingPackageCard(
                            hostingPackage: hostingPackage,
                            isYearly: isYearly,
                            isMaxPrice:
                                (hostingPackage.price ?? 0.0) == maxPrice,
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class HostingPackageCardShimmer extends StatelessWidget {
  const HostingPackageCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 HEADER
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.withOpacity(0.1)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 16,
                          width: 140,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        Container(
                          height: 18,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 🔹 FEATURES
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: List.generate(
                        3,
                        (i) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Container(
                                height: 18,
                                width: 18,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Container(
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 🔹 BUTTON
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Container(
                      height: 45,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HostingPackageCard extends StatefulWidget {
  final hosting.Data hostingPackage;
  final bool isYearly;
  final bool isMaxPrice;
  const HostingPackageCard({
    super.key,
    required this.hostingPackage,
    required this.isYearly,
    required this.isMaxPrice,
  });

  @override
  State<HostingPackageCard> createState() => _HostingPackageCardState();
}

class _HostingPackageCardState extends State<HostingPackageCard> {
  bool isExpanded = false;
  bool _isLocalLoading = false;
  final TextEditingController _accountController = TextEditingController();

  @override
  void dispose() {
    _accountController.dispose();
    super.dispose();
  }

  void _showPurchaseDialog(
    BuildContext context,
    UserProvider userProvider,
    TransactionProvider transactionProvider,
  ) {
    final price = widget.isYearly
        ? (widget.hostingPackage.price ?? 0) * 12
        : (widget.hostingPackage.price ?? 0);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: StatefulBuilder(
            builder: (dialogContext, setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Purchase ${widget.hostingPackage.name}",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff651313),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xffFCD9CC).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Total Price",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  if (userProvider
                                          .userModel
                                          ?.user
                                          ?.bonusStatus ==
                                      "BonusAvailable") ...[
                                    Row(
                                      children: [
                                        Text(
                                          "\$${price % 1 == 0 ? price.toInt() : price.toStringAsFixed(2)}",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "${userProvider.discountPercentage}% OFF",
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "\$${(price * (1 - userProvider.discountPercentage / 100)).toStringAsFixed(2)}${widget.isYearly ? " /year" : " /month"}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFFEB4724),
                                      ),
                                    ),
                                  ] else
                                    Text(
                                      "\$${price % 1 == 0 ? price.toInt() : price.toStringAsFixed(2)}${widget.isYearly ? " /year" : " /month"}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFFEB4724),
                                      ),
                                    ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Method",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Text(
                                    "Waafipay",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xff651313),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Account Number",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff111827),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _accountController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: "Enter phone number",
                            prefixIcon: const Icon(
                              Icons.phone_android,
                              size: 20,
                            ),
                            hintStyle: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey.shade400,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade200,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade200,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFEB4724),
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: _isLocalLoading
                                ? null
                                : () async {
                                    if (_accountController.text.isEmpty) {
                                      ScaffoldMessenger.of(
                                        dialogContext,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Please enter account number",
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                    final userId =
                                        userProvider.userModel?.user?.id;
                                    if (userId == null) {
                                      ScaffoldMessenger.of(
                                        dialogContext,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "User session error. Please login again.",
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    setDialogState(() {
                                      _isLocalLoading = true;
                                    });

                                    final isBonusAvailable =
                                        userProvider
                                            .userModel
                                            ?.user
                                            ?.bonusStatus ==
                                        "BonusAvailable";
                                    final finalAmount = isBonusAvailable
                                        ? price *
                                              (1 -
                                                  userProvider
                                                          .discountPercentage /
                                                      100)
                                        : price;

                                    final success =
                                        await transactionProvider.CreateTransaction(
                                          userId: userId,
                                          amount: finalAmount,
                                          hostingPackageId:
                                              widget.hostingPackage.sId,
                                          description:
                                              "Hosting: ${widget.hostingPackage.name} (${widget.isYearly ? 'Yearly' : 'Monthly'})",
                                          paymentMethod: "Waafipay",
                                          accountNo: _accountController.text,
                                          context: dialogContext,
                                        );

                                    setDialogState(() {
                                      _isLocalLoading = false;
                                    });

                                    if (success) {
                                      Navigator.pop(
                                        dialogContext,
                                      ); // Close Purchase Sheet

                                      if (context.mounted) {
                                        // Update user points/bonus immediately
                                        context
                                            .read<UserProvider>()
                                            .refreshUser();

                                        CustomBottomSheet.showCongratulations(
                                          context: context,
                                          message:
                                              "Your hosting plan ${widget.hostingPackage.name} is now active!${isBonusAvailable ? ' (${userProvider.discountPercentage}% discount applied)' : ''}",
                                          onDone: () {
                                            Navigator.pop(
                                              context,
                                            ); // Return to previous page
                                          },
                                        );
                                      }
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff651313),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: _isLocalLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    "Confirm Purchase",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final features = widget.hostingPackage.features ?? [];
    final showExpandButton = features.length > 5;
    final displayedFeatures = isExpanded ? features : features.take(5).toList();
    final unitPrice = widget.hostingPackage.price ?? 0;
    final totalPrice = widget.isYearly ? unitPrice * 12 : unitPrice;

    return Consumer2<UserProvider, TransactionProvider>(
      builder: (context, userProvider, transactionProvider, child) {
        final box = GetStorage();
        final isLoggedIn = box.hasData(isLogged);

        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            color: const Color(0xffFCD9CC).withOpacity(0.35),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: widget.isMaxPrice
                  ? const Color(0xff651313).withOpacity(0.1)
                  : Colors.grey.withOpacity(0.08),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              if (widget.isMaxPrice)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xff651313),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(22),
                        bottomLeft: Radius.circular(22),
                      ),
                    ),
                    child: Text(
                      "MOST POPULAR",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.hostingPackage.name ?? "Plan",
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff111827),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (userProvider.userModel?.user?.bonusStatus ==
                        "BonusAvailable") ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "\$${totalPrice % 1 == 0 ? totalPrice.toInt() : totalPrice.toStringAsFixed(2)}",
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.grey,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "${userProvider.discountPercentage}% OFF",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            "\$${(totalPrice * (1 - userProvider.discountPercentage / 100)).toStringAsFixed(2)}",
                            style: GoogleFonts.outfit(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFEB4724),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.isYearly ? "/year" : "/month",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ] else
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            "\$${totalPrice % 1 == 0 ? totalPrice.toInt() : totalPrice.toStringAsFixed(2)}",
                            style: GoogleFonts.outfit(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFEB4724),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.isYearly ? "/year" : "/month",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 24),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFF3F4F6),
                    ),
                    const SizedBox(height: 24),
                    ...displayedFeatures.asMap().entries.map((entry) {
                      int index = entry.key;
                      String feature = entry.value;
                      // Only animate the first 5 items (initial load), extras appear instantly
                      final alreadyVisible = index < 5;
                      Widget item = Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEB4724).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                IconlyLight.tick_square,
                                color: Color(0xFFEB4724),
                                size: 14,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                feature,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: const Color(0xff4B5563),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                      return alreadyVisible
                          ? AnimatedFeatureItem(index: index, child: item)
                          : item;
                    }),
                    if (showExpandButton)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: InkWell(
                          onTap: () => setState(() => isExpanded = !isExpanded),
                          child: Row(
                            children: [
                              Text(
                                isExpanded ? "Show Less" : "Show All Features",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff111827),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                isExpanded
                                    ? IconlyLight.arrow_up_2
                                    : IconlyLight.arrow_down_2,
                                size: 20,
                                color: const Color(0xff111827),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          if (isLoggedIn) {
                            _showPurchaseDialog(
                              context,
                              userProvider,
                              transactionProvider,
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            ).then((_) {
                              if (GetStorage().hasData(isLogged)) {
                                _showPurchaseDialog(
                                  context,
                                  userProvider,
                                  transactionProvider,
                                );
                              }
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.isMaxPrice
                              ? const Color(0xff651313)
                              : const Color(0xFFEB4724),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shadowColor:
                              (widget.isMaxPrice
                                      ? const Color(0xff651313)
                                      : const Color(0xFFEB4724))
                                  .withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          "Purchase Plan",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AnimatedFeatureItem extends StatefulWidget {
  final int index;
  final Widget child;
  const AnimatedFeatureItem({
    super.key,
    required this.index,
    required this.child,
  });

  @override
  State<AnimatedFeatureItem> createState() => _AnimatedFeatureItemState();
}

class _AnimatedFeatureItemState extends State<AnimatedFeatureItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _opacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _slide = Tween<Offset>(
      begin: const Offset(0.0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Staggered delay: 200ms per item
    Future.delayed(Duration(milliseconds: widget.index * 200), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
