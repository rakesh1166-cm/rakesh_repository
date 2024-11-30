import 'dart:convert';

class Order {
  final String paymentId;
  final List<int> influencerAdminId;
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
  final String? suggestion;
  final String? description;
  final String? workDesc;
  final List<String>? imageLink;

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
    this.description,
    this.workDesc,
    this.imageLink,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    print("Mapping order from JSON: $json");

    String safeString(dynamic value) => value?.toString() ?? '';

    var paymentId = json['payment_id'] ?? '';
    print("paymentId: $paymentId");

    var influencerAdminId = json['influencer_admin_id'] is String
        ? List<int>.from(jsonDecode(json['influencer_admin_id']))
        : List<int>.from(json['influencer_admin_id'] ?? []);
    print("influencerAdminId: $influencerAdminId");

    var amount = (json['amount'] ?? 0).toDouble();
    print("amount: $amount");

    var currency = json['currency'];
    print("currency: $currency");

    var adminId = json['admin_id'] ?? '';
    print("adminId: $adminId");

    var userName = json['user_name'];
    print("userName: $userName");

    var payDate = json['Pay_date'];
    print("payDate: $payDate");

    var cartId = json['cart_id'] ?? '';
    print("cartId: $cartId");

    var transactionId = json['transaction_id'];
    print("transactionId: $transactionId");

    var productId = json['product_id'] is String
        ? json['product_id']
        : jsonEncode(json['product_id'] ?? '');
    print("productId: $productId");

    var orderId = json['order_id'] ?? '';
    print("orderId: $orderId");

    var status = json['status'] != null
        ? (json['status'] as Map).map((key, value) => MapEntry(key.toString(), safeString(value)))
        : null;
    print("status: $status");

    var adminEmail = json['admin_email'];
    print("adminEmail: $adminEmail");

    var influencerEmail = json['influencer_email'] is String
        ? List<String>.from(jsonDecode(json['influencer_email']))
        : List<String>.from(json['influencer_email'] ?? []);
    print("influencerEmail: $influencerEmail");

    var influencerName = json['influencer_name'] is String
        ? List<String>.from(jsonDecode(json['influencer_name']))
        : List<String>.from(json['influencer_name'] ?? []);
    print("influencerName: $influencerName");

    var taskLockStatus = json['tasklockstatus'] != null
        ? (json['tasklockstatus'] as Map).map((key, value) => MapEntry(key.toString(), safeString(value)))
        : null;
    print("taskLockStatus: $taskLockStatus");

    var taskDates = json['taskdates'] != null
        ? (json['taskdates'] as Map).map((key, value) => MapEntry(key.toString(), safeString(value)))
        : null;
    print("taskDates: $taskDates");

    var statusDate = json['statusdate'] != null
        ? (json['statusdate'] as Map).map((key, value) => MapEntry(key.toString(), safeString(value)))
        : null;
    print("statusDate: $statusDate");

    var cartsDate = safeString(json['cartsdate']);
    print("cartsDate: $cartsDate");

    var taskCreated = json['taskcreated'] != null
        ? (json['taskcreated'] as Map).map((key, value) => MapEntry(key.toString(), safeString(value)))
        : null;
    print("taskCreated: $taskCreated");

    var cartCreated = json['cartcreated'] != null
        ? (json['cartcreated'] as Map).map((key, value) => MapEntry(key.toString(), safeString(value)))
        : null;
    print("cartCreated: $cartCreated");

    var orderCreated = json['ordercreated'] != null
        ? (json['ordercreated'] as Map).map((key, value) => MapEntry(key.toString(), safeString(value)))
        : null;
    print("orderCreated: $orderCreated");

    var pubStatus = json['pubstatus'] != null
        ? (json['pubstatus'] as Map).map((key, value) => MapEntry(key.toString(), safeString(value)))
        : null;
    print("pubStatus: $pubStatus");

    var suggestion = json['suggestion'];
    print("suggestion: $suggestion");

    var description = json['description'];
    print("description: $description");

    var workDesc = json['work_desc'];
    print("workDesc: $workDesc");

    var imageLink = json['image_link'] is String
        ? List<String>.from(jsonDecode(json['image_link']))
        : List<String>.from(json['image_link'] ?? []);
    print("imageLink: $imageLink");

    return Order(
      paymentId: paymentId,
      influencerAdminId: influencerAdminId,
      amount: amount,
      currency: currency,
      adminId: adminId,
      userName: userName,
      payDate: payDate,
      cartId: cartId,
      transactionId: transactionId,
      productId: productId,
      orderId: orderId,
      status: status,
      adminEmail: adminEmail,
      influencerEmail: influencerEmail,
      influencerName: influencerName,
      taskLockStatus: taskLockStatus,
      taskDates: taskDates,
      statusDate: statusDate,
      cartsDate: cartsDate,
      taskCreated: taskCreated,
      cartCreated: cartCreated,
      orderCreated: orderCreated,
      pubStatus: pubStatus,
      suggestion: suggestion,
      description: description,
      workDesc: workDesc,
      imageLink: imageLink,
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
      'description': description,
      'work_desc': workDesc,
      'image_link': imageLink,
    };
  }

  @override
  String toString() {
    return 'Order{paymentId: $paymentId, influencerAdminId: $influencerAdminId, amount: $amount, currency: $currency, adminId: $adminId, userName: $userName, payDate: $payDate, cartId: $cartId, transactionId: $transactionId, productId: $productId, orderId: $orderId, status: $status, adminEmail: $adminEmail, influencerEmail: $influencerEmail, influencerName: $influencerName, taskLockStatus: $taskLockStatus, taskDates: $taskDates, statusDate: $statusDate, cartsDate: $cartsDate, taskCreated: $taskCreated, cartCreated: $cartCreated, orderCreated: $orderCreated, pubStatus: $pubStatus, suggestion: $suggestion, description: $description, workDesc: $workDesc, imageLink: $imageLink}';
  }
}

List<Order> orderFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Order>.from(data.map((item) => Order.fromJson(item)));
}

String orderToJson(Order data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}