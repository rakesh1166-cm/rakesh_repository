class CurrencyUpdateResponse {
  final double totalSum;
  final double gst;
  final double sumGst;
  final List<String>? cartId;  
  final List<String>? influenceremail;
  final List<int>? influenceradmin;
  final List<String>? influencername;
  final List<int>? productid;
  final String? email;
  final List<CartDetail>? cartDetail;
  final String? currency;

  CurrencyUpdateResponse({
    required this.totalSum,
    required this.gst,
    required this.sumGst,
    this.cartId,
    this.influenceremail,
    this.influenceradmin,
    this.influencername,
    this.productid,
    this.email,
    this.cartDetail,
    this.currency,
  });

  factory CurrencyUpdateResponse.fromJson(Map<String, dynamic> json) {
    var cartDetailsFromJson = json['cartdetail'] as List?;
    List<CartDetail>? cartDetailList;
    if (cartDetailsFromJson != null) {
      cartDetailList = cartDetailsFromJson.map((i) => CartDetail.fromJson(i)).toList();
    }

    return CurrencyUpdateResponse(
      totalSum: json['totalSum'].toDouble(),
      gst: json['gst'].toDouble(),
      sumGst: json['sumGst'].toDouble(),
      cartId: json['cartId'] != null ? List<String>.from(json['cartId']) : null,
       influenceremail: json['influencer_email'] != null ? List<String>.from(json['influencer_email']) : null,
       influenceradmin: json['influencer_admin_id'] != null ? List<int>.from(json['influencer_admin_id']) : null,
       influencername: json['influencer_name'] != null ? List<String>.from(json['influencer_name']) : null,
       productid: json['pro_id'] != null ? List<int>.from(json['pro_id']) : null,
      email: json['email'],
      cartDetail: cartDetailList,
      currency: json['currency'],
    );
  }
}

class CartDetail {
  final String cartSocials;
  final String currency;
  final int id;

  CartDetail({
    required this.cartSocials,
    required this.currency,
    required this.id,
  });

  factory CartDetail.fromJson(Map<String, dynamic> json) {
    return CartDetail(
      cartSocials: json['cart_socials'],
      currency: json['currency'],
      id: json['id'],
    );
  }
}