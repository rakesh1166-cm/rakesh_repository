import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wizbrand/Service/Influencer/get_service.dart';
import 'package:wizbrand/model/projectmodel.dart';
import 'package:wizbrand/model/userorganization.dart';


class GetViewModel extends ChangeNotifier {
  final GetService api; // Dependency injection for the API service
  List<UserOrganization> get_project = []; // List to hold fetched data
  List<Project> fetchedData = []; // List to hold fetched data  
  String _message = '';
  bool _isLoading = false;
  String get message => _message;
  bool get isLoading => _isLoading;  
  GetViewModel(this.api); 
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }


  Future<void> fetchProjects(String email, String orgSlug) async {
    isLoading = true;
    notifyListeners();
    try {
      get_project = await api.getprojectmgr(email,orgSlug);
     // print("Fetched countries: ${get_project.map((c) => c.country_name).toList()}");
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  // Example method to fetch data from an API
  Future<void> fetchData(String param) async {
    if (param.isEmpty) {
      _message = 'Error: parameter is empty';
      notifyListeners();
      return;
    }
    _isLoading = true;
    notifyListeners();
    try {
      // Make the API call using the service
      fetchedData = await api.getData(param);

      print("Fetched data: ${fetchedData.length}");
    } catch (e) {
      print("Error fetching data: $e");
      _message = 'Error fetching data: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Example of posting data to the API
  Future<Map<String, dynamic>> postData(Map<String, dynamic> payload) async {
    isLoading = true;
    notifyListeners();

    try {
      // Send payload to the API using the service
      final response = await api.postData(payload);

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Data posted successfully'};
      } else {
        final responseData = jsonDecode(response.body);
        return {'success': false, 'message': responseData['message'] ?? 'Failed to post data'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Example of updating data
  Future<void> updateData(String id, Map<String, dynamic> updatedFields) async {
    _isLoading = true;
    notifyListeners();
    try {
      // Call the API service to update data
      final response = await api.updateData(id, updatedFields);
      if (response.statusCode == 200) {
        // Successfully updated, refresh data
        fetchData('');
      } else {
        print("Failed to update data");
      }
    } catch (e) {
      print("Error updating data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Example of deleting data
  Future<void> deleteData(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Call the API service to delete data
      final response = await api.deleteData(id);

      if (response.statusCode == 200) {
        // Successfully deleted, refresh data
        fetchData('');
      } else {
        print("Failed to delete data");
      }
    } catch (e) {
      print("Error deleting data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // You can add more functions here like fetch specific items, update, etc.
}