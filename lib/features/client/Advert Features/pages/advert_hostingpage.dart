import 'package:deero_enterprise_app/core/constant.dart';
import 'package:deero_enterprise_app/features/auth/controllers/user_provider.dart';
import 'package:deero_enterprise_app/features/auth/pages/login_page.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/hosting_provider.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/transaction_provider.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/models/hosting_model.dart'
    as hosting;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

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
        final hosting = hostingProvider.hostingModel?.data ?? [];

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text(
              "Web Hosting Packages",
              style: GoogleFonts.poppins(
                fontSize: 20,
                letterSpacing: 2.0,
                fontWeight: FontWeight.w500,
                color: const Color(0xff111827),
              ),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Monthly/Yearly Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Monthly",
                    style: GoogleFonts.poppins(
                      color: !isYearly ? const Color(0xFFEB4724) : Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Switch(
                    value: isYearly,
                    activeColor: const Color(0xFFEB4724),
                    onChanged: (value) {
                      setState(() {
                        isYearly = value;
                      });
                    },
                  ),
                  Text(
                    "Yearly",
                    style: GoogleFonts.poppins(
                      color: isYearly ? const Color(0xFFEB4724) : Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: hostingProvider.isLoading
                      ? const HostingPackageCardShimmer()
                      : Builder(
                          builder: (context) {
                            // Find the maximum price
                            final maxPrice = hosting.isEmpty
                                ? 0.0
                                : hosting
                                      .map((h) => h.price ?? 0.0)
                                      .reduce((a, b) => a > b ? a : b);

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                if (hosting.isNotEmpty)
                                  ...hosting.map(
                                    (hostingPackage) => HostingPackageCard(
                                      hostingPackage: hostingPackage,
                                      isYearly: isYearly,
                                      isMaxPrice:
                                          (hostingPackage.price ?? 0.0) ==
                                          maxPrice,
                                    ),
                                  )
                                else
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Center(
                                      child: Text(
                                        "No hosting packages available yet.",
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 30),
                              ],
                            );
                          },
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

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              title: Text(
                "Purchase ${widget.hostingPackage.name}",
                style: GoogleFonts.poppins(
                  letterSpacing: 1,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff651313),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Price: \$${price.toStringAsFixed(2)}${widget.isYearly ? " /year" : " /month"}",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFEB4724),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "Payment Method Waafipay",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Text(
                    "Account Number",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your account number";
                      }
                      return null;
                    },
                    controller: _accountController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "Enter phone number",
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade400,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.poppins(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_accountController.text.isEmpty) {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter account number"),
                        ),
                      );
                      return;
                    }
                    if (ctx.mounted) {
                      setDialogState(() {
                        _isLocalLoading = true;
                      });
                    }

                    final success = await transactionProvider.CreateTransaction(
                      userId: userProvider.userModel!.user!.id!,
                      amount: price,
                      hostingPackageId: widget.hostingPackage.sId,
                      paymentMethod: "Waafipay",
                      accountNo: _accountController.text,
                      context: context,
                    );

                    if (ctx.mounted) {
                      setDialogState(() {
                        _isLocalLoading = false;
                      });
                    }

                    if (success) {
                      if (ctx.mounted) {
                        Navigator.pop(ctx);
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Purchase successful!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {}
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff651313),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLocalLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "Confirm",
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final features = widget.hostingPackage.features ?? [];
    final showExpandButton = features.length > 4;
    final displayedFeatures = isExpanded ? features : features.take(4).toList();
    final price = widget.isYearly
        ? (widget.hostingPackage.price ?? 0) * 12
        : (widget.hostingPackage.price ?? 0);

    return Consumer2<UserProvider, TransactionProvider>(
      builder: (context, userProvider, transactionProvider, child) {
        final box = GetStorage();
        final isLoggedIn = box.hasData(isLogged);

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: const Color(0xffFCD9CC),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.hostingPackage.name ?? "Plan",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff651313),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Text(
                        "\$${price.toStringAsFixed(2)}${widget.isYearly ? " /year" : " /month"}",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFEB4724),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...displayedFeatures.map((feature) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Icon(
                                Icons.check,
                                color: const Color(0xff651313),
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                feature,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: const Color(0xff651313),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    if (showExpandButton)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  isExpanded
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Expand Feature",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: SizedBox(
                  width: double.infinity,
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
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.isMaxPrice
                          ? const Color(0xff651313)
                          : const Color(0xFFEB4724),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Purchase Plan",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
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
