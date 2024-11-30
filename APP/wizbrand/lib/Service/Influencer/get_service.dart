import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wizbrand/model/projectmodel.dart';
import 'package:wizbrand/model/userorganization.dart';

class GetService {
  final String baseUrl = "https://www.wizbrand.com";
    final String probaseUrl = "https://www.wizbrand.com/wz-projects-ms";
  final String orgbaseUrl = "https://www.wizbrand.com/wz-organisation-ms";
  // Example function to fetch data


  Future<List<Project>> getData(String param) async {
    final response = await http.get(Uri.parse('$baseUrl/data/$param'));
    if (response.statusCode == 200) {
      List jsonData = jsonDecode(response.body);
      return jsonData.map((item) => Project.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }



  // Example function to post data
  Future<http.Response> postData(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse('$baseUrl/data'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    return response;
  }
  Future<List<UserOrganization>> getprojectmgr(String email, String orgSlug) async {
    var url = "$orgbaseUrl/api/getprojectmgr/"; // Update with the correct endpoint
    // Create the request body with parameters
    var body = jsonEncode({
      "email": email,
      "orgSlug": orgSlug
    });
    // Send the POST request
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    // Check the response status and handle accordingly
    if (response.statusCode == 200) {
      // Decode the response body
      List<dynamic> body = jsonDecode(response.body);

      // Convert JSON to a list of Project objects
      return body.map((project) => UserOrganization.fromJson(project)).toList();
    } else {
      // Throw an exception if the request failed
      throw Exception("Failed to fetch project data");
    }
  }

  // Example function to update data
  Future<http.Response> updateData(String id, Map<String, dynamic> updatedFields) async {
    final response = await http.put(
      Uri.parse('$baseUrl/data/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedFields),
    );

    return response;
  }

  // Example function to delete data
  Future<http.Response> deleteData(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/data/$id'),
    );

    return response;
  }
}