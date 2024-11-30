import 'dart:convert';

class UserOrganization {
  int id;
  String? invitedBy;
  String? originalName;
  String? invitedByEmail;
  String? orgUserId;
  String? orgUserName;
  String? orgUserEmail;
  String? orgRoleId;
  String? orgRoleName;
  String? orgOrganizationId;
  String? orgSlugName;
  String? status;
  String? invitedRemoved;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserOrganization({
    this.id = 0,
    this.invitedBy,
    this.originalName,
    this.invitedByEmail,
    this.orgUserId,
    this.orgUserName,
    this.orgUserEmail,
    this.orgRoleId,
    this.orgRoleName,
    this.orgOrganizationId,
    this.orgSlugName,
    this.status,
    this.invitedRemoved,
    this.createdAt,
    this.updatedAt,
  });

  // Factory method to create an instance from JSON
  factory UserOrganization.fromJson(Map<String, dynamic> map) {
    return UserOrganization(
      id: map["id"] ?? 0,
      invitedBy: map["invited_by"],
      originalName: map["original_name"],
      invitedByEmail: map["invited_by_email"],
      orgUserId: map["u_org_user_id"],
      orgUserName: map["u_org_user_name"],
      orgUserEmail: map["u_org_user_email"],
      orgRoleId: map["u_org_role_id"],
      orgRoleName: map["u_org_role_name"],
      orgOrganizationId: map["u_org_organization_id"],
      orgSlugName: map["u_org_slugname"],
      status: map["status"]?.toString(),
      invitedRemoved: map["invited_removed"],
      createdAt: map["created_at"] != null ? DateTime.parse(map["created_at"]) : null,
      updatedAt: map["updated_at"] != null ? DateTime.parse(map["updated_at"]) : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "invited_by": invitedBy,
      "original_name": originalName,
      "invited_by_email": invitedByEmail,
      "u_org_user_id": orgUserId,
      "u_org_user_name": orgUserName,
      "u_org_user_email": orgUserEmail,
      "u_org_role_id": orgRoleId,
      "u_org_role_name": orgRoleName,
      "u_org_organization_id": orgOrganizationId,
      "u_org_slugname": orgSlugName,
      "status": status,
      "invited_removed": invitedRemoved,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'UserOrganization{id: $id, invitedBy: $invitedBy, originalName: $originalName, invitedByEmail: $invitedByEmail, orgUserId: $orgUserId, orgUserName: $orgUserName, orgUserEmail: $orgUserEmail, orgRoleId: $orgRoleId, orgRoleName: $orgRoleName, orgOrganizationId: $orgOrganizationId, orgSlugName: $orgSlugName, status: $status, invitedRemoved: $invitedRemoved, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}

// Function to parse JSON data and return a list of UserOrganization objects
List<UserOrganization> userOrganizationFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<UserOrganization>.from(data.map((item) => UserOrganization.fromJson(item)));
}

// Function to encode a UserOrganization object to JSON string
String userOrganizationToJson(UserOrganization data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}