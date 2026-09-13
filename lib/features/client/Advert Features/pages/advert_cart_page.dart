import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:iconly/iconly.dart';
import 'package:animate_do/animate_do.dart';
import 'package:deero_advert_app/core/themes/color_page.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/cart_provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/navigation_provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/service_provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/models/cart_item_model.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_domains_page.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_servicepage.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_hostingpage.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/widgets/advert_cart_checkout_sheet.dart';

class AdvertCartPage extends StatelessWidget {
  const AdvertCartPage({super.key});

  void _showClearCartDialog(BuildContext context, CartProvider cartProvider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Clear Cart?",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF651313),
          ),
        ),
        content: Text(
          "Are you sure you want to remove all items from your cart?",
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: const Color(0xFF4B5563),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              "Cancel",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              cartProvider.clearCart();
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              "Clear All",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: bgColor,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF651313),
              size: 22,
            ),
          ),
          centerTitle: true,
          title: Consumer<CartProvider>(
            builder: (context, cart, _) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Shopping Cart",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF651313),
                    ),
                  ),
                  if (cart.totalItems > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEB4724),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${cart.totalItems}",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
          actions: [
            Consumer<CartProvider>(
              builder: (context, cart, _) {
                if (cart.totalItems == 0) return const SizedBox.shrink();
                return IconButton(
                  onPressed: () => _showClearCartDialog(context, cart),
                  icon: const Icon(
                    IconlyLight.delete,
                    color: Color(0xFFEB4724),
                    size: 22,
                  ),
                  tooltip: "Clear Cart",
                );
              },
            ),
          ],
        ),
        body: Consumer<CartProvider>(
          builder: (context, cartProvider, _) {
            final items = cartProvider.cartItems;

            if (items.isEmpty) {
              return _buildEmptyCart(context);
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return FadeInUp(
                        duration: Duration(milliseconds: 250 + (index * 60)),
                        child: _buildCartItemCard(context, item, cartProvider),
                      );
                    },
                  ),
                ),
                _buildBottomSummary(context, cartProvider),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInDown(
              duration: const Duration(milliseconds: 500),
              child: Center(
                child: Text(
                  "Your Cart is Empty",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF651313),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToItem(BuildContext context, CartItem item) {
    final type = item.type.toLowerCase();
    if (type == 'service') {
      int targetIndex = 0;
      try {
        final serviceProvider = Provider.of<ServiceProvider>(
          context,
          listen: false,
        );
        final services = serviceProvider.serviceModel?.data;
        if (services != null && services.isNotEmpty) {
          final idx = services.indexWhere((s) {
            final titleMatch =
                (s.serviceTitle ?? '').trim().toLowerCase() ==
                item.title.trim().toLowerCase();
            final packageMatch = (s.packages ?? []).any(
              (p) =>
                  p.sId == item.id ||
                  (p.packageTitle ?? '').trim().toLowerCase() ==
                      item.subtitle.trim().toLowerCase() ||
                  (p.packageTitle != null &&
                      item.subtitle.toLowerCase().contains(
                        p.packageTitle!.toLowerCase(),
                      )),
            );
            return titleMatch || packageMatch;
          });
          if (idx != -1) {
            targetIndex = idx;
          }
        }
      } catch (_) {}

      try {
        final navProvider = Provider.of<NavigationProvider>(
          context,
          listen: false,
        );
        navProvider.navigateToService(targetIndex);
        Navigator.popUntil(context, (route) => route.isFirst);
      } catch (_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AdvertServicepage(initialIndex: targetIndex),
          ),
        );
      }
    } else if (type == 'hosting') {
      try {
        final navProvider = Provider.of<NavigationProvider>(
          context,
          listen: false,
        );
        navProvider.setPageIndex(3);
        Navigator.popUntil(context, (route) => route.isFirst);
      } catch (_) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AdvertHostingpage()),
        );
      }
    } else if (type == 'domain') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AdvertDomainsPage(searchedDomain: item.subtitle),
        ),
      );
    }
  }

  Widget _buildCartItemCard(
    BuildContext context,
    CartItem item,
    CartProvider cartProvider,
  ) {
    // Clean display title so category name is not duplicated
    String displayTitle = item.subtitle;
    if (item.title.isNotEmpty &&
        displayTitle.toLowerCase().startsWith(
          '${item.title.toLowerCase()} - ',
        )) {
      displayTitle = displayTitle.substring(item.title.length + 3).trim();
    } else if (displayTitle.contains(' - ')) {
      final parts = displayTitle.split(' - ');
      if (parts.length > 1 &&
          parts[0].trim().toLowerCase() == item.title.trim().toLowerCase()) {
        displayTitle = parts.sublist(1).join(' - ').trim();
      }
    }

    String displaySubtitle;
    if (item.type.toLowerCase() == 'hosting') {
      displaySubtitle = "Hosting Package";
    } else if (item.type.toLowerCase() == 'domain') {
      displaySubtitle = "Domain Registration";
    } else {
      displaySubtitle = item.title.isNotEmpty ? item.title : "Service Package";
    }

    final itemTotalPrice = item.price * item.quantity;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEF2F6), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _navigateToItem(context, item),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Title + Red Delete Trash Icon
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        displayTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0F172A),
                          height: 1.25,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => cartProvider.removeFromCart(
                        item.id,
                        context: context,
                        title: item.subtitle,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          IconlyLight.delete,
                          color: Color(0xFF651313),
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
                // const SizedBox(height: 3),

                // Subtitle (Category / Package type)
                Text(
                  displaySubtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF64748B),
                  ),
                ),

                const SizedBox(height: 8),

                // Bottom Row: Price (Brand color) + Quantity Counter Pill
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Price with USD currency
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          "\$${itemTotalPrice.toStringAsFixed(2)}",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFEB4724),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "USD",
                          style: GoogleFonts.poppins(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),

                    // Quantity Counter Pill: [-  1  +]
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 3,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () => cartProvider.decrementQuantity(
                              item.id,
                              context: context,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            child: const Padding(
                              padding: EdgeInsets.all(5),
                              child: Icon(
                                Icons.remove_rounded,
                                size: 16,
                                color: Color(0xFF334155),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "${item.quantity}",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () =>
                                cartProvider.incrementQuantity(item.id),
                            borderRadius: BorderRadius.circular(16),
                            child: const Padding(
                              padding: EdgeInsets.all(5),
                              child: Icon(
                                Icons.add_rounded,
                                size: 16,
                                color: Color(0xFF334155),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSummary(BuildContext context, CartProvider cartProvider) {
    final total = cartProvider.cartTotal;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Total Row Box (Soft branded tint container)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        "\$${total.toStringAsFixed(2)}",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFEB4724),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "USD",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFEB4724),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Proceed to Checkout Button (Brand Color with Arrow)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  AdvertCartCheckoutSheet.show(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF651313),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Proceed to Checkout",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
