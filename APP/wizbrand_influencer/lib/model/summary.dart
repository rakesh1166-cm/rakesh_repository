class TaskSummary {
  final int orderSum;
  final int completedSum;
  final int pendingSum;
  final int totalOrder;
  final int pendingOrder;
  final int completeOrder;
  final int id;
  final int totalOrderCount;
  final int? filledData; // Nullable field

  TaskSummary({
    required this.orderSum,
    required this.completedSum,
    required this.pendingSum,
    required this.totalOrder,
    required this.pendingOrder,
    required this.completeOrder,
    required this.id,
    required this.totalOrderCount,
    this.filledData,
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
      filledData: json['filled_data'], // Nullable
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
      'filled_data': filledData,
    };
  }

  int get completionPercentage {
    if (filledData == 4) return 100; // All fields filled
    if (filledData == 3) return 80; // All fields filled
    if (filledData == 2) return 60; // Two fields filled
    if (filledData == 1) return 40; // One field filled
    return 20; // Default when no fields are filled
  }
}
