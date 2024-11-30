import 'dart:convert';

class Rating {
  final int id;
  final String? adminId;
  final String? assignUserEmail;
  final String? adminEmail;
  final String? userId;
  final String? userEmail;
  final String? name;
  final String? ratingUserEmail;
  final String? ratingUserName;
  final String? ratingManagerEmail;
  final String? ratingManagerName;
  final String? week;
  final String? month;
  final int? year;
  final String? rating;
  final String? orgRoleId;
  final String? slugId;
  final String? slugName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Rating({
    required this.id,
    this.adminId,
    this.assignUserEmail,
    this.adminEmail,
    this.userId,
    this.userEmail,
    this.name,
    this.ratingUserEmail,
    this.ratingUserName,
    this.ratingManagerEmail,
    this.ratingManagerName,
    this.week,
    this.month,
    this.year,
    this.rating,
    this.orgRoleId,
    this.slugId,
    this.slugName,
    this.createdAt,
    this.updatedAt,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'],
      adminId: json['admin_id'],
      assignUserEmail: json['assign_user_email'],
      adminEmail: json['admin_email'],
      userId: json['user_id'],
      userEmail: json['user_email'],
      name: json['name'],
      ratingUserEmail: json['rating_user_email'],
      ratingUserName: json['rating_user_name'],
      ratingManagerEmail: json['rating_manager_email'],
      ratingManagerName: json['rating_manager_name'],
      week: json['week'],
      month: json['month'],
      year: json['year'],
      rating: json['rating'],
      orgRoleId: json['u_org_role_id'],
      slugId: json['slug_id'],
      slugName: json['slugname'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admin_id': adminId,
      'assign_user_email': assignUserEmail,
      'admin_email': adminEmail,
      'user_id': userId,
      'user_email': userEmail,
      'name': name,
      'rating_user_email': ratingUserEmail,
      'rating_user_name': ratingUserName,
      'rating_manager_email': ratingManagerEmail,
      'rating_manager_name': ratingManagerName,
      'week': week,
      'month': month,
      'year': year,
      'rating': rating,
      'u_org_role_id': orgRoleId,
      'slug_id': slugId,
      'slugname': slugName,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Rating{id: $id, adminId: $adminId, assignUserEmail: $assignUserEmail, adminEmail: $adminEmail, userId: $userId, userEmail: $userEmail, name: $name, ratingUserEmail: $ratingUserEmail, ratingUserName: $ratingUserName, ratingManagerEmail: $ratingManagerEmail, ratingManagerName: $ratingManagerName, week: $week, month: $month, year: $year, rating: $rating, orgRoleId: $orgRoleId, slugId: $slugId, slugName: $slugName, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}

List<Rating> ratingFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Rating>.from(data.map((item) => Rating.fromJson(item)));
}

String ratingToJson(Rating data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}