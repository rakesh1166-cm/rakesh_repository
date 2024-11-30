import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // for setting the media type of files
import 'package:path/path.dart'; // for getting file extension and file names
import 'package:mime/mime.dart';
import 'package:wizbrand/model/city.dart';
import 'package:wizbrand/model/competitor.dart';
import 'package:wizbrand/model/country.dart';
import 'package:wizbrand/model/email.dart';
import 'package:wizbrand/model/guest.dart';
import 'package:wizbrand/model/organization.dart';
import 'package:wizbrand/model/phone.dart';
import 'package:wizbrand/model/profile.dart';
import 'package:wizbrand/model/projectmodel.dart';
import 'package:wizbrand/model/search_influencer.dart';
import 'package:wizbrand/model/states.dart';
import 'package:wizbrand/model/summary.dart';
import 'package:wizbrand/model/url.dart';
import 'package:wizbrand/model/userorganization.dart';
import 'package:wizbrand/model/socialrank.dart';
import 'package:wizbrand/model/taskboard.dart';
import 'package:wizbrand/model/webassets.dart';
import 'package:wizbrand/model/webrating.dart';
import 'package:wizbrand/model/interval_task.dart';
import 'package:wizbrand/model/keyword.dart';
import 'package:wizbrand/model/projectmodel.dart';
import 'package:wizbrand/model/rating.dart';
import 'package:wizbrand/model/page.dart';
import 'package:wizbrand/model/webtokens.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class OrganizationAPI {

  String baseUrl = "https://www.wizbrand.com";
  final String probaseUrl = "https://www.wizbrand.com/wz-projects-ms";
  final String orgbaseUrl = "https://www.wizbrand.com/wz-organisation-ms";
  final String urlBaseUrl = "https://www.wizbrand.com/wz-add-urls-ms";
  final String keywordUrl = "https://www.wizbrand.com/wz-keywords-ms";
  final String RatingUrl = "https://www.wizbrand.com/wz-team-rating-ms";
  final String CompetitorUrl = "https://www.wizbrand.com/wz-competetiors-ms"; 
  final String webrankUrl = "https://www.wizbrand.com/wz-website-ranking-ms";
  final String SocialRankUrl = "https://www.wizbrand.com/wz-social-ranking-ms";
  final String TaskUrl =   "https://www.wizbrand.com/wz-tasks-board-ms";
  final String webRatingUrl = "https://www.wizbrand.com/wz-website-ranking-ms"; 
  final String pagerankUrl = "https://www.wizbrand.com/wz-page-ranking-ms"; 
  final String webaccessUrl = "https://www.wizbrand.com/wz-website-access-ms";
  final String youtubeUrl = "https://www.wizbrand.com/socialapi/youtube"; 
  final String instagramUrl = "https://www.wizbrand.com/socialapi/instagram"; 
  final String twitterUrl = "https://www.wizbrand.com/socialapi/twitter";
  final String emailUrl = "https://www.wizbrand.com/wz-email-access-ms";
  final String phoneUrl = "https://www.wizbrand.com/wz-phone-number-ms";
  final String intervalTaskUrl = "https://www.wizbrand.com/wz-interval-task-ms";
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();



  

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

Future<http.Response> createTask(Map<String, dynamic> requestData, String? attachmentFilePath) async {
  var apiUrl = "$TaskUrl/api/create_task"; // Replace with your actual API endpoint  
  // Create a multipart request
  var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
  // Add the form fields from requestData
  requestData.forEach((key, value) {
    request.fields[key] = value.toString();
  });
  // Check if there's an attachment file, and add it if it exists
  if (attachmentFilePath != null && attachmentFilePath.isNotEmpty) {
    File attachmentFile = File(attachmentFilePath);
   
    if (await attachmentFile.exists()) {
      request.files.add(await http.MultipartFile.fromPath(
        'attachment', // The field name that your API expects for the file
        attachmentFile.path,
      ));
    }
  }
  print("Attachment File Path: $attachmentFilePath");
  print("Request createTask URL: $apiUrl");
  print("Request Fields: ${request.fields}");
  // Send the multipart request
  var streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);
  print("Response Status Code: ${response.statusCode}");
  print("Response Body: ${response.body}");
  return response;
}



 Future<http.Response> openwebasset(Map<String, dynamic> requestData, String? attachmentFilePath) async {  
     var apiUrl = "$baseUrl/api/open_web_asset"; // Replace with your actual API endpoint
  var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
  // Add the form fields from requestData
  requestData.forEach((key, value) {
    request.fields[key] = value.toString();
  });
  // Check if there's an attachment file, and add it if it exists
  if (attachmentFilePath != null && attachmentFilePath.isNotEmpty) {
    File attachmentFile = File(attachmentFilePath);
    
    if (await attachmentFile.exists()) {
      request.files.add(await http.MultipartFile.fromPath(
        'attachment', // The field name that your API expects for the file
        attachmentFile.path,
      ));
    }
  }  print("Attachment File Path: $attachmentFilePath");
  print("Request openwebasset URL: $apiUrl");
  print("Request Fields: ${request.fields}");
  // Send the multipart request
  var streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);
  print("Response Status Code: ${response.statusCode}");
  print("Response Body: ${response.body}");
  return response;

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

Future<http.Response> createGuestMessage(Map<String, dynamic> requestData) async {
  var apiUrl = "$baseUrl/api/create_guest_message"; // Replace with your actual API endpoint
  var body = jsonEncode(requestData); // Convert requestData map to JSON
  print("Request URL createGuestMessage: $apiUrl");
  print("Request Body createGuestMessage: $body");
  // Making the POST request to the backend
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      "Content-Type": "application/json",
    },
    body: body,
  );
  print("Response Status Code: ${response.statusCode}");
  print("Response Body: ${response.body}");
  return response; // Return the response to be handled in the ViewModel
}


 Future<http.Response> createTaskinterval(Map<String, dynamic> requestData) async {
    var apiUrl = "$intervalTaskUrl/api/create_interval_task"; // Replace with your actual API endpoint
    var body = jsonEncode(requestData); // Convert requestData map to JSON
    print("Request URL createIntervalTask: $apiUrl");
    print("Request Body createIntervalTask: $body");
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    return response; // Return the response to be handled in the ViewModel
  }


 Future<http.Response> updateTaskinterval(Map<String, dynamic> requestData) async {
    var apiUrl = "$intervalTaskUrl/api/update_interval_task"; // Replace with your actual API endpoint
    var body = jsonEncode(requestData); // Convert request data to JSON
    print("Request URL updateIntervalTask: $apiUrl");
    print("Request Body updateIntervalTask: $body");
    try {
      // Make the POST request to update the interval task
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      return response; // Return the response to be handled in the ViewModel
    } catch (e) {
      print('Error during updateIntervalTask API call: $e');
      throw Exception('Failed to update interval task');
    }
  }



 Future<http.Response> updateWebasset(Map<String, dynamic> requestData) async {   
    var apiUrl = "$baseUrl/api/update_web_asset"; // Replace with your actual API endpoint
    var body = jsonEncode(requestData); // Convert request data to JSON
    print("Request URL updateWebasset: $apiUrl");
    print("Request Body updateWebasset: $body");
    try {
      // Make the POST request to update the interval task
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      return response; // Return the response to be handled in the ViewModel
    } catch (e) {
      print('Error during updateWebasset API call: $e');
      throw Exception('Failed to update interval task');
    }
  }




Future<http.Response> updateGuestMessage(Map<String, dynamic> requestData) async {
  var apiUrl = "$baseUrl/api/update_guest_message"; // Replace with your actual API endpoint
  var body = jsonEncode(requestData); // Convert request body to JSON
  print("Request URL updateGuestMessage: $apiUrl");
  print("Request Body updateGuestMessage: $body");
  try {
    // Make the POST request to update the guest message
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    return response; // Return the response to be handled in the ViewModel
  } catch (e) {
    print('Error during updateGuestMessage API call: $e');
    throw Exception('Failed to update guest message');
  }
}


  Future<http.Response> updateOrganization(String email, String organizationId, String newName) async {
    var url = "$baseUrl/api/update_organization";
    var body = jsonEncode({
      "email": email,
      "organization_id": organizationId,
      "organization_name": newName,
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
    return response;
  }



  Future<http.Response> deleteOrganization(String email, String organizationId) async {
    var url = "$baseUrl/api/delete_organization";
    var body = jsonEncode({
      "email": email,
      "organization_id": organizationId,
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

    return response;
  }

  
  Future<http.Response> saveOrganization(String email, String organizationName) async {
    var url = "$baseUrl/api/save_organization";
    var body = jsonEncode({
      "email": email,
      "organization_name": organizationName,
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
    return response;
  }


  Future<List<Organization>> getUsers(String orgSlug, String email) async {
    var url = "$baseUrl/api/get_users";
    var body = jsonEncode({
      "org_slug": orgSlug,
      "email": email,
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
      List<dynamic> body = jsonDecode(response.body);
      return body.map((user) => Organization.fromJson(user)).toList();
    } else {
      throw Exception("Failed to fetch users");
    }
  }


Future<List<Organization>> organizationData() async {
  var url = "$baseUrl/api/get_organisation/";
  final response = await http.get(Uri.parse(url));  
  // Print the response body for debugging
  print("Response SearchInfluencer body: ${response.body}");
  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);    
    // Print the decoded JSON body for further inspection
    print("Decoded JSON: $body");
    return body.map((user) => Organization.fromJson(user)).toList();
  } else {
    throw Exception("Failed to upload influencer data");
  }
}


Future<List<Organization>> userorganizationData({String? email}) async {
  // Construct the URL with optional query parameter for email
  var url = "$baseUrl/api/get_userorganisation/";

  // If email is provided, add it as a query parameter
  if (email != null && email.isNotEmpty) {
    url += "?email=$email";
  }

  // Make the HTTP GET request
  final response = await http.get(Uri.parse(url));  

  // Print the response body for debugging
  print("Response SearchInfluencer body: ${response.body}");

  if (response.statusCode == 200) {
    // Decode the JSON response body
    List<dynamic> body = jsonDecode(response.body);    
    
    // Print the decoded JSON body for further inspection
    print("Decoded JSON: $body");
    
    // Map the decoded JSON to a list of UserOrganization objects
    return body.map((user) => Organization.fromJson(user)).toList();
  } else {
    // Throw an error if the request failed
    throw Exception("Failed to fetch organization data");
  }
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
    print("Response login Body: ${response.body}");    
  if (response.statusCode == 200) {
    var responseData = jsonDecode(response.body);
    
    // Extract the user's name
    String userName = responseData['user']['name'];
    print("User Name: $userName"); // You can print or use the userName as needed
    await secureStorage.write(key: 'userName', value: userName);
    // Assuming you still want to return success status
    return responseData['success']; // Adjust this according to your API response
  } else {
      throw Exception("Failed to login");
    }
  }

Future<List<UserOrganization>> getUserData(String email, String orgSlug) async {
  var url = "$baseUrl/api/get_user_data"; // Replace with your actual API endpoint
  var body = jsonEncode({
    "email": email,
    "org_slug": orgSlug,
  });
  print("Request URL: $url");
  print("Request Body: $body");
  final response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: body,
  );
  print("Response Status Code: ${response.statusCode}");
  print("Response Body getUserData: ${response.body}");
  if (response.statusCode == 200) {
    // Parse the response body to a Map<String, dynamic>
    Map<String, dynamic> responseData = jsonDecode(response.body);
    // Extract the 'data' field
    var organizationsData = responseData['data'];
    // Check if the 'data' is a List or String
    if (organizationsData is List) {
      // Convert the List<dynamic> into a List<UserOrganization>
      return organizationsData.map((data) => UserOrganization.fromJson(data)).toList();
    } else if (organizationsData == "No_Data") {
      // If no data is available, return an empty list or handle as needed
      return [];
    } else {
      throw Exception("Unexpected data format");
    }
  } else {
    throw Exception("Failed to fetch user data");
  }
}


 Future<http.Response> inviteUser(
    String loggedInUserEmail, // Email of the logged-in user
    String inviteeEmail, // Email of the invitee
    String role, // Role to assign to the invitee
    String orgSlug, // Role to assign to the invitee
    String orgRoleId,
    String orgUserId,
    String  orgUserorgId// the role to assign
    
  ) async {
    var url = "$orgbaseUrl/api/invite_user"; // Replace with the actual API endpoint
    var body = jsonEncode({
      "logged_in_user_email": loggedInUserEmail, // Who is sending the invite
      "invitee_email": inviteeEmail, // Who is being invited
      "role": role, // Role for the invitee
      "org_slug": orgSlug,
      "orgRoleId": orgRoleId,
      "orgUserId": orgUserId,
      "orgUserorgId": orgUserorgId,
    });
    print("Request URL: $url");
    print("Request Body: $body");

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    return response;
  }




  Future<http.Response> createProject(
    String loggedInUserEmail, // Email of the logged-in user
    String projectName, // Name of the project
    String projectUrl, // URL of the project
    String managerEmail, // Email of the project manager
    String orgSlug, // Organization slug
    String orgRoleId, 
    String orgUserId, 
    String orgUserorgId, 
  ) async {
    var url = "$probaseUrl/api/create_project"; // Replace with the actual API endpoint
    var body = jsonEncode({
      "logged_in_user_email": loggedInUserEmail, // Email of the user creating the project
      "project_name": projectName, // Name of the project
      "project_url": projectUrl, // URL of the project
      "manager_email": managerEmail, // Email of the project manager
      "org_slug": orgSlug, // Organization slug
      "org_roleid": orgRoleId, // Organization slug
      "org_userid": orgUserId, // Organization slug
      "org_userorgid": orgUserorgId, // Organization slug   
    });
    
    print("Request URL: $url");
    print("Request Body: $body");
    // Making the POST request to the backend
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    return response; // Return the response to be handled in the ViewModel
  }


   Future<http.Response> updateProject(
    String loggedInUserEmail, // Email of the logged-in user
    String projectName, // Name of the project
    String projectUrl, // URL of the project
    String managerEmail, // Email of the project manager
    String orgSlug, // Organization slug
    String projectId, // Project ID for updating
    String orgRoleId, // Organization role ID
    String orgUserId, // Organization user ID
    String orgUserorgId, // Organization user org ID
  ) async {
    var url = "$probaseUrl/api/update_project/$projectId"; // Replace with actual API endpoint and pass the projectId
    var body = jsonEncode({
      "logged_in_user_email": loggedInUserEmail,
      "project_name": projectName,
      "project_url": projectUrl,
      "manager_email": managerEmail,
      "org_slug": orgSlug,
      "org_roleid": orgRoleId,
      "org_userid": orgUserId,
      "org_userorgid": orgUserorgId,  
    });

    print("Request URL: $url");
    print("Request Body: $body");

    // Making the PUT request to update the project
    final response = await http.put(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    return response; // Return the response to be handled in the ViewModel
  }



  Future<http.Response> updateUrl(Map<String, dynamic> requestBody) async {
    // Define the endpoint for updating the URL
    var apiUrl = "$urlBaseUrl/api/update_url"; // Replace with your actual API endpoint for updating URLs

    print("Request URL: $apiUrl");
    print("Request Body: ${jsonEncode(requestBody)}");

    try {
      // Make the PUT request to update the URL
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody), // Convert requestBody to a JSON string
      );

      // Log the response status and body for debugging
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      // Return the response to be handled in the ViewModel
      return response;
    } catch (e) {
      print('Error during the updateUrl API call: $e');
      throw Exception('Failed to update URL');
    }
  }


  Future<http.Response> deleteProject(int projectId, String orgSlug) async {
    var url = '$probaseUrl/api/delete_project/$projectId?org_slug=$orgSlug'; // Update with your actual API endpoint
    print("Request URL: $url");
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
    );
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");    
    return response;
  }


 Future<http.Response> deleteEmail(int emailId, String orgSlug) async {
    var url = '$emailUrl/api/delete_email/$emailId?org_slug=$orgSlug'; // Update with your actual API endpoint
    print("Request URL: $url");
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
    );
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");    
    return response;
  }

 Future<http.Response> deletePhone(int phoneId, String orgSlug) async {
    var url = '$phoneUrl/api/delete_phone/$phoneId?org_slug=$orgSlug'; // Update with your actual API endpoint
    print("Request URL: $url");
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
    );
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");    
    return response;
  }



 Future<http.Response> deleteGuest(int guest, String orgSlug) async {
    var url = '$baseUrl/api/delete_guest/$guest?org_slug=$orgSlug'; // Update with your actual API endpoint
    print("Request URL: $url");
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
    );
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");    
    return response;
  }




    Future<http.Response> deleteasset(String webId) async {
    var apiUrl = "$webaccessUrl/api/delete_webasset/$webId"; // Replace with your actual API endpoint

    print("Request URL: $apiUrl");

    try {
      // Make the DELETE request to the API
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // Log the response status and body for debugging
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      return response;
    } catch (e) {
      print('Error during the deleteUrl API call: $e');
      throw Exception('Failed to delete URL');
    }
  }

 

  Future<http.Response> deleteKey(String keyId) async {
    var apiUrl = "$webaccessUrl/api/delete_webkey/$keyId"; // Replace with your actual API endpoint

    print("Request URL: $apiUrl");

    try {
      // Make the DELETE request to the API
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // Log the response status and body for debugging
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      return response;
    } catch (e) {
      print('Error during the deleteUrl API call: $e');
      throw Exception('Failed to delete URL');
    }
  }
  Future<http.Response> deleteUrl(String urlId) async {
    var apiUrl = "$urlBaseUrl/api/delete_url/$urlId"; // Replace with your actual API endpoint

    print("Request URL: $apiUrl");

    try {
      // Make the DELETE request to the API
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // Log the response status and body for debugging
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      return response;
    } catch (e) {
      print('Error during the deleteUrl API call: $e');
      throw Exception('Failed to delete URL');
    }
  }


  Future<http.Response> deleteWeb(String webId) async {
    var apiUrl = "$webrankUrl/api/delete_web/$webId"; // Replace with your actual API endpoint

    print("Request URL: $apiUrl");

    try {
      // Make the DELETE request to the API
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // Log the response status and body for debugging
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      return response;
    } catch (e) {
      print('Error during the deleteUrl API call: $e');
      throw Exception('Failed to delete URL');
    }
  }

 Future<http.Response> deletePage(String pageId) async {
    var apiUrl = "$pagerankUrl/api/delete_page/$pageId"; // Replace with your actual API endpoint

    print("Request URL: $apiUrl");

    try {
      // Make the DELETE request to the API
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // Log the response status and body for debugging
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      return response;
    } catch (e) {
      print('Error during the deleteUrl API call: $e');
      throw Exception('Failed to delete URL');
    }
  }
  


  Future<http.Response> deleteCompetitor(String competitorid) async {
    var apiUrl = "$CompetitorUrl/api/deleteCompetitor/$competitorid"; // Replace with your actual API endpoint

    print("Request URL: $apiUrl");

    try {
      // Make the DELETE request to the API
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // Log the response status and body for debugging
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      return response;
    } catch (e) {
      print('Error during the deleteUrl API call: $e');
      throw Exception('Failed to delete URL');
    }
  }




  Future<http.Response> deleteRating(String ratingid) async {
    var apiUrl = "$RatingUrl/api/deleteRating/$ratingid"; // Replace with your actual API endpoint
    print("Request URL: $apiUrl");
    try {
      // Make the DELETE request to the API
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      // Log the response status and body for debugging
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      return response;
    } catch (e) {
      print('Error during the deleteUrl API call: $e');
      throw Exception('Failed to delete URL');
    }
  }




  Future<http.Response> deleteTask(String taskid) async {
    var apiUrl = "$TaskUrl/api/deleteTask/$taskid"; // Replace with your actual API endpoint
    print("Request URL: $apiUrl");
    try {
      // Make the DELETE request to the API
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      // Log the response status and body for debugging
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      return response;
    } catch (e) {
      print('Error during the deleteUrl API call: $e');
      throw Exception('Failed to delete URL');
    }
  }

  Future<http.Response> deleteIntervaltask(String taskid) async {
    var apiUrl = "$intervalTaskUrl/api/deleteIntervaltask/$taskid"; // Replace with your actual API endpoint
    print("Request URL: $apiUrl");
    try {
      // Make the DELETE request to the API
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      // Log the response status and body for debugging
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      return response;
    } catch (e) {
      print('Error during the deleteUrl API call: $e');
      throw Exception('Failed to delete URL');
    }
  }
 Future<http.Response> deleteKeyword(String urlId) async {
    var apiUrl = "$keywordUrl/api/delete_keyword/$urlId"; // Replace with your actual API endpoint

    print("Request URL: $apiUrl");

    try {
      // Make the DELETE request to the API
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // Log the response status and body for debugging
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      return response;
    } catch (e) {
      print('Error during the deleteUrl API call: $e');
      throw Exception('Failed to delete URL');
    }
  }




Future<http.Response> updateKeyword(String keywordId, Map<String, dynamic> requestBody) async {
  var apiUrl = "$keywordUrl/api/update_keyword/$keywordId"; // Replace with the actual API endpoint for updating keywords

  // Convert the requestBody map to JSON
  var body = jsonEncode(requestBody);

  print("Request URL: $apiUrl");
  print("Request Body: $body");

  try {
    // Make the PUT request to update the keyword
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    return response; // Return the response to be handled in the ViewModel
  } catch (e) {
    print('Error during updateKeyword API call: $e');
    throw Exception('Failed to update keyword');
  }
}




  Future<http.Response> updateCompetitorUrl(String competitorId, Map<String, dynamic> requestBody) async {
  var apiUrl = "$CompetitorUrl/api/update_competitor"; // API endpoint for updating competitors
  
  // Add the competitorId to the request body
  requestBody['competitorId'] = competitorId;

  var body = jsonEncode(requestBody); // Convert the request body to JSON

  print("Request URL: $apiUrl");
  print("Request Body: $body");

  try {
    // Make the POST request to update the competitor
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    return response; // Return the response to be handled in the ViewModel
  } catch (e) {
    print('Error during updateCompetitorUrl API call: $e');
    throw Exception('Failed to update competitor');
  }
}


  Future<http.Response> createEmail(Map<String, dynamic> requestData) async {
    var apiUrl = "$emailUrl/api/create_email"; // Replace with your actual API endpoint
    var body = jsonEncode(requestData); // Convert requestData map to JSON
    print("Request URL createEmail: $apiUrl");
    print("Request Body createEmail: $body");

    // Making the POST request to the backend
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    return response; // Return the response to be handled in the ViewModel
  }

  Future<http.Response> generatekey(Map<String, dynamic> requestData) async {
    var apiUrl = "$baseUrl/api/generate_key"; // Replace with your actual API endpoint
    var body = jsonEncode(requestData); // Convert requestData map to JSON
    print("Request URL generatekey: $apiUrl");
    print("Request Body generatekey: $body");

    // Making the POST request to the backend
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    return response; // Return the response to be handled in the ViewModel
  }

Future<http.Response> createPhone(Map<String, dynamic> requestData) async {
  var apiUrl = "$phoneUrl/api/create_phone"; // Replace with your actual API endpoint
  var body = jsonEncode(requestData); // Convert requestData map to JSON
  print("Request URL createPhone: $apiUrl");
  print("Request Body createPhone: $body");

  // Making the POST request to the backend
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      "Content-Type": "application/json",
    },
    body: body,
  );
  
  print("Response Status Code: ${response.statusCode}");
  print("Response Body: ${response.body}");
  
  return response; // Return the response to be handled in the ViewModel
}

Future<http.Response> updatePhone(Map<String, dynamic> requestData) async {
  var apiUrl = "$phoneUrl/api/update_phone"; // API endpoint for updating phone
  var body = jsonEncode(requestData); // Convert the request body to JSON
  print("Request URL updatePhone: $apiUrl");
  print("Request Body updatePhone: $body");

  try {
    // Make the POST request to update the phone
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    return response; // Return the response to be handled in the ViewModel
  } catch (e) {
    print('Error during updatePhone API call: $e');
    throw Exception('Failed to update phone');
  }
}



Future<http.Response> updateTask(Map<String, dynamic> requestData) async {
  var apiUrl = "$phoneUrl/api/update_task"; // API endpoint for updating phone
  var body = jsonEncode(requestData); // Convert the request body to JSON
  print("Request URL updatePhone: $apiUrl");
  print("Request Body updatePhone: $body");

  try {
    // Make the POST request to update the phone
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    return response; // Return the response to be handled in the ViewModel
  } catch (e) {
    print('Error during updatePhone API call: $e');
    throw Exception('Failed to update phone');
  }
}
  Future<http.Response> updateEmail(Map<String, dynamic> requestData) async {
    var apiUrl = "$emailUrl/api/update_email"; // API endpoint for updating email
    var body = jsonEncode(requestData); // Convert the request body to JSON
    print("Request URL updateEmail: $apiUrl");
    print("Request Body updateEmail: $body");
    try {
      // Make the POST request to update the email
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      return response; // Return the response to be handled in the ViewModel
    } catch (e) {
      print('Error during updateEmail API call: $e');
      throw Exception('Failed to update email');
    }
  }

  Future<http.Response> updateRating( Map<String, dynamic> requestBody) async {
  var apiUrl = "$RatingUrl/api/update_rating"; // API endpoint for updating competitors  
  // Add the competitorId to the request body
  var body = jsonEncode(requestBody); // Convert the request body to JSON
  print("Request URL: $apiUrl");
  print("Request Body: $body");

  try {
    // Make the POST request to update the competitor
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    return response; // Return the response to be handled in the ViewModel
  } catch (e) {
    print('Error during updateCompetitorUrl API call: $e');
    throw Exception('Failed to update competitor');
  }
}


  Future<http.Response> updateWebRating( Map<String, dynamic> requestBody) async {
  var apiUrl = "$webrankUrl/api/update_webrating"; // API endpoint for updating competitors  
  // Add the competitorId to the request body
  var body = jsonEncode(requestBody); // Convert the request body to JSON
  print("Request URL: $apiUrl");
  print("Request Body: $body");
  try {
    // Make the POST request to update the competitor
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    return response; // Return the response to be handled in the ViewModel
  } catch (e) {
    print('Error during updateCompetitorUrl API call: $e');
    throw Exception('Failed to update competitor');
  }
}

  Future<http.Response> updatePagerank( Map<String, dynamic> requestBody) async {
  var apiUrl = "$pagerankUrl/api/update_pagerating"; // API endpoint for updating competitors  
  // Add the competitorId to the request body
  var body = jsonEncode(requestBody); // Convert the request body to JSON
  print("Request URL: $apiUrl");
  print("Request Body: $body");
  try {
    // Make the POST request to update the competitor
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    return response; // Return the response to be handled in the ViewModel
  } catch (e) {
    print('Error during updateCompetitorUrl API call: $e');
    throw Exception('Failed to update competitor');
  }
}




  Future<http.Response> createKeyword(Map<String, dynamic> requestData) async {
    var apiUrl = "$keywordUrl/api/create_keyword"; // Replace with your actual API endpoint

    // Convert requestData map to JSON
    var body = jsonEncode(requestData);

    print("Request URL: $apiUrl");
    print("Request Body: $body");

    // Making the POST request to the backend
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    return response; // Return the response to be handled in the ViewModel
  }

    // Method to create a rating


  Future<http.Response> createRating(Map<String, dynamic> requestData) async {

    var apiUrl = "$RatingUrl/api/create_rating"; // Replace with your actual API endpoint
    // Convert requestData map to JSON
    var body = jsonEncode(requestData);
    print("Request URL createRating: $apiUrl");
    print("Request Body createRating: $body");
    // Making the POST request to the backend
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    return response; // Return the response to be handled in the ViewModel    
  }




 Future<http.Response> createCompetitorUrl(Map<String, dynamic> requestData) async {
    var apiUrl = "$CompetitorUrl/api/create_competitor_url"; // Replace with your actual API endpoint
    // Convert requestData map to JSON
    var body = jsonEncode(requestData);
    print("Request createCompetitorUrl URL: $apiUrl");
    print("Request Body: $body");
    // Making the POST request to the backend
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    return response; // Return the response to be handled in the ViewModel
  }

   Future<http.Response> createSocialwizard(Map<String, dynamic> requestData) async {
    var apiUrl = "$webaccessUrl/api/create_webaccess"; // Replace with your actual API endpoint
    // Convert requestData map to JSON
    var body = jsonEncode(requestData);
    print("Request createCompetitorUrl URL: $apiUrl");
    print("Request Body: $body");
    // Making the POST request to the backend
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    return response; // Return the response to be handled in the ViewModel
  }


 Future<http.Response> createWebrank(Map<String, dynamic> requestData) async {
    var apiUrl = "$webrankUrl/api/create_webrank"; // Replace with your actual API endpoint
    // Convert requestData map to JSON
    var body = jsonEncode(requestData);    
    print("Request createWebrank URL: $apiUrl");
    print("Request Body: $body");
    // Making the POST request to the backend
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");    
    return response; // Return the response to be handled in the ViewModel
  }

  
Future<http.Response> createPagerank(Map<String, dynamic> requestData) async {
    var apiUrl = "$pagerankUrl/api/create_pagerank"; // Replace with your actual API endpoint
    var body = jsonEncode(requestData);

    print("Request createPagerank URL: $apiUrl");
    print("Request Body: $body");
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");    
    return response;
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

    Future<http.Response> createUrl(
    String loggedInUserEmail, // Email of the logged-in user
    String projectId, // Name of the project
    String projectUrl, // URL of the project
    String projectName, // Name of the project
    String orgSlug, // Organization slug
    String orgRoleId, // Organization role ID
    String orgUserId, // Organization user ID
    String orgUserorgId, // Organization user organization ID
  ) async {
    var url = "$urlBaseUrl/api/create_url"; // Replace with the actual API endpoint for creating a URL
    var body = jsonEncode({
      "logged_in_user_email": loggedInUserEmail, // Email of the user creating the URL
      "project_id": projectId, // Name of the project
      "project_url": projectUrl, // URL of the project
      "project_name": projectName, // Email of the project manager
      "org_slug": orgSlug, // Organization slug
      "org_roleid": orgRoleId, // Organization role ID
      "org_userid": orgUserId, // Organization user ID
      "org_userorgid": orgUserorgId, // Organization user organization ID   
    });    
    print("Request URL: $url");
    print("Request Body: $body");

    // Making the POST request to the backend
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );
    
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    
    return response; // Return the response to be handled in the ViewModel
  }

  Future<http.Response> createSocialRank(Map<String, dynamic> requestData) async {
    var apiUrl = "$SocialRankUrl/api/create_social_rank"; // Replace with your actual API endpoint
    var body = jsonEncode(requestData);

    print("Request createSocialRank URL: $apiUrl");
    print("Request Body: $body");

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    
    return response;
  }
  Future<http.Response> deleteUser(
                    String loggedEmail, // Email of the logged-in user
                    String email, // Email of the invitee
                    String role, // Role to assign to the invitee
                    String orgSlug, // Organization slug
                  ) async {
                    const String orgbaseUrl = "https://www.wizbrand.com/wz-organisation-ms"; // Specify the base URL here
                    var url = "$orgbaseUrl/api/delete_User"; // Append the specific API endpoint to the base URL
                    var body = jsonEncode({
                      "logged_in_user_email": loggedEmail, // Who is sending the invite
                      "invitee_email": email, // Who is being invited
                      "role": role, // Role for the invitee
                      "org_slug": orgSlug, // Organization slug
                    });                    
                    print("Request URL: $url");
                    print("Request Body: $body");
                    final response = await http.post(
                      Uri.parse(url),
                      headers: {
                        "Content-Type": "application/json",
                      },
                      body: body,
                    );                    
                    print("Response Status Code: ${response.statusCode}");
                    print("Response Body: ${response.body}");
                    return response;
                  }

 Future<http.Response> blockUser(
    String loggedEmail, // Email of the logged-in user
    String email, // Email of the invitee
    String role, // Role to assign to the invitee
    String orgSlug, // Role to assign to the invitee    
  ) async {
    var url = "$baseUrl/api/block_user"; // Replace with the actual API endpoint
    var body = jsonEncode({
      "logged_in_user_email": loggedEmail, // Who is sending the invite
      "invitee_email": email, // Who is being invited
      "role": role, // Role for the invitee
      "org_slug": orgSlug,
    });
    print("Request URL: $url");
    print("Request Body: $body");

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    return response;
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

   Future<http.Response> updateTaskboard( Map<String, dynamic> requestBody) async {        
    var url = "$TaskUrl/api/update_task";
    var body = jsonEncode(requestBody);
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
  required int orderId,
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



Future<List<Project>> fetchProjects(String email, String orgSlug, String orgRoleId, String orgUserId, String orgUserorgId) async {
    
  var url = "$probaseUrl/api/get_projects";  
  // Create the request body including the additional parameters
  var body = jsonEncode({
    "email": email, // Email of the user
    "org_slug": orgSlug, // Organization slug
    "org_role_id": orgRoleId, // User's role ID in the organization
    "org_user_id": orgUserId, // User's ID in the organization
    "org_user_org_id": orgUserorgId // User's organization ID
  });
  print("Request fetchProjects: $url");
  print("Request fetchProjects: $body");
  // Send the POST request to the API
  final response = await http.post(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json", // Set content type as JSON
    },
    body: body,
  );

  print("Response Status fetchProjects: ${response.statusCode}");
  print("Response Body fetchProjects: ${response.body}");

  // Check if the response status is OK (200)
  if (response.statusCode == 200) {
    // Parse the response body to a Map<String, dynamic>
    Map<String, dynamic> responseData = jsonDecode(response.body);

    // Extract the 'data' field
    var projectsData = responseData['data'];

    // Check if the 'data' is a List or String
    if (projectsData is List) {
      // Convert the List<dynamic> into a List<Project>
      return projectsData.map((data) => Project.fromJson(data)).toList();
    } else if (projectsData == "No_Data") {
      // If no data is available, return an empty list or handle as needed
      return [];
    } else {
      throw Exception("Unexpected data format");
    }
  } else {
    throw Exception("Failed to fetch projects data");
  }
}


  Future<List<Url>> fetchUrls(String email, String orgSlug, String orgRoleId, String orgUserId, String orgUserorgId) async {
  
  var url = "$urlBaseUrl/api/get_urls"; // Adjust the API endpoint
  // Create the request body
  var body = jsonEncode({
    "email": email, // Email of the user
    "org_slug": orgSlug, // Organization slug
    "org_role_id": orgRoleId, // User's role ID in the organization
    "org_user_id": orgUserId, // User's ID in the organization
    "org_user_org_id": orgUserorgId // User's organization ID
  });
  print("Request URL: $url");
  print("Request Body: $body");
  // Send the POST request to the API
  final response = await http.post(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json", // Set content type as JSON
    },
    body: body,
  );
  print("Response Status Code: ${response.statusCode}");
  print("Response Body get_urls: ${response.body}");
  // Check if the response status is OK (200)
  if (response.statusCode == 200) { 
    Map<String, dynamic> responseData = jsonDecode(response.body);
    var urlData = responseData['data'];
    if (urlData is List) {    
      return urlData.map((data) => Url.fromJson(data)).toList();
    } else if (urlData == "No_Data") {
      return [];
    } else {
      throw Exception("Unexpected data format");
    }
  } else {
    throw Exception("Failed to fetch URL data");
  }
}



Future<List<Keyword>> fetchKeywords(String email, String orgSlug, String orgRoleId, String orgUserId, String orgUserorgId) async {
  var url = "$keywordUrl/api/get_keywords";  
  var body = jsonEncode({
    "email": email, // Email of the user
    "org_slug": orgSlug, // Organization slug
    "org_role_id": orgRoleId, // User's role ID in the organization
    "org_user_id": orgUserId, // User's ID in the organization
    "org_user_org_id": orgUserorgId // User's organization ID
  });

  final response = await http.post(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
    },
    body: body,
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> responseData = jsonDecode(response.body);
    var keywordData = responseData['data'];
    print("coming inside keywordData respone");
      print(keywordData);
    if (keywordData is List) {
      return keywordData.map((data) => Keyword.fromJson(data)).toList();
    } else if (keywordData == "No_Data") {
      return [];
    } else {
      throw Exception("Unexpected data format");
    }
  } else {
    print("coming else inside respone");    
    throw Exception("Failed to fetch keyword data");
  }
}

Future<List<Competitor>> fetchCompetitors(String email, String orgSlug, String orgRoleId, String orgUserId, String orgUserorgId) async {

  var url = "$CompetitorUrl/api/get_competitors";  
  var body = jsonEncode({
    "email": email, // Email of the user
    "org_slug": orgSlug, // Organization slug
    "org_role_id": orgRoleId, // User's role ID in the organization
    "org_user_id": orgUserId, // User's ID in the organization
    "org_user_org_id": orgUserorgId // User's organization ID
  });
  final response = await http.post(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
    },
    body: body,
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> responseData = jsonDecode(response.body);
    var competitorData = responseData['data'];
    print("inside response coming");
    print(competitorData);
    if (competitorData is List) {
      return competitorData.map((data) => Competitor.fromJson(data)).toList();
    } else if (competitorData == "No_Data") {
         print("inside response else if coming");
      return [];
    } else {
      throw Exception("Unexpected data format");
    }
  } else {
    throw Exception("Failed to fetch competitor data");
  }
}


Future<List<GuestModel>> fetchGuests(String email, String orgSlug, String orgRoleId, String orgUserId, String orgUserorgId) async {

  var url = "$baseUrl/api/get_guestpost";  
  var body = jsonEncode({
    "email": email, // Email of the user
    "org_slug": orgSlug, // Organization slug
    "org_role_id": orgRoleId, // User's role ID in the organization
    "org_user_id": orgUserId, // User's ID in the organization
    "org_user_org_id": orgUserorgId // User's organization ID
  });
  final response = await http.post(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
    },
    body: body,
  );
  if (response.statusCode == 200) {
    Map<String, dynamic> responseData = jsonDecode(response.body);
    var guestData = responseData['data'];
    print("inside response coming");
    print(guestData);
    if (guestData is List) {
      return guestData.map((data) => GuestModel.fromJson(data)).toList();
    } else if (guestData == "No_Data") {
         print("inside response else if coming");
      return [];
    } else {
      throw Exception("Unexpected data format");
    }
  } else {
    throw Exception("Failed to fetch competitor data");
  }
}

Future<List<EmailModel>> fetchEmails(String email, String orgSlug, String orgRoleId, String orgUserId, String orgUserorgId) async {

  var url = "$emailUrl/api/get_emails";  
  var body = jsonEncode({
    "email": email, // Email of the user
    "org_slug": orgSlug, // Organization slug
    "org_role_id": orgRoleId, // User's role ID in the organization
    "org_user_id": orgUserId, // User's ID in the organization
    "org_user_org_id": orgUserorgId // User's organization ID
  });
  final response = await http.post(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
    },
    body: body,
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> responseData = jsonDecode(response.body);
    var emailData = responseData['data'];
    print("inside response coming");
    print(emailData);
    if (emailData is List) {
      return emailData.map((data) => EmailModel.fromJson(data)).toList();
    } else if (emailData == "No_Data") {
         print("inside response else if coming");
      return [];
    } else {
      throw Exception("Unexpected data format");
    }
  } else {
    throw Exception("Failed to fetch competitor data");
  }
}

Future<List<PhoneModel>> fetchPhones(String email, String orgSlug, String orgRoleId, String orgUserId, String orgUserorgId) async {

  var url = "$phoneUrl/api/get_phones";  
  
  var body = jsonEncode({
    "email": email, // Email of the user
    "org_slug": orgSlug, // Organization slug
    "org_role_id": orgRoleId, // User's role ID in the organization
    "org_user_id": orgUserId, // User's ID in the organization
    "org_user_org_id": orgUserorgId // User's organization ID
  });
  final response = await http.post(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
    },
    body: body,
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> responseData = jsonDecode(response.body);
    var phoneData = responseData['data'];
    print("inside response coming");
    print(phoneData);
    if (phoneData is List) {
      return phoneData.map((data) => PhoneModel.fromJson(data)).toList();
    } else if (phoneData == "No_Data") {
         print("inside response else if coming");
      return [];
    } else {
      throw Exception("Unexpected data format");
    }
  } else {
    throw Exception("Failed to fetch competitor data");
  }
}

Future<List<WebassetsModel>> fetchWebassets(String email, String orgSlug, String orgRoleId, String orgUserId, String orgUserorgId) async {
  var url = "$webaccessUrl/api/web_assets";  

   print("inside fetchWebassets response coming");
    print(url);

  var body = jsonEncode({
    "email": email, // Email of the user
    "org_slug": orgSlug, // Organization slug
    "org_role_id": orgRoleId, // User's role ID in the organization
    "org_user_id": orgUserId, // User's ID in the organization
    "org_user_org_id": orgUserorgId // User's organization ID
  });
  final response = await http.post(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
    },
    body: body,
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> responseData = jsonDecode(response.body);
    var webassetsData = responseData['data'];
    print("inside response coming");
    print(webassetsData);
    if (webassetsData is List) {
      return webassetsData.map((data) => WebassetsModel.fromJson(data)).toList();
    } else if (webassetsData == "No_Data") {
         print("inside response else if coming");
      return [];
    } else {
      throw Exception("Unexpected data format");
    }
  } else {
    throw Exception("Failed to fetch competitor data");
  }
}




Future<List<WebTokenModel>> fetchWebtokens(String email, String orgSlug, String orgRoleId, String orgUserId, String orgUserorgId) async {
  var url = "$webaccessUrl/api/web_tokens";  

   print("inside fetchWebtokens response coming");
    print(url);

  var body = jsonEncode({
    "email": email, // Email of the user
    "org_slug": orgSlug, // Organization slug
    "org_role_id": orgRoleId, // User's role ID in the organization
    "org_user_id": orgUserId, // User's ID in the organization
    "org_user_org_id": orgUserorgId // User's organization ID
  });
  final response = await http.post(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
    },
    body: body,
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> responseData = jsonDecode(response.body);
    var webassetsData = responseData['data'];
    print("inside response coming");
    print(webassetsData);
    if (webassetsData is List) {
      return webassetsData.map((data) => WebTokenModel.fromJson(data)).toList();
    } else if (webassetsData == "No_Data") {
         print("inside response else if coming");
      return [];
    } else {
      throw Exception("Unexpected data format");
    }
  } else {
    throw Exception("Failed to fetch competitor data");
  }
}



 Future<http.Response> createWebAsset(Map<String, dynamic> requestData) async {
    var apiUrl = "$baseUrl/api/create_web_asset"; // Replace with your actual API endpoint
    var body = jsonEncode(requestData); // Convert requestData map to JSON
    print("Request URL createWebAsset: $apiUrl");
    print("Request Body createWebAsset: $body");
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    return response; // Return the response to be handled in the ViewModel
  }


Future<List<Rating>> fetchRatings(String email, String orgSlug, String orgRoleId, String orgUserId, String orgUserorgId) async {
  var url = "$RatingUrl/api/get_ratings";  
 var body = jsonEncode({
    "email": email, // Email of the user
    "org_slug": orgSlug, // Organization slug
    "org_role_id": orgRoleId, // User's role ID in the organization
    "org_user_id": orgUserId, // User's ID in the organization
    "org_user_org_id": orgUserorgId // User's organization ID
  });
  final response = await http.post(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
    },
    body: body,
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> responseData = jsonDecode(response.body);
    var ratingData = responseData['data'];

    if (ratingData is List) {
      return ratingData.map((data) => Rating.fromJson(data)).toList();
    } else if (ratingData == "No_Data") {
      return [];
    } else {
      throw Exception("Unexpected data format");
    }
  } else {
    throw Exception("Failed to fetch rating data");
  }
}

Future<List<WebRatings>> fetchWebratings(String email, String orgSlug, String orgRoleId, String orgUserId, String orgUserorgId) async {
print(webRatingUrl);
  var url = "$webRatingUrl/api/get_webratings";
  
 var body = jsonEncode({
    "email": email, // Email of the user
    "org_slug": orgSlug, // Organization slug
    "org_role_id": orgRoleId, // User's role ID in the organization
    "org_user_id": orgUserId, // User's ID in the organization
    "org_user_org_id": orgUserorgId // User's organization ID
  });

  final response = await http.post(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
    },
    body: body,
  );
 print(response.statusCode);
  if (response.statusCode == 200) {
    print("200 coming here");
    Map<String, dynamic> responseData = jsonDecode(response.body);
    var webRatingData = responseData['data'];
          print("coming here");
          print(webRatingData);
    if (webRatingData is List) {
      return webRatingData.map((data) => WebRatings.fromJson(data)).toList();
    } else if (webRatingData == "No_Data") {
      return [];
    } else {
      throw Exception("Unexpected data format");
    }
  } 
  else {
        print("200 else coming here");

    throw Exception("Failed to fetch web rating data");
  }
}

Future<List<PageRanking>> fetchPagerating(String email, String orgSlug, String orgRoleId, String orgUserId, String orgUserorgId) async {

  var url = "$pagerankUrl/api/get_pageranking";
  
  var body = jsonEncode({
    "email": email, // Email of the user
    "org_slug": orgSlug, // Organization slug
    "org_role_id": orgRoleId, // User's role ID in the organization
    "org_user_id": orgUserId, // User's ID in the organization
    "org_user_org_id": orgUserorgId // User's organization ID
  });

  final response = await http.post(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
    },
    body: body,
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> responseData = jsonDecode(response.body);
    var pageRankingData = responseData['data'];
print("pageRankingData coming");
print(pageRankingData);
    if (pageRankingData is List) {
      return pageRankingData.map((data) => PageRanking.fromJson(data)).toList();
    } else if (pageRankingData == "No_Data") {
      return [];
    } else {
      throw Exception("Unexpected data format");
    }
  } else {
    throw Exception("Failed to fetch page ranking data");
  }
}



Future<List<SocialRanking>> fetchSocailrating(String email, String orgSlug, String orgRoleId, String orgUserId, String orgUserorgId) async {
  var url = "$SocialRankUrl/api/get_socialranking";
 var body = jsonEncode({
    "email": email, // Email of the user
    "org_slug": orgSlug, // Organization slug
    "org_role_id": orgRoleId, // User's role ID in the organization
    "org_user_id": orgUserId, // User's ID in the organization
    "org_user_org_id": orgUserorgId // User's organization ID
  });
  final response = await http.post(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
    },
    body: body,
  );
  if (response.statusCode == 200) {
    Map<String, dynamic> responseData = jsonDecode(response.body);
    var socialRankingData = responseData['data'];

    if (socialRankingData is List) {
      return socialRankingData.map((data) => SocialRanking.fromJson(data)).toList();
    } else if (socialRankingData == "No_Data") {
      return [];
    } else {
      throw Exception("Unexpected data format");
    }
  } else {
    throw Exception("Failed to fetch social ranking data");
  }
}




Future<List<TaskBoard>> fetchTaskboard(String email, String orgSlug, String orgRoleId, String orgUserId, String orgUserorgId) async {
 
  var url = "$TaskUrl/api/get_taskboards";
  
 var body = jsonEncode({
    "email": email, // Email of the user
    "org_slug": orgSlug, // Organization slug
    "org_role_id": orgRoleId, // User's role ID in the organization
    "org_user_id": orgUserId, // User's ID in the organization
    "org_user_org_id": orgUserorgId // User's organization ID
  });

  final response = await http.post(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
    },
    body: body,
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> responseData = jsonDecode(response.body);
    var taskboardData = responseData['data'];

    if (taskboardData is List) {
      return taskboardData.map((data) => TaskBoard.fromJson(data)).toList();
    } else if (taskboardData == "No_Data") {
      return [];
    } else {
      throw Exception("Unexpected data format");
    }
  } else {
    throw Exception("Failed to fetch taskboard data");
  }
}




Future<TaskSummary> fetchtaskcount(String email, String orgSlug, String orgRoleId, String orgUserId, String orgUserorgId) async {
  var url = "$baseUrl/api/get_task_count";

  var body = jsonEncode({
    "email": email,
    "org_slug": orgSlug,
    "org_role_id": orgRoleId,
    "org_user_id": orgUserId,
    "org_user_org_id": orgUserorgId
  });

  final response = await http.post(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
    },
    body: body,
  );
 print("Response body fetchtaskcount: ${response.body}");
  if (response.statusCode == 200) {
    Map<String, dynamic> responseData = jsonDecode(response.body);

    // Directly parse the JSON object into a TaskSummary instance
    return TaskSummary.fromJson(responseData);
  } else {
    throw Exception("Failed to fetch task count data");
  }
}

Future<List<IntervalTask>> fetchIntervaltask(String email, String orgSlug, String orgRoleId, String orgUserId, String orgUserorgId) async {  
  var url = "$intervalTaskUrl/api/get_intervaltasks";  
 var body = jsonEncode({
    "email": email, // Email of the user
    "org_slug": orgSlug, // Organization slug
    "org_role_id": orgRoleId, // User's role ID in the organization
    "org_user_id": orgUserId, // User's ID in the organization
    "org_user_org_id": orgUserorgId // User's organization ID
  });

  final response = await http.post(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
    },
    body: body,
  );
  if (response.statusCode == 200) {
    Map<String, dynamic> responseData = jsonDecode(response.body);
    var intervalTaskData = responseData['data'];
    if (intervalTaskData is List) {
      return intervalTaskData.map((data) => IntervalTask.fromJson(data)).toList();
    } else if (intervalTaskData == "No_Data") {
      return [];
    } else {
      throw Exception("Unexpected data format");
    }
  } else {
    throw Exception("Failed to fetch interval task data");
  }
}


}