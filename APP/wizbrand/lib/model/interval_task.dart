import 'dart:convert';

class IntervalTask {
  final int id;
  final String? adminId;
  final String? adminEmail;
  final int? slugId;
  final String? userId;
  final String? userEmail;
  final String? userName;
  final String? slugName;
  final String? taskFreq;
  final String? taskTitle;
  final String? taskDetails;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  IntervalTask({
    required this.id,
    this.adminId,
    this.adminEmail,
    this.slugId,
    this.userId,
    this.userEmail,
    this.userName,
    this.slugName,
    this.taskFreq,
    this.taskTitle,
    this.taskDetails,
    this.createdAt,
    this.updatedAt,
  });

  factory IntervalTask.fromJson(Map<String, dynamic> json) {
    return IntervalTask(
      id: json['id'],
      adminId: json['admin_id'],
      adminEmail: json['admin_email'],
      slugId: json['slug_id'],
      userId: json['user_id'],
      userEmail: json['user_email'],
      userName: json['user_name'],
      slugName: json['slugname'],
      taskFreq: json['task_freq'],
      taskTitle: json['task_title'],
      taskDetails: json['task_details'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admin_id': adminId,
      'admin_email': adminEmail,
      'slug_id': slugId,
      'user_id': userId,
      'user_email': userEmail,
      'user_name': userName,
      'slugname': slugName,
      'task_freq': taskFreq,
      'task_title': taskTitle,
      'task_details': taskDetails,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'IntervalTask{id: $id, adminId: $adminId, adminEmail: $adminEmail, slugId: $slugId, userId: $userId, userEmail: $userEmail, userName: $userName, slugName: $slugName, taskFreq: $taskFreq, taskTitle: $taskTitle, taskDetails: $taskDetails, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}

List<IntervalTask> intervalTaskFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<IntervalTask>.from(data.map((item) => IntervalTask.fromJson(item)));
}

String intervalTaskToJson(IntervalTask data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}