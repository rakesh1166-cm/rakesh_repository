import 'dart:convert';

class Organization {
  int id;
  String? orgUserId;
  int status;
  String? orgName;
  String? orgSlug;
  String? orgUserEmail;
  int? orgRoleId;       // New field for role ID
  String? orgRoleName;  // New field for role name
  DateTime? createdAt;
  DateTime? updatedAt;

  Organization({
    this.id = 0,
    this.orgUserId,
    this.status = 0,
    this.orgName,
    this.orgSlug,
    this.orgUserEmail,
    this.orgRoleId,       // Initialize new field
    this.orgRoleName,     // Initialize new field
    this.createdAt,
    this.updatedAt,
  });

factory Organization.fromJson(Map<String, dynamic> map) {
  return Organization(
    id: map["id"] ?? 0,
    orgUserId: map["org_user_id"],
    status: map["status"] ?? 0,
    orgName: map["org_name"],
    orgSlug: map["org_slug"],
    orgUserEmail: map["org_user_email"],
    
    // Convert org_role_id to int if it's a String
    orgRoleId: map["u_org_role_id"] is String
        ? int.tryParse(map["u_org_role_id"]) // Convert string to int if necessary
        : map["u_org_role_id"],              // Use the value if it's already an int

    orgRoleName: map["u_org_role_name"],
    createdAt: map["created_at"] != null ? DateTime.parse(map["created_at"]) : null,
    updatedAt: map["updated_at"] != null ? DateTime.parse(map["updated_at"]) : null,
  );
}

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "org_user_id": orgUserId,
      "status": status,
      "org_name": orgName,
      "org_slug": orgSlug,
      "org_user_email": orgUserEmail,
      "org_role_id": orgRoleId,           // Include new field in JSON serialization
      "org_role_name": orgRoleName,       // Include new field in JSON serialization
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Organization{id: $id, orgUserId: $orgUserId, status: $status, orgName: $orgName, orgSlug: $orgSlug, orgUserEmail: $orgUserEmail, orgRoleId: $orgRoleId, orgRoleName: $orgRoleName, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}

List<Organization> organizationFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Organization>.from(data.map((item) => Organization.fromJson(item)));
}

String organizationToJson(Organization data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}