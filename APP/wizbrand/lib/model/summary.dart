import 'dart:convert';

class TaskSummary {
  final int orderSum;
  final int completedSum;
  final int pendingSum;
  final int totalOrder;
  final int pendingOrder;
  final int completeOrder;
  final int id;
  final int totalOrderCount;
  final int managerCount;
  final int userCount;
  final int adminCount;          // New field
  final int taskCount;            // New field (could replace allTasksCount if they are the same)
  final int allTasksCount;        // If you want to keep it separate from taskCount
  final int urlCount;
  final int websiteRanking;
  final int webAccessCount;       // New field
  final int teamRating;
  final int totalProjects;        // Matches project_count
  final int keywordCount;

  TaskSummary({
    required this.orderSum,
    required this.completedSum,
    required this.pendingSum,
    required this.totalOrder,
    required this.pendingOrder,
    required this.completeOrder,
    required this.id,
    required this.totalOrderCount,
    required this.managerCount,
    required this.userCount,
    required this.adminCount,
    required this.taskCount,
    required this.allTasksCount,
    required this.urlCount,
    required this.websiteRanking,
    required this.webAccessCount,
    required this.teamRating,
    required this.totalProjects,
    required this.keywordCount,
  });

  factory TaskSummary.fromJson(Map<String, dynamic> json) {
    return TaskSummary(
      orderSum: json['order_sum'] ?? 0,
      completedSum: json['completed_sum'] ?? 0,
      pendingSum: json['pending_sum'] ?? 0,
      totalOrder: json['total_order'] ?? 0,
      pendingOrder: json['pending_order'] ?? 0,
      completeOrder: json['complete_order'] ?? 0,
      id: json['id'] ?? 0,
      totalOrderCount: json['total_order_count'] ?? 0,
      managerCount: json['manager_count'] ?? 0,
      userCount: json['user_count'] ?? 0,
      adminCount: json['admin_count'] ?? 0,               // Maps to admin_count
      taskCount: json['task_count'] ?? 0,                 // Maps to task_count
      allTasksCount: json['all_tasks_count'] ?? 0,
      urlCount: json['url_count'] ?? 0,
      websiteRanking: json['web_rank_count'] ?? 0,
      webAccessCount: json['web_access_count'] ?? 0,      // Maps to web_access_count
      teamRating: json['team_rating_count'] ?? 0,
      totalProjects: json['project_count'] ?? 0,          // Maps to project_count
      keywordCount: json['keyword_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_sum': orderSum,
      'completed_sum': completedSum,
      'pending_sum': pendingSum,
      'total_order': totalOrder,
      'pending_order': pendingOrder,
      'complete_order': completeOrder,
      'id': id,
      'total_order_count': totalOrderCount,
      'manager_count': managerCount,
      'user_count': userCount,
      'admin_count': adminCount,             // Include new field
      'task_count': taskCount,               // Include new field
      'all_tasks_count': allTasksCount,
      'url_count': urlCount,
      'website_ranking': websiteRanking,
      'web_access_count': webAccessCount,    // Include new field
      'team_rating': teamRating,
      'total_projects': totalProjects,
      'keyword_count': keywordCount,
    };
  }
}
