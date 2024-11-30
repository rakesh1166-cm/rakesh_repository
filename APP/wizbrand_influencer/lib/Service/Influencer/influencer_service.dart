import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // for setting the media type of files
import 'package:path/path.dart'; // for getting file extension and file names
import 'package:mime/mime.dart';
import 'package:wizbrand_influencer/model/cartsocial.dart'; 
import 'package:wizbrand_influencer/model/mytask.dart';
import 'package:wizbrand_influencer/model/profile.dart';
import 'package:wizbrand_influencer/model/search_influencer.dart';
import 'package:wizbrand_influencer/model/country.dart';
import 'package:wizbrand_influencer/model/states.dart';
import 'package:wizbrand_influencer/model/city.dart';
import 'package:wizbrand_influencer/model/summary.dart';
import 'package:wizbrand_influencer/model/task.dart';
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
  Future<List<Task>> fetchfilterWallet(String? email) async {
    var url = "$baseUrl/api/filterwallet";
    var body = jsonEncode({"email": email});
    print("Request URL: $url");
    print("Request Body: $body");

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    print("Response Status fetchTask1: ${response.statusCode}");
    print("Response Body fetchTask4: ${response.body}");

 if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    return body.map((task) => Task.fromJson(task)).toList();
  } else {
    throw Exception("Failed to fetch states");
  }
  }

    Future<http.Response> rejectTask(String orderId) async {
    var url = "$baseUrl/api/reject_task";
    var body = jsonEncode({"order_id": orderId});
    print("Request URL: $url");
    print("Request Body: $body");

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    print("Response Status Code: ${response.statusCode}");
    print("Response Body rejectTask: ${response.body}");

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception("Failed to reject task");
    }
  }
Future<SearchInfluencer> influencerData(String? email) async {
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
    Map<String, dynamic> body = jsonDecode(response.body);
    return SearchInfluencer.fromJson(body);
  } else {
    throw Exception("Failed to fetch influencer data");
  }
}
  Future<TaskSummary> fetchTask(String? email) async {
    var url = "$baseUrl/api/fetchtask";
    var body = jsonEncode({"email": email});
    print("Request URL: $url");
    print("Request Body: $body");

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    print("Response Status fetchTask2: ${response.statusCode}");
    print("Response Body fetchTask1: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch tasks");
    }

    Map<String, dynamic> responseData = jsonDecode(response.body);
    return TaskSummary.fromJson(responseData);
  }
Future<List<Task>> fetchfilterTask(String? email) async {
    var url = "$baseUrl/api/filtertask";
    var body = jsonEncode({"email": email});
    print("Request URL: $url");
    print("Request Body fetchfilterTask: $body");

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    print("Response Status fetchTask3: ${response.statusCode}");
    print("Response Body fetchTask2: ${response.body}");

 if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    return body.map((task) => Task.fromJson(task)).toList();
  } else {
    throw Exception("Failed to fetch states");
  }
  }

//






  




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

Future<List<Mytask>> fetchmyTask(String? email) async {
  if (email == null || email.isEmpty) {
    throw Exception("Email is null or empty");
  }

  var url = "$baseUrl/api/fetchmytask";
  var body = jsonEncode({"email": email});
  print("Request URL: $url");
  print("Request Body: $body");

  final response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: body,
  );
  print("Response Status fetchmyTask: ${response.statusCode}");
  print("Response Body fetchmyTask: ${response.body}");

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    
    if (data is Map<String, dynamic>) {
      List<Mytask> tasks = [];
      data.forEach((key, value) {
        if (value is List) {
          tasks.addAll(value.map((item) => Mytask.fromJson(item)).toList());
        }
      });
      return tasks;
    } else {
      throw Exception("Unexpected data format: $data");
    }
  } else {
    throw Exception("Failed to fetch orders");
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
 Future<void> submitFormData(Map<String, String> formData, String endpoint) async {
     print("endpoint URL: $endpoint");
    var url = "$baseUrl/api/$endpoint";
    var body = jsonEncode(formData);
    print("Request URL: $url");
    print("Request Body: $body");
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    print("Response Status Code: ${response.statusCode}");
    print("Response Body submitFormData: ${response.body}");
    if (response.statusCode != 200) {
      throw Exception("Failed to submit form data to $endpoint");
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

Future<void> updateTaskStatus(int taskId, String status, String email, {String? workUrl, String? description}) async {
    var url = "$baseUrl/api/update_task_status";
    var body = jsonEncode({
      "task_id": taskId,
      "status": status,
      "email": email,
      "work_url": workUrl,
      "description": description
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
      throw Exception("Failed to update task status");
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
    print("Response Body fetchTask3: ${response.body}");
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
  Future<http.Response> updateTaskWithDetails({
    required int productId,
    required int orderId,
    required String taskTitle,
    required String description,
    required String videoLink,
    required List<String> imageLinks,
  }) async {
    var url = "$baseUrl/api/updateTaskWithDetails";
    var body = jsonEncode({
      "product_id": productId,
      "order_id": orderId,
      "task_title": taskTitle,
      "description": description,
      "video_link": videoLink,
      "image_links": imageLinks,
    });
    print("Request URL: $url");
    print("Request Body: $body");

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    print("Response Status Code: ${response.statusCode}");
    print("Response Body updateTaskWithDetails: ${response.body}");
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception("Failed to update task details");
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