import 'package:deero_enterprise_app/core/constant.dart';
import 'package:deero_enterprise_app/features/auth/controllers/user_provider.dart';
import 'package:deero_enterprise_app/features/auth/pages/login_page.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/service_provider.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/transaction_provider.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/models/service_model.dart';
import 'package:deero_enterprise_app/core/widgets/custom_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:material_dialogs/material_dialogs.dart';

class AdvertServicepage extends StatefulWidget {
  const AdvertServicepage({super.key});

  @override
  State<AdvertServicepage> createState() => _AdvertServicepageState();
}

class _AdvertServicepageState extends State<AdvertServicepage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
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
            elevation: 0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text(
              "Our Services",
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xff111827),
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
  const PackageCard({super.key, required this.package, this.serviceId});

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
    Dialogs.bottomMaterialDialog(
      context: context,
      title: "Purchase ${widget.package.packageTitle}",
      titleStyle: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: const Color(0xff651313),
      ),
      customView: StatefulBuilder(
        builder: (context, setDialogState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
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
                          Text(
                            "\$${widget.package.price?.toStringAsFixed(0)}",
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
                    prefixIcon: const Icon(Icons.phone_android, size: 20),
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
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFEB4724)),
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
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please enter account number"),
                                ),
                              );
                              return;
                            }
                            final userId = userProvider.userModel?.user?.id;
                            if (userId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
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

                            final success =
                                await transactionProvider.CreateTransaction(
                                  userId: userId,
                                  amount: widget.package.price ?? 0,
                                  serviceId: widget.serviceId,
                                  packageId: widget.package.sId,
                                  paymentMethod: "Waafipay",
                                  accountNo: _accountController.text,
                                  context: context,
                                );

                            setDialogState(() {
                              _isLocalLoading = false;
                            });

                            if (success) {
                              Navigator.pop(context); // Close Purchase Sheet
                              CustomBottomSheet.showCongratulations(
                                context: context,
                                message:
                                    "Your purchase for ${widget.package.packageTitle} was successful!",
                              );
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
                const SizedBox(height: 20),
              ],
            ),
          );
        },
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
                Text(
                  "\$${widget.package.price?.toStringAsFixed(0) ?? "0"}",
                  style: GoogleFonts.outfit(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFEB4724),
                  ),
                ),
                const SizedBox(height: 10),
                Divider(height: 1, thickness: 1, color: Colors.grey.shade300),
                const SizedBox(height: 24),
                ...displayedFeatures.map((feature) {
                  return Padding(
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
                            Icons.check,
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
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
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
                        );
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
