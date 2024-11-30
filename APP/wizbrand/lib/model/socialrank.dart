import 'dart:convert';

class SocialRanking {
  final int id;
  final String? adminId;
  final String? adminEmail;
  final String? userId;
  final String? userEmail;
  final String? projectId;
  final String? projectName;
  final String? fbLikes;
  final String? ytSubs;
  final String? twFollower;
  final String? instaFollower;
  final String? slugName;
  final int? slugId;
  final String? orgRoleId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SocialRanking({
    required this.id,
    this.adminId,
    this.adminEmail,
    this.userId,
    this.userEmail,
    this.projectId,
    this.projectName,
    this.fbLikes,
    this.ytSubs,
    this.twFollower,
    this.instaFollower,
    this.slugName,
    this.slugId,
    this.orgRoleId,
    this.createdAt,
    this.updatedAt,
  });

  factory SocialRanking.fromJson(Map<String, dynamic> json) {
    return SocialRanking(
      id: json['id'],
      adminId: json['admin_id'],
      adminEmail: json['admin_email'],
      userId: json['user_id'],
      userEmail: json['user_email'],
      projectId: json['project_id'],
      projectName: json['project_name'],
      fbLikes: json['fb_likes'],
      ytSubs: json['yt_subs'],
      twFollower: json['tw_follower'],
      instaFollower: json['insta_follower'],
      slugName: json['slugname'],
      slugId: json['slug_id'],
      orgRoleId: json['u_org_role_id'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admin_id': adminId,
      'admin_email': adminEmail,
      'user_id': userId,
      'user_email': userEmail,
      'project_id': projectId,
      'project_name': projectName,
      'fb_likes': fbLikes,
      'yt_subs': ytSubs,
      'tw_follower': twFollower,
      'insta_follower': instaFollower,
      'slugname': slugName,
      'slug_id': slugId,
      'u_org_role_id': orgRoleId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'SocialRanking{id: $id, adminId: $adminId, adminEmail: $adminEmail, userId: $userId, userEmail: $userEmail, projectId: $projectId, projectName: $projectName, fbLikes: $fbLikes, ytSubs: $ytSubs, twFollower: $twFollower, instaFollower: $instaFollower, slugName: $slugName, slugId: $slugId, orgRoleId: $orgRoleId, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}

List<SocialRanking> socialRankingFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<SocialRanking>.from(data.map((item) => SocialRanking.fromJson(item)));
}

String socialRankingToJson(SocialRanking data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}