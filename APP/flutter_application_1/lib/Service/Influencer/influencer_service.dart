import 'dart:convert';
import 'dart:io';
import 'dart:io';
import 'package:flutter_application_1/model/cartsocial.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // for setting the media type of files
import 'package:path/path.dart'; // for getting file extension and file names
import 'package:mime/mime.dart'; 
import 'package:flutter_application_1/model/cart.dart';
import 'package:flutter_application_1/model/currencyupdate.dart';
import 'package:flutter_application_1/model/influencerwork.dart';
import 'package:flutter_application_1/model/order.dart';
import 'package:flutter_application_1/model/profile.dart';
import 'package:flutter_application_1/model/search_influencer.dart';
import 'package:flutter_application_1/model/country.dart';
import 'package:flutter_application_1/model/states.dart';
import 'package:flutter_application_1/model/city.dart';
import 'package:flutter_application_1/model/summary.dart';
import 'package:flutter_application_1/model/task.dart';
import 'package:http/http.dart' as http;

class InfluencerAPI {
  String baseUrl = "https://www.wizbrand.com";



Future<List<SearchInfluencer>> getinfluencer(String email) async {
  var url = "$baseUrl/api/getinfluencer";  // No need for the email in the URL
  var body = jsonEncode({"email": email}); // Send email as JSON body
  print("Request URL: $url");
  print("Request Body: $body");

  // Send a POST request with the email in the request body
  final response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: body,
  );

  // Debugging the response
  print("Response Status: ${response.statusCode}");
  print("Response Body: ${response.body}");

  // Check if the request was successful
  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    // Print the decoded JSON body for further inspection
    print("Decoded JSON: $body");
    return body.map((user) => SearchInfluencer.fromJson(user)).toList();
  } else {
    throw Exception("Failed to fetch influencer data");
  }
}

  Future<List<CartSite>> getInfluencerData(String cartId, String influencerAdminId) async {
    var url = "$baseUrl/api/getinfluencerdata";
    var body = jsonEncode({
      "cartId": cartId,
      "influencerAdminId": influencerAdminId,
    });

    print("Request URL: $url");
    print("Request Body getInfluencerData: $body");

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    print("Response Status getInfluencerData: ${response.statusCode}");
    print("Response Body getInfluencerData: ${response.body}");

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      print("Decoded JSON for getInfluencerData: $body");
      return body.map((user) => CartSite.fromJson(user)).toList();
    } else {
      throw Exception("Failed to fetch influencer data");
    }
  }
  Future<void> updatePassword(String email, String currentPassword) async {
    var url = "$baseUrl/api/updatePassword"; // Replace with the correct endpoint
    var body = jsonEncode({
      "email": email,
      "password": currentPassword,     
    });
    print("Request URL: $url");
    print("Request Body: $body");
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      // Handle successful password update
      print("Password updated successfully");
    } else {
      // Handle error
      throw Exception("Failed to update password");
    }
  }

Future<String> generateTransactionTokens({
  required String orderId,
  required double totalSum,
  required double gst,
  required double sumGst,
  required List<String> cartId,       
  required String email,
  required String currency,
  required List<int> proid,
  required List<String> influencername,
  required List<String> influenceremail,
  required List<int> influnceradminid,
}) async {    
  var url = "$baseUrl/api/generatePaytmTokens";
  
  var body = jsonEncode({
    "order_id": orderId,
    "amount":"1",
    "gst": gst.toString(),
    "sum_gst": "1",  // set static value of 1 here
    "cart_id": cartId,
    "email": email,
    "currency": currency,
    "pro_id": proid,
    "influencer_name": influencername,
    "influencer_email": influenceremail,
    "influencer_admin_id": influnceradminid,
    "customer_id": email
  });

  print("Request URL: $url");
  print("Request Body: $body");

  final response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: body,
  );

  print("Response Status Code: ${response.statusCode}");
  print("Response Body: ${response.body}");

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    String txnToken = data['body']['txnToken'];
    return txnToken;
  } else {
    throw Exception("Failed to generate transaction token");
  }
}
 Future<CurrencyUpdateResponse> updateCurrency(String currency, List<String> cartIds, String email) async {
  var url = "$baseUrl/api/update_currency";
  var body = jsonEncode({
    "currency": currency,
    "cart_ids": cartIds,
    "email": email,
  });
  print("Request URL: $url");
  print("Request updateCurrency Body: $body");

  final response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: body,
  );

  print("Response Status Code: ${response.statusCode}");
  print("Response Body: ${response.body}");

  if (response.statusCode != 200) {
    throw Exception("Failed to update currency");
  }

  final responseData = jsonDecode(response.body);
  return CurrencyUpdateResponse.fromJson(responseData);
}


Future<List<Task>> fetchfilterTask(String? email) async {
    var url = "$baseUrl/api/filterpubtask";
    var body = jsonEncode({"email": email});
    print("Request URL: $url");
    print("Request Body fetchfilterTask: $body");

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    print("Response Status fetchTask: ${response.statusCode}");
    print("Response Body fetchTask: ${response.body}");

 if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    return body.map((task) => Task.fromJson(task)).toList();
  } else {
    throw Exception("Failed to fetch states");
  }
  }

//


  Future<List<UserCart>> removeFromCart(String? addCartId, String email) async {
    var url = "$baseUrl/api/remove_from_cart";
    var body = jsonEncode({"add_cart_id": addCartId});
    print("Request URL: $url");
    print("Request Body: $body");
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((usercart) => UserCart.fromJson(usercart)).toList();
    } else {
      throw Exception("Failed to remove from cart");
    }
  }


Future<List<UserCart>> fetchcart(String? email) async {
    var url = "$baseUrl/api/fetchcart";
    var body = jsonEncode({"email": email});
    print("Request URL: $url");
    print("Request Body fetchfilterTask: $body");

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    print("Response Status fetchcart: ${response.statusCode}");
    print("Response Body fetchcart: ${response.body}");

 if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    return body.map((usercart) => UserCart.fromJson(usercart)).toList();
  } else {
    throw Exception("Failed to fetch states");
  }
  }

  
  
Future<List<Order>> fetchmyOrder(String? email) async {
  if (email == null || email.isEmpty) {
    throw Exception("Email is null or empty");
  }

  var url = "$baseUrl/api/fetchmyorder";
  var body = jsonEncode({"email": email});
  print("Request URL: $url");
  print("Request Body: $body");

  final response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: body,
  );
  print("Response Status fetchmyOrder: ${response.statusCode}");
  print("Response Body fetchmyOrder: ${response.body}");

  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    return body.map((order) => Order.fromJson(order)).toList();
  } else {
    throw Exception("Failed to fetch orders");
  }
}


Future<List<InfluncerWork>> fetchmyWork(String? email) async {
  if (email == null || email.isEmpty) {
    throw Exception("Email is null or empty");
  }
  var url = "$baseUrl/api/fetchmyworkdetail";
  var body = jsonEncode({"email": email});
  print("Request URL: $url");
  print("Request Body: $body");

  final response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: body,
  );
  print("Response Status fetchmyWork: ${response.statusCode}");
  print("Response Body fetchmyWork2: ${response.body}");

  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    return body.map((order) => InfluncerWork.fromJson(order)).toList();
  } else {
    throw Exception("Failed to fetch orders");
  }
}

Future<Profile> fetchprofile(String? email) async {
  if (email == null || email.isEmpty) {
    throw Exception("Email is null or empty");
  }
  var url = "$baseUrl/api/fetchmyworkprofile";
  var body = jsonEncode({"email": email});
  print("Request URL: $url");
  print("Request Body: $body");

  final response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: body,
  );
  print("Response Status fetchmyWork: ${response.statusCode}");
  print("Response Body fetchmyWork: ${response.body}");

  if (response.statusCode == 200) {
    Map<String, dynamic> body = jsonDecode(response.body);
    return Profile.fromJson(body);
  } else {
    throw Exception("Failed to fetch profile");
  }
}

Future<List<SearchInfluencer>> influencerData(String? email) async {
    var url = "$baseUrl/api/influencerData";
    var body = jsonEncode({"email": email});
    print("Request URL: $url");
    print("Request Body: $body");
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    print("Response Status influencerData: ${response.statusCode}");
    print("Response Body influencerData: ${response.body}");
 if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    return body.map((influencerdata) => SearchInfluencer.fromJson(influencerdata)).toList();
  } else {
    throw Exception("Failed to fetch states");
  }
  }

  

  Future<TaskSummary> fetchOrder(String? email) async {
    var url = "$baseUrl/api/fetchorder";
    var body = jsonEncode({"email": email});
    print("Request URL: $url");
    print("Request Body: $body");

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    print("Response Status fetchTask: ${response.statusCode}");
    print("Response Body fetchTask: ${response.body}");
    if (response.statusCode != 200) {
      throw Exception("Failed to fetch tasks");
    }
    Map<String, dynamic> responseData = jsonDecode(response.body);
    return TaskSummary.fromJson(responseData);
  }



 Future<void> updateInfluencerSelection(String influencerId, String socialKey, bool isSelected,String email,) async {
    var url = "$baseUrl/api/influencer_selection";
    var body = jsonEncode({
      "influencer_id": influencerId,
      "social_key": socialKey,
      "is_selected": isSelected,
      "email": email
    });
    print("Request URL: $url");
    print("Request Body: $body");
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    if (response.statusCode != 200) {
      throw Exception("Failed to update influencer selection");
    }
  }



  

  Future<List<Country>> getcountry() async {
    var url = "$baseUrl/api/getcountry/";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((country) => Country.fromJson(country)).toList();
    } else {
      throw Exception("failed to upload product");
    }
  }

  

 Future<bool> login(String email, String password) async {
    var url = "$baseUrl/api/login";
    var body = jsonEncode({"email": email, "password": password});
    print("Request URL: $url");
    print("Request Body: $body");
    
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    
    print("Response login Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    
    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      // Assuming responseData contains a token or user data
      return responseData['success']; // Adjust this according to your API response
    } else {
      throw Exception("Failed to login");
    }
  }
Future<Map<String, dynamic>> initiatePayment({
  required double totalSum,
  required double gst,
  required double sumGst,
  required List<String> cartId,
  required String email,
  required List<CartDetail> cartDetail,
  required String currency,
  required List<int> proid,
  required List<String> influencername,
  required List<String> influenceremail,
  required List<int> influnceradminid,
}) async {
  var url = "$baseUrl/api/initiate_payment";
  var body = jsonEncode({
    "totalSum": totalSum,
    "gst": gst,
    "sumGst": sumGst,
    "cartId": cartId,
    "email": email,
    "currency": currency,
    "proid": proid,
    "influencername": influencername,
    "influenceremail": influenceremail,
    "influnceradminid": influnceradminid,
  });

  print("Request URL: $url");
  print("Request Body for initiatePayment: $body");

  final response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: body,
  );

  print("Response Status Code for initiatePayment: ${response.statusCode}");
  print("Response Body for initiatePayment: ${response.body}");

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception("Failed to initiate payment");
  }
}


Future<List<States>> getStates(String countryId) async {
  var url = "$baseUrl/api/getstates";
  var body = jsonEncode({"country_id": countryId});

  print("Request URL: $url");
  print("Request Body: $body");

  final response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: body,
  );

  print("Response Status Code: ${response.statusCode}");
  print("Response Body: ${response.body}");

  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    return body.map((state) => States.fromJson(state)).toList();
  } else {
    throw Exception("Failed to fetch states");
  }
}
  Future<List<City>> getCities(String stateId) async {
    var url = "$baseUrl/api/getcities";
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"state_id": stateId}),
    );
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((city) => City.fromJson(city)).toList();
    } else {
      throw Exception("Failed to fetch cities");
    }
  }

   Future<http.Response> updateTask(int productId, String orderId) async {
    var url = "$baseUrl/api/update_task";
    var body = jsonEncode({"product_id": productId, "order_id": orderId});
    print("Request URL: $url");
    print("Request Body: $body");

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    print("Response Status Code: ${response.statusCode}");
    print("Response BodyupdateTask: ${response.body}");
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception("Failed to update task");
    }
  }


// Future<http.Response> updateTaskWithDetails({
//   required int productId,
//   required int orderId,
//   required String taskTitle,
//   required String description,
//   required String videoLink,
//   required List<File> imageLinks, // Add the required modifier
// }) async {
//   var url = "$baseUrl/api/updateTaskWithDetails";
//   var body = jsonEncode({
//     "product_id": productId,
//     "order_id": orderId,
//     "task_title": taskTitle,
//     "description": description,
//     "video_link": videoLink,
//     "image_links": imageLinks.map((file) => file.path).toList(), // Convert File objects to paths or appropriate data
//   });
//   print("Request URL: $url");
//   print("Request Body: $body");

//   final response = await http.post(
//     Uri.parse(url),
//     headers: {"Content-Type": "application/json"},
//     body: body,
//   );
//   print("Response Status Code: ${response.statusCode}");
//   print("Response Body updateTaskWithDetails: ${response.body}");
//   if (response.statusCode == 200) {
//     return response;
//   } else {
//     throw Exception("Failed to update task details");
//   }
// }

Future<http.Response> updateTaskWithDetails({
  required int productId,
  required String orderId,
  required String taskTitle,
  required String description,
  required String videoLink,
  required List<File> imageLinks, // List of images to upload
}) async {
  var url = "$baseUrl/api/updateTaskWithDetails";
  Map<String, String> headers = {
    'Content-Type': 'multipart/form-data',
  };

  var request = http.MultipartRequest('POST', Uri.parse(url))
    ..fields['product_id'] = productId.toString()
    ..fields['order_id'] = orderId.toString()
    ..fields['task_title'] = taskTitle
    ..fields['description'] = description
    ..fields['video_link'] = videoLink
    ..headers.addAll(headers);
print("Request Fields: ${request.fields}");
  print("Request Headers: ${request.headers}");
  // Add multiple images to the request
  for (File image in imageLinks) {
    request.files.add(await http.MultipartFile.fromPath('image_links[]', image.path));
  }

  print("Request URL: $url");
  print("Request Fields: ${request.fields}");

  // Send the request
  var streamedResponse = await request.send();
  final response = await http.Response.fromStream(streamedResponse);

  print("Response Status Code: ${response.statusCode}");
  print("Response Body updateTaskWithDetails: ${response.body}");

  if (response.statusCode == 200) {
    return response;
  } else {
    throw Exception("Failed to update task details");
  }
}

 Future<http.Response> uploadProfileImage(File imageFile, String email) async {
  var url = Uri.parse("$baseUrl/api/uploadProfileImage"); // Your endpoint

  var request = http.MultipartRequest('POST', url);
  // Adding image as multipart file
  String mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg'; // Get the mime type of the file
  var multipartFile = await http.MultipartFile.fromPath(
    'file_pic', // Name of the field expected by the backend
    imageFile.path,
    contentType: MediaType.parse(mimeType),
  );

  request.files.add(multipartFile);

  // Adding other fields (like email) to the request
  request.fields['email'] = email;

  // Send request
  var streamedResponse = await request.send();

  // Get the response
  var response = await http.Response.fromStream(streamedResponse);

  print("Response Status Code: ${response.statusCode}");
  print("Response Body: ${response.body}");

  if (response.statusCode == 200) {
    return response; // Successful upload
  } else {
    throw Exception("Failed to upload profile image");
  }
}

  Future<http.Response> lockTask(String orderId, int productId) async {


    var url = "$baseUrl/api/lock_task";

    var body = jsonEncode({"order_id": orderId, "product_id": productId});
    print("Request URL: $url");
    print("Request Body: $body");

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    print("Response Status Code: ${response.statusCode}");
    print("Response Body lockTask: ${response.body}");

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception("Failed to lock task");
    }
  }
  Future<void> registerUser(String name, String email, bool rememberMe) async {
    var url = "$baseUrl/api/registerinfluencer";
    var body = jsonEncode({
      "name": name,
      "email": email,
      "remember_me": rememberMe,
    });
    print("Request URL: $url");
    print("Request Body: $body");

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      print("User registered successfully");
    } else {
      throw Exception("Failed to register user: ${response.statusCode}");
    }
  }

  Future<http.Response> modifyTask(String orderId, String description) async {
  var url = "$baseUrl/api/modify_task";
  var body = jsonEncode({"order_id": orderId, "description": description});
  print("Request URL: $url");
  print("Request Body: $body");
  final response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: body,
  );
  print("Response Status Code: ${response.statusCode}");
  print("Response Body modifyTask: ${response.body}");
  if (response.statusCode == 200) {
    return response;
  } else {
    throw Exception("Failed to modify task");
  }
}



Future<http.Response> orderDetail(String orderId, String email) async {
  var url = "$baseUrl/api/orderdetail";
  var body = jsonEncode({"order_id": orderId, "email": email});
  print("Request URL: $url");
  print("Request Body: $body");

  final response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: body,
  );

  print("Response Status Code: ${response.statusCode}");
  print("Response Body orderdetail: ${response.body}");

  if (response.statusCode == 200) {
    // Decode the response body to check its structure
    var decodedResponse = jsonDecode(response.body);

    if (decodedResponse is List) {
      // Handle the response as a list of maps
      print("Order Details: $decodedResponse");
      return response;
    } else {
      // If it's not a list, throw an error
      throw Exception("Unexpected response format");
    }
  } else {
    throw Exception("Failed to fetch order details");
  }
}


  Future<http.Response> approveTask(String orderId) async {
    var url = "$baseUrl/api/approve_task";
    var body = jsonEncode({"order_id": orderId});
    print("Request URL: $url");
    print("Request Body: $body");
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    print("Response Status Code: ${response.statusCode}");
    print("Response Body approveTask: ${response.body}");
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception("Failed to approve task");
    }
  }

}