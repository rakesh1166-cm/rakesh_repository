import 'dart:convert';

class Mytask {
  int id;
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
  String? suggestion;
  String? paymentId;
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
  String? currency; // Add currency as a String

  Mytask({
    this.id = 0,
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
    this.suggestion,
    this.paymentId,
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
    this.currency, // Initialize the currency field
  });

  factory Mytask.fromJson(Map<String, dynamic> map) {
    try {
      int id = int.tryParse(map["id"].toString()) ?? 0; 
      int adminId = int.tryParse(map["admin_id"].toString()) ?? 0;
      int influencerAdminId = int.tryParse(map["influencer_admin_id"].toString()) ?? 0;
      double payAmount = double.tryParse(map["pay_amount"].toString()) ?? 0.0;

      return Mytask(
        id: id,
        adminId: adminId,
        influencerAdminId: influencerAdminId,
        userName: map["user_name"]?.toString(),
        influencerEmail: map["influencer_email"]?.toString(),
        influencerPaymentId: map["influencer_payment_id"]?.toString(),
        slug: map["slug"]?.toString(),
        adminEmail: map["admin_email"]?.toString(),
        orderPayDate: map["order_pay_date"]?.toString(),
        taskTitle: map["task_title"]?.toString(),
        payInfluencerName: map["pay_influencer_name"]?.toString(),
        payAmount: payAmount,
        orderCartId: map["order_cart_id"]?.toString(),
        workUrl: map["work_url"]?.toString(),
        orderProductId: map["order_product_id"]?.toString(),
        ordersId: map["orders_id"]?.toString(),
        workDesc: map["work_desc"]?.toString(),
        suggestion: map["suggestion"]?.toString(),
        paymentId: map["payment_id"]?.toString(),
        description: map["description"]?.toString(),
        paymentStatus: map["payment_status"]?.toString(),
        imageLink: map["image_link"] != null ? List<String>.from(json.decode(map["image_link"])) : null,
        videoLink: map["Video_link"]?.toString(),
        status: map["task_status"]?.toString(),
        tasklockstatus: map["tasklockstatus"]?.toString(),
        publisherStatus: map["pub_status"]?.toString(),
        tasklockdate: map["tasklockdate"]?.toString(),
        publisherDate: map["publisher_date"]?.toString(),
        statusCompleteDate: map["status_complete_date"]?.toString(),
        statusTodoDate: map["status_todo_date"]?.toString(),
        statusdate: map["statusdate"]?.toString(),
        taskcreateDate: map["taskcreate_date"]?.toString(),
        currency: map["currencies"]?.toString(), // Add currency field from the JSON map
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
      "suggestion": suggestion,
      "payment_id": paymentId,
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
      "currencies": currency, // Add currency field to the JSON map
    };
  }

  @override
  String toString() {
    return 'Mytask{id: $id, adminId: $adminId, influencerAdminId: $influencerAdminId, userName: $userName, influencerEmail: $influencerEmail, influencerPaymentId: $influencerPaymentId, slug: $slug, adminEmail: $adminEmail, orderPayDate: $orderPayDate, taskTitle: $taskTitle, payInfluencerName: $payInfluencerName, payAmount: $payAmount, orderCartId: $orderCartId, workUrl: $workUrl, orderProductId: $orderProductId, ordersId: $ordersId, workDesc: $workDesc, suggestion: $suggestion, paymentId: $paymentId, description: $description, paymentStatus: $paymentStatus, imageLink: $imageLink, videoLink: $videoLink, status: $status, tasklockstatus: $tasklockstatus, publisherStatus: $publisherStatus, tasklockdate: $tasklockdate, publisherDate: $publisherDate, statusCompleteDate: $statusCompleteDate, statusTodoDate: $statusTodoDate, statusdate: $statusdate, taskcreateDate: $taskcreateDate, currency: $currency}';
  }
}