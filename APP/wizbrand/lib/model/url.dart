class Url {
  final int id;
  final String? adminId;
  final String? adminEmail;
  final String? adminGenId;
  final String? userId;
  final String? userEmail;
  final String? orgRoleId;
  final String? slugId;
  final String? slugName;
  final String projectName;
  final String? url;
  final String status;
  final String? expiry;
  final String? projectManager;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? projectId; // New field

  Url({
    required this.id,
    this.adminId,
    this.adminEmail,
    this.adminGenId,
    this.userId,
    this.userEmail,
    this.orgRoleId,
    this.slugId,
    this.slugName,
    required this.projectName,
    this.url,
    required this.status,
    this.expiry,
    this.projectManager,
    this.createdAt,
    this.updatedAt,
    this.projectId, // Include in constructor
  });

  factory Url.fromJson(Map<String, dynamic> json) {
    return Url(
      id: json['id'],
      adminId: json['admin_id'],
      adminEmail: json['admin_email'],
      adminGenId: json['admin_gen_id'],
      userId: json['user_id'],
      userEmail: json['user_email'],
      orgRoleId: json['u_org_role_id'],
      slugId: json['slug_id'],
      slugName: json['slugname'],
      projectName: json['project_name'],
      url: json['url'],
      status: json['status'] ?? '',  // Provide default value if null
      expiry: json['expiry'],
      projectManager: json['project_manager'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      projectId: json['project_id'] != null
          ? int.tryParse(json['project_id'].toString()) // Convert project_id to int
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admin_id': adminId,
      'admin_email': adminEmail,
      'admin_gen_id': adminGenId,
      'user_id': userId,
      'user_email': userEmail,
      'u_org_role_id': orgRoleId,
      'slug_id': slugId,
      'slugname': slugName,
      'project_name': projectName,
      'url': url,
      'status': status,
      'expiry': expiry,
      'project_manager': projectManager,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'project_id': projectId, // Include new field
    };
  }

  @override
  String toString() {
    return 'Url{id: $id, adminId: $adminId, adminEmail: $adminEmail, adminGenId: $adminGenId, userId: $userId, userEmail: $userEmail, orgRoleId: $orgRoleId, slugId: $slugId, slugName: $slugName, projectName: $projectName, url: $url, status: $status, expiry: $expiry, projectManager: $projectManager, createdAt: $createdAt, updatedAt: $updatedAt, projectId: $projectId}';
  }
}