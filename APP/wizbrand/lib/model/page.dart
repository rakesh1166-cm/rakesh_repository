import 'dart:convert';

class PageRanking {
  final int id;
  final String? adminId;
  final String? adminEmail;
  final String? userId;
  final String? userEmail;
  final String? projectId;
  final String? projectName;
  final String? urlId;
  final String? url;
  final String? pageRank;
  final String? authority;
  final String? gSPlace;
  final String? bSPlace;
  final String? slugName;
  final String? slugId;
  final String? uOrgRoleId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PageRanking({
    required this.id,
    this.adminId,
    this.adminEmail,
    this.userId,
    this.userEmail,
    this.projectId,
    this.projectName,
    this.urlId,
    this.url,
    this.pageRank,
    this.authority,
    this.gSPlace,
    this.bSPlace,
    this.slugName,
    this.slugId,
    this.uOrgRoleId,
    this.createdAt,
    this.updatedAt,
  });

  factory PageRanking.fromJson(Map<String, dynamic> json) {
    return PageRanking(
      id: json['id'],
      adminId: json['admin_id'],
      adminEmail: json['admin_email'],
      userId: json['user_id'],
      userEmail: json['user_email'],
      projectId: json['project_id'],
      projectName: json['project_name'],
      urlId: json['url_id'],
      url: json['url'],
      pageRank: json['pagerank'],
      authority: json['authority'],
      gSPlace: json['gsplace'],
      bSPlace: json['bsplace'],
      slugName: json['slugname'],
      slugId: json['slug_id'],
      uOrgRoleId: json['u_org_role_id'],
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
      'url_id': urlId,
      'url': url,
      'pagerank': pageRank,
      'authority': authority,
      'gsplace': gSPlace,
      'bsplace': bSPlace,
      'slugname': slugName,
      'slug_id': slugId,
      'u_org_role_id': uOrgRoleId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'PageRanking{id: $id, adminId: $adminId, adminEmail: $adminEmail, userId: $userId, userEmail: $userEmail, projectId: $projectId, projectName: $projectName, urlId: $urlId, url: $url, pageRank: $pageRank, authority: $authority, gSPlace: $gSPlace, bSPlace: $bSPlace, slugName: $slugName, slugId: $slugId, uOrgRoleId: $uOrgRoleId, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}

List<PageRanking> pageRankingFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<PageRanking>.from(data.map((item) => PageRanking.fromJson(item)));
}

String pageRankingToJson(PageRanking data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}