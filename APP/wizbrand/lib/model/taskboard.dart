import 'dart:convert';

class TaskBoard {
  final int id;
  final String? adminId;
  final String? adminEmail;
  final String? userId;
  final String? userEmail;
  final String? projectName;
  final String? projectId;
  final int? urlId;
  final String? keyword;
  final String? severity;
  final String? description;
  final String? inputTitle;
  final String? user;
  final String? document;
  final String? webUrl;
  final String? taskType;
  final String? taskDeadline;
  final String? title;
  final String status;
  final String? slugName;
  final int? slugId;
  final String? orgRoleId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TaskBoard({
    required this.id,
    this.adminId,
    this.adminEmail,
    this.userId,
    this.userEmail,
    this.projectName,
    this.projectId,
    this.urlId,
    this.keyword,
    this.severity,
    this.description,
    this.inputTitle,
    this.user,
    this.document,
    this.webUrl,
    this.taskType,
    this.taskDeadline,
    this.title,
    required this.status,
    this.slugName,
    this.slugId,
    this.orgRoleId,
    this.createdAt,
    this.updatedAt,
  });

  factory TaskBoard.fromJson(Map<String, dynamic> json) {
    return TaskBoard(

      id: json['id'],
      adminId: json['admin_id'],
      adminEmail: json['admin_email'],
      userId: json['user_id'],
      userEmail: json['user_email'],
      projectName: json['project_name'],
      projectId: json['project_id'],
      urlId: json['url_id'],
      keyword: json['keyword'],
      severity: json['severity'],
      description: json['description'],
      inputTitle: json['input_title'],
      user: json['user'],
      document: json['document'],
      webUrl: json['weburl'],
      taskType: json['tasktype'],
      taskDeadline: json['taskdeadline'],
      title: json['title'],
      status: json['status'],
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
      'project_name': projectName,
      'project_id': projectId,
      'url_id': urlId,
      'keyword': keyword,
      'severity': severity,
      'description': description,
      'input_title': inputTitle,
      'user': user,
      'document': document,
      'weburl': webUrl,
      'tasktype': taskType,
      'taskdeadline': taskDeadline,
      'title': title,
      'status': status,
      'slugname': slugName,
      'slug_id': slugId,
      'u_org_role_id': orgRoleId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'TaskBoard{id: $id, adminId: $adminId, adminEmail: $adminEmail, userId: $userId, userEmail: $userEmail, projectName: $projectName, projectId: $projectId, urlId: $urlId, keyword: $keyword, severity: $severity, description: $description, inputTitle: $inputTitle, user: $user, document: $document, webUrl: $webUrl, taskType: $taskType, taskDeadline: $taskDeadline, title: $title, status: $status, slugName: $slugName, slugId: $slugId, orgRoleId: $orgRoleId, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}

List<TaskBoard> taskBoardFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<TaskBoard>.from(data.map((item) => TaskBoard.fromJson(item)));
}

String taskBoardToJson(TaskBoard data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}