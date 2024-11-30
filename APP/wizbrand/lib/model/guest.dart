import 'dart:convert';

class GuestModel {
  final int id;
  final String? title;
  final String? url;
  final String? adminId;
  final String? adminEmail;
  final String? uOrgSlugname;
  final String? uOrgOrganizationId;
  final String? uOrgRoleId;
  final int? status; // Changed from String? to int?
  final DateTime? createdAt;
  final DateTime? updatedAt;

  GuestModel({
    required this.id,
    this.title,
    this.url,
    this.adminId,
    this.adminEmail,
    this.uOrgSlugname,
    this.uOrgOrganizationId,
    this.uOrgRoleId,
    this.status, // Keep as int?
    this.createdAt,
    this.updatedAt,
  });

  factory GuestModel.fromJson(Map<String, dynamic> json) {
    return GuestModel(
      id: json['id'],
      title: json['title'],
      url: json['url'],
      adminId: json['admin_id'],
      adminEmail: json['admin_email'],
      uOrgSlugname: json['u_org_slugname'],
      uOrgOrganizationId: json['u_org_organization_id'],
      uOrgRoleId: json['u_org_role_id'],
      status: json['status'] != null ? json['status'] as int : null, // Cast to int
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'admin_id': adminId,
      'admin_email': adminEmail,
      'u_org_slugname': uOrgSlugname,
      'u_org_organization_id': uOrgOrganizationId,
      'u_org_role_id': uOrgRoleId,
      'status': status, // No change needed
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'GuestModel{id: $id, title: $title, url: $url, adminId: $adminId, adminEmail: $adminEmail, uOrgSlugname: $uOrgSlugname, uOrgOrganizationId: $uOrgOrganizationId, uOrgRoleId: $uOrgRoleId, status: $status, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}

List<GuestModel> guestModelFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<GuestModel>.from(data.map((item) => GuestModel.fromJson(item)));
}

String guestModelToJson(GuestModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}