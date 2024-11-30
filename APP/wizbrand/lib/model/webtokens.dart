class WebTokenModel {
  final int id;
  final String? token; // Make it nullable if it can be null
  final String? keydate;
  final String? keyid;
  final String? pubkey;
  final String? adminId;
  final String? adminEmail;
  final String? orgSlugname;
  final String? orgOrganizationId;
  final String? orgRoleId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WebTokenModel({
    required this.id,
    this.token,
    this.keydate,
    this.keyid,
    this.pubkey,
    this.adminId,
    this.adminEmail,
    this.orgSlugname,
    this.orgOrganizationId,
    this.orgRoleId,
    this.createdAt,
    this.updatedAt,
  });

  factory WebTokenModel.fromJson(Map<String, dynamic> json) {
    return WebTokenModel(
      id: json['id'] as int,
      token: json['token'],
      keydate: json['keydate'],
      keyid: json['keyid'],
      pubkey: json['pubkey'],
      adminId: json['admin_id'],
      adminEmail: json['admin_email'],
      orgSlugname: json['u_org_slugname'],
      orgOrganizationId: json['u_org_organization_id'],
      orgRoleId: json['u_org_role_id'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'token': token,
      'keydate': keydate,
      'keyid': keyid,
      'pubkey': pubkey,
      'admin_id': adminId,
      'admin_email': adminEmail,
      'u_org_slugname': orgSlugname,
      'u_org_organization_id': orgOrganizationId,
      'u_org_role_id': orgRoleId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'WebTokenModel{id: $id, token: $token, keydate: $keydate, keyid: $keyid, pubkey: $pubkey, adminId: $adminId, adminEmail: $adminEmail, orgSlugname: $orgSlugname, orgOrganizationId: $orgOrganizationId, orgRoleId: $orgRoleId, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
