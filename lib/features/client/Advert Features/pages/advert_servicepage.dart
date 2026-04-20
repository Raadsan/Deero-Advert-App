import 'package:deero_enterprise_app/core/constant.dart';
import 'package:deero_enterprise_app/features/auth/controllers/user_provider.dart';
import 'package:deero_enterprise_app/features/auth/pages/login_page.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/service_provider.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/transaction_provider.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/models/service_model.dart';
import 'package:deero_enterprise_app/core/widgets/transaction_receipt_bottomsheet.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:iconly/iconly.dart';

class AdvertServicepage extends StatefulWidget {
  final int initialIndex;
  const AdvertServicepage({super.key, this.initialIndex = 0});

  @override
  State<AdvertServicepage> createState() => _AdvertServicepageState();
}

class _AdvertServicepageState extends State<AdvertServicepage> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ServiceProvider>();
      if (provider.serviceModel == null && !provider.isLoading) {
        provider.getAllServices();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceProvider>(
      builder: (context, serviceProvider, child) {
        final services = serviceProvider.serviceModel?.data ?? [];

        return Scaffold(
          backgroundColor: const Color(0xFFF9FAFB),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF9FAFB),
            surfaceTintColor: const Color(0xFFF9FAFB),
            systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarColor: const Color(0xFFF9FAFB),
            ),
            elevation: 0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            leading: Navigator.canPop(context)
                ? IconButton(
                    icon: const Icon(
                      IconlyLight.arrow_left_2,
                      color: Colors.black,
                      size: 20,
                    ),
                    onPressed: () => Navigator.pop(context),
                  )
                : null,
            title: Text(
              "Our Services",
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: const Color(0xff651313),
              ),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              // Modern Category Row
              SizedBox(
                height: 55,
                child: serviceProvider.isLoading
                    ? ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: 4,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) => Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: services.length,
                        itemBuilder: (context, index) {
                          final service = services[index];
                          final isSelected = _selectedIndex == index;
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: InkWell(
                              onTap: () =>
                                  setState(() => _selectedIndex = index),
                              borderRadius: BorderRadius.circular(16),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xff651313)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: const Color(
                                              0xff651313,
                                            ).withOpacity(0.3),
                                            blurRadius: 12,
                                            offset: const Offset(0, 6),
                                          ),
                                        ]
                                      : [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.03,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xff651313)
                                        : Colors.grey.withOpacity(0.1),
                                    width: 1.5,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    service.serviceTitle ?? "Service",
                                    style: GoogleFonts.outfit(
                                      fontSize: 15,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w600,
                                      color: isSelected
                                          ? Colors.white
                                          : const Color(0xff4B5563),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: serviceProvider.isLoading
                        ? PackageCardShimmer()
                        : Column(
                            key: ValueKey<int>(_selectedIndex),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              if (services[_selectedIndex].packages != null &&
                                  services[_selectedIndex].packages!.isNotEmpty)
                                ...services[_selectedIndex].packages!.map(
                                  (package) => PackageCard(
                                    package: package,
                                    serviceId: services[_selectedIndex].sId,
                                    serviceTitle:
                                        services[_selectedIndex].serviceTitle,
                                  ),
                                )
                              else
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Center(
                                    child: Text(
                                      "No packages available yet.",
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 30),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PackageCardShimmer extends StatelessWidget {
  const PackageCardShimmer({super.key});

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
                          width: 60,
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

class PackageCard extends StatefulWidget {
  final Packages package;
  final String? serviceId;
  final String? serviceTitle;
  const PackageCard({
    super.key,
    required this.package,
    this.serviceId,
    this.serviceTitle,
  });

  @override
  State<PackageCard> createState() => _PackageCardState();
}

class _PackageCardState extends State<PackageCard> {
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      "Purchase ${widget.package.packageTitle}",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff651313),
                      ),
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
                              Expanded(
                                child: Column(
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
                                            "\$${(widget.package.price ?? 0) % 1 == 0 ? (widget.package.price ?? 0).toInt() : (widget.package.price ?? 0).toStringAsFixed(2)}",
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
                                        "\$${((widget.package.price ?? 0) * (1 - userProvider.discountPercentage / 100)).toStringAsFixed(2)}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFFEB4724),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        child: Text(
                                          "Note: Your bonus points will reset after using this discount.",
                                          style: GoogleFonts.poppins(
                                            fontSize: 10,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.orange.shade800,
                                          ),
                                        ),
                                      ),
                                    ] else
                                      Text(
                                        "\$${(widget.package.price ?? 0) % 1 == 0 ? (widget.package.price ?? 0).toInt() : (widget.package.price ?? 0).toStringAsFixed(2)}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFFEB4724),
                                        ),
                                      ),
                                  ],
                                ),
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
                                        ? (widget.package.price ?? 0) *
                                              (1 -
                                                  userProvider
                                                          .discountPercentage /
                                                      100)
                                        : (widget.package.price ?? 0);

                                    final success =
                                        await transactionProvider.CreateTransaction(
                                          userId: userId,
                                          amount: finalAmount,
                                          serviceId: widget.serviceId,
                                          packageId: widget.package.sId,
                                          description:
                                              "${widget.serviceTitle ?? 'Service'} - ${widget.package.packageTitle ?? 'Plan'}",
                                          paymentMethod: "Waafipay",
                                          accountNo: _accountController.text,
                                          useBonus:
                                              isBonusAvailable, // ✅ FIX: resets bonus in backend
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

                                        TransactionReceiptBottomSheet.show(
                                          context: context,
                                          userName:
                                              userProvider
                                                  .userModel
                                                  ?.user
                                                  ?.fullname ??
                                              "User",
                                          description:
                                              "${widget.serviceTitle ?? 'Service'} - ${widget.package.packageTitle ?? 'Plan'}",
                                          amount: finalAmount,
                                          originalAmount:
                                              (widget.package.price ?? 0)
                                                  .toDouble(),
                                          discountAmount: isBonusAvailable
                                              ? ((widget.package.price ?? 0) -
                                                        finalAmount)
                                                    .toDouble()
                                              : 0,
                                          date: DateFormat(
                                            'MMM dd, yyyy • hh:mm a',
                                          ).format(DateTime.now()),
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
    final features = widget.package.features ?? [];
    final showExpandButton = features.length > 5;
    final displayedFeatures = isExpanded ? features : features.take(5).toList();

    return Consumer2<UserProvider, TransactionProvider>(
      builder: (context, userProvider, transactionProvider, child) {
        final box = GetStorage();
        final isLoggedIn = box.hasData(isLogged);

        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            color: const Color(0xffFCD9CC).withOpacity(0.35),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.withOpacity(0.08), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.package.packageTitle ?? "Plan",
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
                        "\$${(widget.package.price ?? 0) % 1 == 0 ? (widget.package.price ?? 0).toInt() : (widget.package.price ?? 0).toStringAsFixed(2)}",
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
                  Text(
                    "\$${((widget.package.price ?? 0) * (1 - userProvider.discountPercentage / 100)).toStringAsFixed(2)}",
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFEB4724),
                    ),
                  ),
                ] else
                  Text(
                    "\$${(widget.package.price ?? 0) % 1 == 0 ? (widget.package.price ?? 0).toInt() : (widget.package.price ?? 0).toStringAsFixed(2)}",
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFEB4724),
                    ),
                  ),
                const SizedBox(height: 10),
                Divider(height: 1, thickness: 1, color: Colors.grey.shade300),
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
                      backgroundColor: const Color(0xFFEB4724),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shadowColor: const Color(0xFFEB4724).withOpacity(0.3),
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
