import 'package:flutter/foundation.dart';
import '../entities/cart_item.dart';

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<CartItem> items = [];

  void add(CartItem item) {
    // Kiểm tra xem đã có món này + size chưa
    final index = items.indexWhere((e) =>
        e.sanPham.id == item.sanPham.id &&
        (e.selectedSize ?? '') == (item.selectedSize ?? ''));

    if (index >= 0) {
      // Nếu đã có → tăng quantity
      items[index].quantity += item.quantity;
    } else {
      items.add(item);
    }

    notifyListeners();
  }

  void remove(CartItem item) {
    items.remove(item);
    notifyListeners();
  }

  void decrease(CartItem item) {
    final index = items.indexWhere((e) =>
        e.sanPham.id == item.sanPham.id &&
        (e.selectedSize ?? '') == (item.selectedSize ?? ''));
    if (index >= 0) {
      if (items[index].quantity > 1) {
        items[index].quantity--;
      } else {
        items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clear() {
    items.clear();
    notifyListeners();
  }

  double get total =>
      items.fold(0, (sum, e) => sum + (e.gia * e.quantity));

  int get count => items.length;

  int quantityOf(String productId, [String? size]) {
    final index = items.indexWhere(
        (e) => e.sanPham.id == productId && (e.selectedSize ?? '') == (size ?? ''));
    if (index >= 0) return items[index].quantity;
    return 0;
  }
}