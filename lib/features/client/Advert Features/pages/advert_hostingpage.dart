import 'package:deero_enterprise_app/features/auth/pages/login_page.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/hosting_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AdvertHostingpage extends StatefulWidget {
  const AdvertHostingpage({super.key});

  @override
  State<AdvertHostingpage> createState() => _AdvertHostingpageState();
}

class _AdvertHostingpageState extends State<AdvertHostingpage> {
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

  bool isYearly = false; // false = Monthly, true = Yearly

  @override
  Widget build(BuildContext context) {
    return Consumer<HostingProvider>(
      builder: (context, hostingprovider, _) {
        final hosting = hostingprovider.hostingModel?.data ?? [];
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Text(
                    "Web Hosting Packages",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Monthly",
                        style: GoogleFonts.poppins(
                          color: !isYearly
                              ? const Color(0xFFEB4724)
                              : Colors.grey,
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
                          color: isYearly
                              ? const Color(0xFFEB4724)
                              : Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  hostingprovider.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Expanded(
                          child: ListView.separated(
                            itemCount: hosting.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final indexhosting = hosting[index];
                              final price = isYearly
                                  ? (indexhosting.price ?? 0) * 12
                                  : (indexhosting.price ?? 0);
                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: const Color(0xffFCD9CC),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.1),
                                  ),
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
                                        borderRadius:
                                            const BorderRadius.vertical(
                                              top: Radius.circular(20),
                                            ),
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.withOpacity(0.2),
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              indexhosting.name ?? "Plan",
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
                                              "\$${(price).toStringAsFixed(2)}${isYearly ? " /year" : " /month"}",
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ...(indexhosting.features ?? []).map((
                                            feature,
                                          ) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 12,
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: 2,
                                                        ),
                                                    child: Icon(
                                                      Icons.check,
                                                      color: const Color(
                                                        0xff651313,
                                                      ),
                                                      size: 18,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Text(
                                                      feature,
                                                      style:
                                                          GoogleFonts.poppins(
                                                            fontSize: 14,
                                                            color: const Color(
                                                              0xff651313,
                                                            ),
                                                            height: 1.4,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        20,
                                        0,
                                        20,
                                        20,
                                      ),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(
                                              0xFFEB4724,
                                            ),
                                            elevation: 0,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 14,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
