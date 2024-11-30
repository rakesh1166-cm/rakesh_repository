import 'dart:convert';

class CartSite {
  final int id;
  final String cartId;
  final String infuAdminId;
  final String adminId;
  final String socialsite;
  final String currencies;

  CartSite({
    required this.id,
    required this.cartId,
    required this.infuAdminId,
    required this.adminId,
    required this.socialsite,
    required this.currencies,
  });

  // Factory method to create an instance from JSON
  factory CartSite.fromJson(Map<String, dynamic> json) {
    return CartSite(
      id: json['id'],
      cartId: json['cart_id'] ?? '',
      infuAdminId: json['infu_admin_id'] ?? '',
      adminId: json['admin_id'] ?? '',
      socialsite: json['socialsite'] ?? '',
      currencies: json['currencies'] ?? '',
    );
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cart_id': cartId,
      'infu_admin_id': infuAdminId,
      'admin_id': adminId,
      'socialsite': socialsite,
      'currencies': currencies,
    };
  }
}
