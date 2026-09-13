import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/models/cart_item_model.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_cart_page.dart';

class CartProvider extends ChangeNotifier {
  final GetStorage _box = GetStorage();
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;
  int get totalItems => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get cartTotal =>
      _cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  double get originalTotal => _cartItems.fold(
      0.0,
      (sum, item) =>
          sum + ((item.originalAmount ?? item.price) * item.quantity));
  double get totalDiscount => _cartItems.fold(
      0.0, (sum, item) => sum + ((item.discountApplied ?? 0.0) * item.quantity));

  CartProvider() {
    loadCart();
  }

  String _getStorageKey() {
    try {
      final userInfo = _box.read("userInfo");
      String? userId;
      if (userInfo is Map) {
        if (userInfo['user'] is Map) {
          userId = userInfo['user']['id']?.toString();
        } else if (userInfo['id'] != null) {
          userId = userInfo['id']?.toString();
        }
      }
      return userId != null ? "deero_cart_$userId" : "deero_cart_guest";
    } catch (_) {
      return "deero_cart_guest";
    }
  }

  void loadCart() {
    try {
      dynamic savedData = _box.read("deero_global_cart_items");
      if (savedData == null) {
        final key = _getStorageKey();
        savedData = _box.read(key);
      }
      if (savedData == null) {
        savedData = _box.read("deero_cart_guest");
      }
      if (savedData == null) {
        final jsonRaw = _box.read("deero_global_cart_items_json");
        if (jsonRaw != null && jsonRaw is String) {
          savedData = jsonDecode(jsonRaw);
        }
      }

      if (savedData != null) {
        if (savedData is String) {
          final decoded = jsonDecode(savedData);
          if (decoded is List) {
            _cartItems = decoded
                .map((item) => CartItem.fromJson(Map<String, dynamic>.from(item is String ? jsonDecode(item) : item)))
                .toList();
          }
        } else if (savedData is List) {
          _cartItems = savedData
              .map((item) => CartItem.fromJson(Map<String, dynamic>.from(item is String ? jsonDecode(item) : item)))
              .toList();
        }
      }
    } catch (e) {
      debugPrint("Error loading cart: $e");
    }
    notifyListeners();
  }

  void _saveCart() {
    try {
      final list = _cartItems.map((item) => item.toJson()).toList();
      final jsonStr = jsonEncode(list);
      _box.write("deero_global_cart_items", list);
      _box.write("deero_global_cart_items_json", jsonStr);
      final key = _getStorageKey();
      _box.write(key, list);
      _box.save();
    } catch (e) {
      debugPrint("Error saving cart: $e");
    }
  }

  bool isInCart(String idOrSubtitle) {
    return _cartItems.any(
      (item) => item.id == idOrSubtitle || item.subtitle.toLowerCase() == idOrSubtitle.toLowerCase(),
    );
  }

  void addToCart(CartItem item, {BuildContext? context}) {
    final index = _cartItems.indexWhere(
      (i) => i.id == item.id || i.subtitle.toLowerCase() == item.subtitle.toLowerCase(),
    );

    if (index >= 0) {
      if (context != null && context.mounted) {
        _showCartSnackBar(context, item.subtitle, isAdded: false, isAlready: true);
      }
      return;
    }

    _cartItems.add(item);
    _saveCart();
    notifyListeners();

    if (context != null && context.mounted) {
      _showCartSnackBar(context, item.subtitle, isAdded: true);
    }
  }

  void removeFromCart(String id, {BuildContext? context, String? title}) {
    final removed = _cartItems.firstWhere(
      (item) => item.id == id,
      orElse: () => CartItem(id: '', type: '', title: '', subtitle: title ?? '', price: 0),
    );
    _cartItems.removeWhere((item) => item.id == id);
    _saveCart();
    notifyListeners();

    if (context != null && context.mounted) {
      _showCartSnackBar(context, removed.subtitle.isNotEmpty ? removed.subtitle : (title ?? 'Item'), isAdded: false);
    }
  }

  void toggleCartItem(CartItem item, {BuildContext? context}) {
    if (isInCart(item.id) || isInCart(item.subtitle)) {
      removeFromCart(item.id, context: context, title: item.subtitle);
    } else {
      addToCart(item, context: context);
    }
  }

  void incrementQuantity(String id) {
    final index = _cartItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      _cartItems[index].quantity++;
      _saveCart();
      notifyListeners();
    }
  }

  void decrementQuantity(String id, {BuildContext? context}) {
    final index = _cartItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
        _saveCart();
        notifyListeners();
      } else {
        removeFromCart(id, context: context, title: _cartItems[index].subtitle);
      }
    }
  }

  void clearCart() {
    _cartItems.clear();
    _saveCart();
    notifyListeners();
  }

  void _showCartSnackBar(BuildContext context, String itemName,
      {bool isAdded = true, bool isAlready = false}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        elevation: 6,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        backgroundColor: const Color(0xFF651313),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isAlready
                    ? Colors.orange.withOpacity(0.2)
                    : (isAdded ? const Color(0xFFEB4724) : Colors.grey.withOpacity(0.3)),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isAlready
                    ? Icons.info_outline
                    : (isAdded ? IconlyLight.tick_square : IconlyLight.delete),
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAlready
                        ? "Already in cart"
                        : (isAdded ? "Added to Cart" : "Removed from Cart"),
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFCD7C3),
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    itemName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            if (isAdded) ...[
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdvertCartPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEB4724),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "View Cart ($totalItems)",
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
