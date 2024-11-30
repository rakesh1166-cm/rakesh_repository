import 'dart:convert';

class EmailModel {
  final int id;
  final String? adminId;
  final String? adminEmail;
  final String? userId;
  final String? userEmail;
  final String? email;
  final String? password;
  final String? phoneNumber;
  final String? passwordHint;
  final String? accountRecoveryDetails;
  final String? slugName;
  final String? slugId;
  final String? uOrgRoleId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  EmailModel({
    required this.id,
    this.adminId,
    this.adminEmail,
    this.userId,
    this.userEmail,
    this.email,
    this.password,
    this.phoneNumber,
    this.passwordHint,
    this.accountRecoveryDetails,
    this.slugName,
    this.slugId,
    this.uOrgRoleId,
    this.createdAt,
    this.updatedAt,
  });

  factory EmailModel.fromJson(Map<String, dynamic> json) {
    return EmailModel(
      id: json['id'],
      adminId: json['admin_id'],
      adminEmail: json['admin_email'],
      userId: json['user_id'],
      userEmail: json['user_email'],
      email: json['email'],
      password: json['password'],
      phoneNumber: json['phone_number'],
      passwordHint: json['password_hint'],
      accountRecoveryDetails: json['account_recovey_details'],
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
      'email': email,
      'password': password,
      'phone_number': phoneNumber,
      'password_hint': passwordHint,
      'account_recovey_details': accountRecoveryDetails,
      'slugname': slugName,
      'slug_id': slugId,
      'u_org_role_id': uOrgRoleId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'EmailModel{id: $id, adminId: $adminId, adminEmail: $adminEmail, userId: $userId, userEmail: $userEmail, email: $email, password: $password, phoneNumber: $phoneNumber, passwordHint: $passwordHint, accountRecoveryDetails: $accountRecoveryDetails, slugName: $slugName, slugId: $slugId, uOrgRoleId: $uOrgRoleId, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}

List<EmailModel> EmailModelFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<EmailModel>.from(data.map((item) => EmailModel.fromJson(item)));
}

String EmailModelToJson(EmailModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}