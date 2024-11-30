import 'dart:convert';

class Profile {
  int id;
  String? userId;
  String? userName;
  String? userEmail;
  String? filePic;
  String? slugId;
  String? slug;
  String? slugname;
  String? countryId;
  String? stateId;
  String? cityId;
  String? mobile;
  String? digitalMarketer;
  String? bio;
  String? socialSite;
  String? socialPrice;
  String? socialCurrency;
  String? adminId;
  String? cartId;
  String? influencerAdminId;
  String? cartSocials;
  String? currency;
  String? influencerEmail;
  String? countryName;
  String? stateName;
  String? cityName;
  int? addcartsid;
  String? adminEmail; // New field

  Profile({
    this.id = 0,
    this.userId,
    this.userName,
    this.userEmail,
    this.filePic,
    this.slugId,
    this.slug,
    this.slugname,
    this.countryId,
    this.stateId,
    this.cityId,
    this.mobile,
    this.digitalMarketer,
    this.bio,
    this.socialSite,
    this.socialPrice,
    this.socialCurrency,
    this.adminId,
    this.cartId,
    this.influencerAdminId,
    this.cartSocials,
    this.currency,
    this.influencerEmail,
    this.countryName,
    this.stateName,
    this.cityName,
    this.addcartsid,
    this.adminEmail, // New field
  });

  factory Profile.fromJson(Map<String, dynamic> map) {
    return Profile(
      id: map["id"] ?? 0,
      userId: map["user_id"],
      userName: map["slug"],
      userEmail: map["email"],
      filePic: map["file_pic"],
      slugId: map["slug_id"],
      slug: map["slug"],
      slugname: map["slugname"],
      countryId: map["country_id"],
      stateId: map["state_id"],
      cityId: map["city_id"],
      mobile: map["mobile"],
      digitalMarketer: map["digital_marketer"],
      bio: map["bio"],
      socialSite: map["social_site"],
      socialPrice: map["social_price"],
      socialCurrency: map["social_currency"],
      adminId: map["admin_id"],
      cartId: map["cart_id"],
      influencerAdminId: map["influencer_admin_id"],
      cartSocials: map["cart_socials"],
      currency: map["currency"],
      influencerEmail: map["influencer_email"],
      countryName: map["country_name"],
      stateName: map["state_name"],
      cityName: map["city_name"],
      addcartsid: map["addcartsid"] != null ? int.tryParse(map["addcartsid"].toString()) : null,
      adminEmail: map["admin_email"], // New field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "user_name": userName,
      "user_email": userEmail,
      "file_pic": filePic,
      "slug_id": slugId,
      "slug": slug,
      "slugname": slugname,
      "country_id": countryId,
      "state_id": stateId,
      "city_id": cityId,
      "mobile": mobile,
      "digital_marketer": digitalMarketer,
      "bio": bio,
      "social_site": socialSite,
      "social_price": socialPrice,
      "social_currency": socialCurrency,
      "admin_id": adminId,
      "cart_id": cartId,
      "influencer_admin_id": influencerAdminId,
      "cart_socials": cartSocials,
      "currency": currency,
      "influencer_email": influencerEmail,
      "country_name": countryName,
      "state_name": stateName,
      "city_name": cityName,
      "addcartsid": addcartsid,
      "admin_email": adminEmail, // New field
    };
  }

  @override
  String toString() {
    return 'Profile{id: $id, userId: $userId, userName: $userName, userEmail: $userEmail, filePic: $filePic, slugId: $slugId, slug: $slug, slugname: $slugname, countryId: $countryId, stateId: $stateId, cityId: $cityId, mobile: $mobile, digitalMarketer: $digitalMarketer, bio: $bio, socialSite: $socialSite, socialPrice: $socialPrice, socialCurrency: $socialCurrency, adminId: $adminId, cartId: $cartId, influencerAdminId: $influencerAdminId, cartSocials: $cartSocials, currency: $currency, influencerEmail: $influencerEmail, countryName: $countryName, stateName: $stateName, cityName: $cityName, addcartsid: $addcartsid, adminEmail: $adminEmail}';
  }

  bool startsWith(String query) {
    return userName?.toLowerCase().contains(query.toLowerCase()) ?? false;
  }
}

List<Profile> ProfileFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Profile>.from(data.map((item) => Profile.fromJson(item)));
}

String ProfileToJson(Profile data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}