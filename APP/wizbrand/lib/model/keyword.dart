class Keyword {
  final int id;
  final String? adminId;
  final String? adminEmail;
  final String? userId;
  final String? userEmail;
  final List<String>? keyword; // Change here from String? to List<String>?
  final String? projectId;
  final String? projectName;
  final String? urlId;
  final String? url;
  final String? slugName;
  final int? slugId;
  final String? orgRoleId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Keyword({
    required this.id,
    this.adminId,
    this.adminEmail,
    this.userId,
    this.userEmail,
    this.keyword,
    this.projectId,
    this.projectName,
    this.urlId,
    this.url,
    this.slugName,
    this.slugId,
    this.orgRoleId,
    this.createdAt,
    this.updatedAt,
  });

  factory Keyword.fromJson(Map<String, dynamic> json) {
    return Keyword(
      id: json['id'],
      adminId: json['admin_id'],
      adminEmail: json['admin_email'],
      userId: json['user_id'],
      userEmail: json['user_email'],
      keyword: json['keyword'] != null ? List<String>.from(json['keyword']) : null, // Modify here to handle the list
      projectId: json['project_id'],
      projectName: json['project_name'],
      urlId: json['url_id'],
      url: json['url'],
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
      'keyword': keyword, // Modify here to include the list in the toJson method
      'project_id': projectId,
      'project_name': projectName,
      'url_id': urlId,
      'url': url,
      'slugname': slugName,
      'slug_id': slugId,
      'u_org_role_id': orgRoleId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Keyword{id: $id, adminId: $adminId, adminEmail: $adminEmail, userId: $userId, userEmail: $userEmail, keyword: $keyword, projectId: $projectId, projectName: $projectName, urlId: $urlId, url: $url, slugName: $slugName, slugId: $slugId, orgRoleId: $orgRoleId, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}