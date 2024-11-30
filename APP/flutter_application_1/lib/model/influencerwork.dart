import 'dart:convert';

class InfluncerWork {
  int id; // Added id variable
  int adminId;
  int influencerAdminId;
  String? userName;
  String? influencerEmail;
  String? influencerPaymentId;
  String? slug;
  String? adminEmail;
  String? orderPayDate;
  String? taskTitle;
  String? payInfluencerName;
  double payAmount;
  String? orderCartId;
  String? workUrl;
  String? orderProductId;
  String? ordersId;
  String? workDesc;
  String? suggestion; // Added suggestion variable
  int? paymentId; // Updated to int
  String? description;
  String? paymentStatus;
  List<String>? imageLink;
  String? videoLink;
  String? status;
  String? tasklockstatus;
  String? publisherStatus;
  String? tasklockdate;
  String? publisherDate;
  String? statusCompleteDate;
  String? statusTodoDate;
  String? statusdate;
  String? taskcreateDate;

  InfluncerWork({
    this.id = 0, // Initialize id
    this.adminId = 0,
    this.influencerAdminId = 0,
    this.userName,
    this.influencerEmail,
    this.influencerPaymentId,
    this.slug,
    this.adminEmail,
    this.orderPayDate,
    this.taskTitle,
    this.payInfluencerName,
    this.payAmount = 0.0,
    this.orderCartId,
    this.workUrl,
    this.orderProductId,
    this.ordersId,
    this.workDesc,
    this.suggestion, // Initialize suggestion
    this.paymentId, // Updated to int
    this.description,
    this.paymentStatus,
    this.imageLink,
    this.videoLink,
    this.status,
    this.tasklockstatus,
    this.publisherStatus,
    this.tasklockdate,
    this.publisherDate,
    this.statusCompleteDate,
    this.statusTodoDate,
    this.statusdate,
    this.taskcreateDate,
  });

  factory InfluncerWork.fromJson(Map<String, dynamic> map) {
    try {
      int id = map["id"] ?? 0;
      int adminId = int.tryParse(map["admin_id"].toString()) ?? 0;
      int influencerAdminId = int.tryParse(map["influencer_admin_id"].toString()) ?? 0;
      double payAmount = double.tryParse(map["pay_amount"].toString()) ?? 0.0;
      int? paymentId = map["payment_id"] is int ? map["payment_id"] : int.tryParse(map["payment_id"].toString());

      return InfluncerWork(
        id: id,
        adminId: adminId,
        influencerAdminId: influencerAdminId,
        userName: map["user_name"],
        influencerEmail: map["influencer_email"],
        influencerPaymentId: map["influencer_payment_id"],
        slug: map["slug"],
        adminEmail: map["admin_email"],
        orderPayDate: map["order_pay_date"],
        taskTitle: map["task_title"],
        payInfluencerName: map["pay_influencer_name"],
        payAmount: payAmount,
        orderCartId: map["order_cart_id"],
        workUrl: map["work_url"],
        orderProductId: map["order_product_id"],
        ordersId: map["orders_id"],
        workDesc: map["work_desc"],
        suggestion: map["suggestion"], // Parse suggestion
        paymentId: paymentId, // Updated to int
        description: map["description"],
        paymentStatus: map["payment_status"],
        imageLink: map["image_link"] != null ? List<String>.from(json.decode(map["image_link"])) : null,
        videoLink: map["video_link"],
        status: map["task_status"],
        tasklockstatus: map["tasklockstatus"],
        publisherStatus: map["pub_status"],
        tasklockdate: map["tasklockdate"],
        publisherDate: map["publisher_date"],
        statusCompleteDate: map["status_complete_date"],
        statusTodoDate: map["status_todo_date"],
        statusdate: map["statusdate"],
        taskcreateDate: map["taskcreate_date"],
      );
    } catch (e) {
      print("Error parsing Task JSON: $e");
      print("Map: $map");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "admin_id": adminId,
      "influencer_admin_id": influencerAdminId,
      "user_name": userName,
      "influencer_email": influencerEmail,
      "influencer_payment_id": influencerPaymentId,
      "slug": slug,
      "admin_email": adminEmail,
      "order_pay_date": orderPayDate,
      "task_title": taskTitle,
      "pay_influencer_name": payInfluencerName,
      "pay_amount": payAmount,
      "order_cart_id": orderCartId,
      "work_url": workUrl,
      "order_product_id": orderProductId,
      "orders_id": ordersId,
      "work_desc": workDesc,
      "suggestion": suggestion, // Include suggestion
      "payment_id": paymentId, // Updated to int
      "description": description,
      "payment_status": paymentStatus,
      "image_link": imageLink,
      "video_link": videoLink,
      "status": status,
      "tasklockstatus": tasklockstatus,
      "publisher_status": publisherStatus,
      "tasklockdate": tasklockdate,
      "publisher_date": publisherDate,
      "status_complete_date": statusCompleteDate,
      "status_todo_date": statusTodoDate,
      "statusdate": statusdate,
      "taskcreate_date": taskcreateDate,
    };
  }

  @override
  String toString() {
    return 'InfluncerWork{id: $id, adminId: $adminId, influencerAdminId: $influencerAdminId, userName: $userName, influencerEmail: $influencerEmail, influencerPaymentId: $influencerPaymentId, slug: $slug, adminEmail: $adminEmail, orderPayDate: $orderPayDate, taskTitle: $taskTitle, payInfluencerName: $payInfluencerName, payAmount: $payAmount, orderCartId: $orderCartId, workUrl: $workUrl, orderProductId: $orderProductId, ordersId: $ordersId, workDesc: $workDesc, suggestion: $suggestion, paymentId: $paymentId, description: $description, paymentStatus: $paymentStatus, imageLink: $imageLink, videoLink: $videoLink, status: $status, tasklockstatus: $tasklockstatus, publisherStatus: $publisherStatus, tasklockdate: $tasklockdate, publisherDate: $publisherDate, statusCompleteDate: $statusCompleteDate, statusTodoDate: $statusTodoDate, statusdate: $statusdate, taskcreateDate: $taskcreateDate}';
  }
}

List<InfluncerWork> taskFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<InfluncerWork>.from(data.map((item) => InfluncerWork.fromJson(item)));
}

String taskToJson(InfluncerWork data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}