import 'package:deero_advert_app/core/constant.dart';
import 'package:deero_advert_app/core/themes/color_page.dart';
import 'package:deero_advert_app/features/auth/controllers/user_provider.dart';
import 'package:deero_advert_app/features/auth/pages/login_page.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/transaction_provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:get_storage/get_storage.dart';
import 'package:deero_advert_app/core/widgets/transaction_receipt_bottomsheet.dart';
import 'package:animate_do/animate_do.dart';
import 'package:shimmer/shimmer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';

class AdvertHistorypage extends StatefulWidget {
  const AdvertHistorypage({super.key});

  @override
  State<AdvertHistorypage> createState() => _AdvertHistorypageState();
}

class _AdvertHistorypageState extends State<AdvertHistorypage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLoginAndFetchHistory();
    });
  }

  void _checkLoginAndFetchHistory() {
    final userProvider = context.read<UserProvider>();
    final box = GetStorage();
    final isLoggedIn = box.read(isLogged) ?? false;

    if (!isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      final userId = userProvider.userModel?.user?.id;
      if (userId != null) {
        context.read<TransactionProvider>().getTransactionHistoryByUserId(
          userId,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: bgColor,
        ),
        backgroundColor: const Color(0xFFF9FAFB),
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: Color(0xff660E0D),
          ),
        ),
        title: Text(
          "Transaction History",
          style: GoogleFonts.poppins(
            color: const Color(0xff660E0D),
            fontSize: 18,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const HistoryShimmer();
          }

          if (provider.errorMessage.isNotEmpty) {
            final needsLogin = provider.errorMessage == "LOGIN_REQUIRED";
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xffFFF6F0),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        needsLogin
                            ? Icons.lock_outline_rounded
                            : Icons.error_outline,
                        size: 48,
                        color: needsLogin
                            ? const Color(0xffEF7044)
                            : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      needsLogin ? "Gal account-kaaga" : "Something went wrong",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff111827),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      needsLogin
                          ? "Waxaad u baahan tahay inaad login gasho si aad u aragto taariikhda lacag bixintaada. Haddii aad horey u login gashay, mar kale isku day (session-ku wuu dhamaaday)."
                          : provider.errorMessage,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        height: 1.45,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 28),
                    if (needsLogin) ...[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            ).then((_) {
                              if (!context.mounted) return;
                              context.read<TransactionProvider>().errorMessage =
                                  "";
                              _checkLoginAndFetchHistory();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff660E0D),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Login",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xff660E0D),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: Color(0xff660E0D)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Back",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      ElevatedButton(
                        onPressed: _checkLoginAndFetchHistory,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEB4724),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Retry",
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }

          final allTransactions = provider.transactionModel?.transactions ?? [];
          final transactions = allTransactions
              .where(
                (tx) =>
                    tx.status?.toLowerCase() == 'success' ||
                    tx.status?.toLowerCase() == 'completed',
              )
              .toList();

          if (transactions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    "No successful transactions yet",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final tx = transactions[index];
              final date =
                  DateTime.tryParse(tx.createdAt ?? "") ?? DateTime.now();
              final formattedDate = DateFormat(
                'MMM dd, yyyy • hh:mm a',
              ).format(date);

              return FadeInUp(
                duration: Duration(milliseconds: 300 + (index * 50)),
                child: GestureDetector(
                  onTap: () => _showTransactionDetail(context, tx),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Container(
                        //   padding: const EdgeInsets.all(12),
                        //   decoration: BoxDecoration(
                        //     color: _getStatusColor(tx.status).withOpacity(0.1),
                        //     shape: BoxShape.circle,
                        //   ),
                        //   child: Image.asset(
                        //     "images/advertimages/advertlogo.png",
                        //     height: 24,
                        //     width: 24,
                        //   ),
                        // ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tx.description ?? "Service Purchase",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: const Color(0xff111827),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formattedDate,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "\$${(tx.amount ?? 0) % 1 == 0 ? (tx.amount ?? 0).toInt() : (tx.amount ?? 0).toStringAsFixed(2)}",
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: const Color(0xff111827),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xff00BD8B).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                tx.status?.toUpperCase() ?? "UNKNOWN",
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff00BD8B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showTransactionDetail(BuildContext context, Transactions tx) {
    TransactionReceiptBottomSheet.show(
      context: context,
      userName: tx.user?.fullname ?? "User",
      description: tx.description ?? "Service Purchase",
      amount: tx.amount ?? 0,
      originalAmount: tx.originalAmount,
      discountAmount: tx.discountApplied,
      date: DateFormat('MMM dd, yyyy • hh:mm a').format(
        DateTime.tryParse(tx.createdAt ?? "") ?? DateTime.now(),
      ),
    );
  }
}

class HistoryShimmer extends StatelessWidget {
  const HistoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        final transactionList =
            transactionProvider.transactionModel?.transactions ?? [];
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: 5,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade200,
                highlightColor: Colors.grey.shade50,
                child: Row(
                  children: [
                    Container(
                      height: 48,
                      width: 48,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 16,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 12,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 18,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 16,
                          width: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
