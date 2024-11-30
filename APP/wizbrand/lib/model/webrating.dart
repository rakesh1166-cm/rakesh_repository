import 'dart:convert';

class WebRatings {
  final int id;
  final String? adminId;
  final String? adminEmail;
  final String? userId;
  final String? userEmail;
  final String? projectId;
  final String? projectName;
  final String? domain;
  final String? globalRank;
  final String? usaRank;
  final String? indiaRank;
  final String? backlinks;
  final String? refer;
  final String? slugName;
  final String? slugId;
  final String? orgRoleId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WebRatings({
    required this.id,
    this.adminId,
    this.adminEmail,
    this.userId,
    this.userEmail,
    this.projectId,
    this.projectName,
    this.domain,
    this.globalRank,
    this.usaRank,
    this.indiaRank,
    this.backlinks,
    this.refer,
    this.slugName,
    this.slugId,
    this.orgRoleId,
    this.createdAt,
    this.updatedAt,
  });

  factory WebRatings.fromJson(Map<String, dynamic> json) {
    return WebRatings(
      id: json['id'],
      adminId: json['admin_id'],
      adminEmail: json['admin_email'],
      userId: json['user_id'],
      userEmail: json['user_email'],
      projectId: json['project_id'],
      projectName: json['project_name'],
      domain: json['domain'],
      globalRank: json['global_rank'],
      usaRank: json['usa_rank'],
      indiaRank: json['india_rank'],
      backlinks: json['backlinks'],
      refer: json['refer'],
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
      'domain': domain,
      'global_rank': globalRank,
      'usa_rank': usaRank,
      'india_rank': indiaRank,
      'backlinks': backlinks,
      'refer': refer,
      'slugname': slugName,
      'slug_id': slugId,
      'u_org_role_id': orgRoleId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'WebRatings{id: $id, adminId: $adminId, adminEmail: $adminEmail, userId: $userId, userEmail: $userEmail, projectId: $projectId, projectName: $projectName, domain: $domain, globalRank: $globalRank, usaRank: $usaRank, indiaRank: $indiaRank, backlinks: $backlinks, refer: $refer, slugName: $slugName, slugId: $slugId, orgRoleId: $orgRoleId, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}

List<WebRatings> webRatingsFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<WebRatings>.from(data.map((item) => WebRatings.fromJson(item)));
}

String webRatingsToJson(WebRatings data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}