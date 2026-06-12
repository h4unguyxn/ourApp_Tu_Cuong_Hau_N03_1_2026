import 'san_pham.dart';

class CartItem {
  SanPham sanPham;
  String? selectedSize;
  double gia;
  int quantity;

  CartItem({
    required this.sanPham,
    this.selectedSize,
    required this.gia,
    this.quantity = 1,
  });

  double get total => gia * quantity;

  String get ten {
    if (selectedSize == null || selectedSize!.isEmpty) {
      return sanPham.ten;
    }
    return "${sanPham.ten} (${selectedSize})";
  }

  Map<String, dynamic> toMap() {
    return {
      'sanPham': sanPham.toMap(),
      'selectedSize': selectedSize,
      'gia': gia,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      sanPham: SanPham.fromMap(
        Map<String, dynamic>.from(map['sanPham']),
      ),
      selectedSize: map['selectedSize'],
      gia: (map['gia'] as num? ?? 0).toDouble(),
      quantity: map['quantity'] as int? ?? 1,
    );
  }
}