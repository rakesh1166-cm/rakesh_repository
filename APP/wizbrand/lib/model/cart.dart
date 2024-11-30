import 'dart:convert';

class UserCart {
  final int id;
  final int adminId;
  final int cartId;
  final int influencerAdminId;
  final String adminEmail;
  final String userName;
  final String slug;
  final String influencerEmail;
  final String cartSocials;
  final String unpaidCartSocials;
  final String currency;

  UserCart({
    required this.id,
    required this.adminId,
    required this.cartId,
    required this.influencerAdminId,
    required this.adminEmail,
    required this.userName,
    required this.slug,
    required this.influencerEmail,
    required this.cartSocials,
    required this.unpaidCartSocials,
    required this.currency,
  });

  factory UserCart.fromJson(Map<String, dynamic> json) {
    return UserCart(
      id: json['id'],
      adminId: json['admin_id'],
      cartId: json['cart_id'],
      influencerAdminId: json['influencer_admin_id'],
      adminEmail: json['admin_email'],
      userName: json['user_name'],
      slug: json['slug'],
      influencerEmail: json['influencer_email'],
      cartSocials: json['cart_socials'],
      unpaidCartSocials: json['unpaid_cart_socials'],
      currency: json['currency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admin_id': adminId,
      'cart_id': cartId,
      'influencer_admin_id': influencerAdminId,
      'admin_email': adminEmail,
      'user_name': userName,
      'slug': slug,
      'influencer_email': influencerEmail,
      'cart_socials': cartSocials,
      'unpaid_cart_socials': unpaidCartSocials,
      'currency': currency,
    };
  }
}