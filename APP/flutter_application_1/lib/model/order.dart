import 'dart:convert';

class Order {
  final String paymentId;
  final Map<String, String>? influencerAdminId;
  final double amount;
  final String? currency;
  final String adminId;
  final String? userName;
  final String? payDate;
  final String cartId;
  final String? transactionId;
  final String productId;
  final String orderId;
  final Map<String, String>? status;
  final String? adminEmail;
  final List<String>? influencerEmail;
  final List<String>? influencerName;
  final Map<String, String>? taskLockStatus;
  final Map<String, String>? taskDates;
  final Map<String, String>? statusDate;
  final String? cartsDate;
  final Map<String, String>? taskCreated;
  final Map<String, String>? cartCreated;
  final Map<String, String>? orderCreated;
  final Map<String, String>? pubStatus;
  final Map<String, String>? suggestion;
  final Map<String, String>? influencerPaymentId; // New field added
  final Map<String, String>? description;
  final Map<String, String>? workDesc;
  final List<String>? imageLink;
  final Map<String, String>? videoLink;
  final Map<String, String>? workUrl;
  final Map<String, String>? taskTitle;

  Order({
    required this.paymentId,
    required this.influencerAdminId,
    required this.amount,
    this.currency,
    required this.adminId,
    this.userName,
    this.payDate,
    required this.cartId,
    this.transactionId,
    required this.productId,
    required this.orderId,
    this.status,
    this.adminEmail,
    this.influencerEmail,
    this.influencerName,
    this.taskLockStatus,
    this.taskDates,
    this.statusDate,
    this.cartsDate,
    this.taskCreated,
    this.cartCreated,
    this.orderCreated,
    this.pubStatus,
    this.suggestion,
    this.influencerPaymentId, // New field added
    this.description,
    this.workDesc,
    this.imageLink,
    this.videoLink,
    this.workUrl,
    this.taskTitle,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    String safeString(dynamic value) => value?.toString() ?? '';

    return Order(
      paymentId: json['payment_id'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      currency: json['currency'],
      adminId: json['admin_id'] ?? '',
      userName: json['user_name'],
      payDate: json['Pay_date'],
      cartId: json['cart_id'] ?? '',
      transactionId: json['transaction_id'],
      productId: json['product_id'] is String
          ? json['product_id']
          : jsonEncode(json['product_id'] ?? ''),
      orderId: json['order_id'] ?? '',
      status: json['status'] != null
          ? (json['status'] as Map).map((key, value) => MapEntry(key.toString(), safeString(value)))
          : null,
      adminEmail: json['admin_email'],
      influencerEmail: json['influencer_email'] is String
          ? List<String>.from(jsonDecode(json['influencer_email']))
          : List<String>.from(json['influencer_email'] ?? []),
      influencerName: json['influencer_name'] is String
          ? List<String>.from(jsonDecode(json['influencer_name']))
          : List<String>.from(json['influencer_name'] ?? []),
      taskLockStatus: json['tasklockstatus'] != null
          ? (json['tasklockstatus'] as Map).map((key, value) => MapEntry(key.toString(), safeString(value)))
          : null,
      influencerAdminId: json['influencer_admin_id'] != null
          ? (json['influencer_admin_id'] as Map).map((key, value) => MapEntry(key.toString(), safeString(value)))
          : null,
      taskDates: json['taskdates'] != null
          ? (json['taskdates'] as Map).map((key, value) => MapEntry(key.toString(), safeString(value)))
          : null,
      statusDate: json['statusdate'] != null
          ? (json['statusdate'] as Map).map((key, value) => MapEntry(key.toString(), safeString(value)))
          : null,
      cartsDate: safeString(json['cartsdate']),
      taskCreated: json['taskcreated'] != null
          ? (json['taskcreated'] as Map).map((key, value) => MapEntry(key.toString(), safeString(value)))
          : null,
      cartCreated: json['cartcreated'] != null
          ? (json['cartcreated'] as Map).map((key, value) => MapEntry(key.toString(), safeString(value)))
          : null,
      orderCreated: json['ordercreate'] != null
          ? (json['ordercreate'] as Map).map((key, value) => MapEntry(key.toString(), safeString(value)))
          : null,
      pubStatus: json['pubstatus'] != null
          ? (json['pubstatus'] as Map).map((key, value) => MapEntry(key.toString(), safeString(value)))
          : null,
      suggestion: json['suggestion'] != null
          ? (json['suggestion'] as Map).map((key, value) => MapEntry(key.toString(), safeString(value)))
          : null,
      influencerPaymentId: json['influencer_payment_id'] != null
          ? (json['influencer_payment_id'] as Map).map((key, value) => MapEntry(key.toString(), safeString(value)))
          : null, // New field added
      description: json['description'] != null
          ? (json['description'] as Map).map((key, value) => MapEntry(key.toString(), safeString(value)))
          : null,
      workDesc: json['work_desc'] != null
          ? (json['work_desc'] as Map).map((key, value) => MapEntry(key.toString(), safeString(value)))
          : null,
      imageLink: json['image_link'] is String
          ? List<String>.from(jsonDecode(json['image_link']))
          : List<String>.from(json['image_link'] ?? []),
      videoLink: json['Video_link'] != null
          ? (json['Video_link'] as Map).map((key, value) => MapEntry(key.toString(), safeString(value)))
          : null,
      workUrl: json['work_url'] != null
          ? (json['work_url'] as Map).map((key, value) => MapEntry(key.toString(), safeString(value)))
          : null,
      taskTitle: json['task_title'] != null
          ? (json['task_title'] as Map).map((key, value) => MapEntry(key.toString(), safeString(value)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_id': paymentId,
      'influencer_admin_id': influencerAdminId,
      'amount': amount,
      'currency': currency,
      'admin_id': adminId,
      'user_name': userName,
      'pay_date': payDate,
      'cart_id': cartId,
      'transaction_id': transactionId,
      'product_id': productId,
      'order_id': orderId,
      'status': status,
      'admin_email': adminEmail,
      'influencer_email': influencerEmail,
      'influencer_name': influencerName,
      'tasklockstatus': taskLockStatus,
      'taskdates': taskDates,
      'statusdate': statusDate,
      'cartsdate': cartsDate,
      'taskcreated': taskCreated,
      'cartcreated': cartCreated,
      'ordercreated': orderCreated,
      'pubstatus': pubStatus,
      'suggestion': suggestion,
      'influencer_payment_id': influencerPaymentId, // New field added
      'description': description,
      'work_desc': workDesc,
      'image_link': imageLink,
      'video_link': videoLink,
      'work_url': workUrl,
      'task_title': taskTitle,
    };
  }

  @override
  String toString() {
    return 'Order{paymentId: $paymentId, influencerAdminId: $influencerAdminId, amount: $amount, currency: $currency, adminId: $adminId, userName: $userName, payDate: $payDate, cartId: $cartId, transactionId: $transactionId, productId: $productId, orderId: $orderId, status: $status, adminEmail: $adminEmail, influencerEmail: $influencerEmail, influencerName: $influencerName, taskLockStatus: $taskLockStatus, taskDates: $taskDates, statusDate: $statusDate, cartsDate: $cartsDate, taskCreated: $taskCreated, cartCreated: $cartCreated, orderCreated: $orderCreated, pubStatus: $pubStatus, suggestion: $suggestion, influencerPaymentId: $influencerPaymentId, description: $description, workDesc: $workDesc, imageLink: $imageLink, videoLink: $videoLink, workUrl: $workUrl, taskTitle: $taskTitle}';
  }
}