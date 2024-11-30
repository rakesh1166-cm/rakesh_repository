import 'dart:convert';

class TaskSummary {
  final int orderSum;
  final int completedSum;
  final int pendingSum;
  final int totalOrder;
  final int pendingOrder;
  final int completeOrder;
  final int id;
  final int totalOrderCount; // New field added

  TaskSummary({
    required this.orderSum,
    required this.completedSum,
    required this.pendingSum,
    required this.totalOrder,
    required this.pendingOrder,
    required this.completeOrder,
    required this.id,
    required this.totalOrderCount, // Add this to the constructor
  });

  factory TaskSummary.fromJson(Map<String, dynamic> json) {
    return TaskSummary(
      orderSum: json['order_sum'],
      completedSum: json['completed_sum'],
      pendingSum: json['pending_sum'],
      totalOrder: json['total_order'],
      pendingOrder: json['pending_order'],
      completeOrder: json['complete_order'],
      id: json['id'],
      totalOrderCount: json['total_order_count'], // Parse from JSON
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
      'total_order_count': totalOrderCount, // Include in JSON
    };
  }
}