import 'dart:convert';

class PhoneModel {
  final int id;
  final String? adminId;
  final String? adminEmail;
  final String? userId;
  final String? userEmail;
  final String? phone;
  final String? carrier;
  final String? owner;
  final String? status;
  final String? lastUsed;
  final String? lastRecharge;
  final String? state;
  final String? slugId;
  final String? uOrgRoleId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PhoneModel({
    required this.id,
    this.adminId,
    this.adminEmail,
    this.userId,
    this.userEmail,
    this.phone,
    this.carrier,
    this.owner,
    this.status,
    this.lastUsed,
    this.lastRecharge,
    this.state,
    this.slugId,
    this.uOrgRoleId,
    this.createdAt,
    this.updatedAt,
  });

  factory PhoneModel.fromJson(Map<String, dynamic> json) {
    return PhoneModel(
      id: json['id'],
      adminId: json['admin_id'],
      adminEmail: json['admin_email'],
      userId: json['user_id'],
      userEmail: json['user_email'],
      phone: json['phone'],
      carrier: json['carrier'],
      owner: json['owner'],
      status: json['status'],
      lastUsed: json['last_used'],
      lastRecharge: json['last_recharge'],
      state: json['state'],
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
      'phone': phone,
      'carrier': carrier,
      'owner': owner,
      'status': status,
      'last_used': lastUsed,
      'last_recharge': lastRecharge,
      'state': state,
      'slug_id': slugId,
      'u_org_role_id': uOrgRoleId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'PhoneModel{id: $id, adminId: $adminId, adminEmail: $adminEmail, userId: $userId, userEmail: $userEmail, phone: $phone, carrier: $carrier, owner: $owner, status: $status, lastUsed: $lastUsed, lastRecharge: $lastRecharge, state: $state, slugId: $slugId, uOrgRoleId: $uOrgRoleId, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}

List<PhoneModel> phoneModelFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<PhoneModel>.from(data.map((item) => PhoneModel.fromJson(item)));
}

String phoneModelToJson(PhoneModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}