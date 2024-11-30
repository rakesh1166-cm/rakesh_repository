import 'dart:convert';
import 'dart:io';
// for getting the mime type of the file
import 'package:flutter/material.dart';
import 'package:wizbrand_influencer/model/mytask.dart';
import 'package:wizbrand_influencer/model/profile.dart';
import 'package:wizbrand_influencer/model/search_influencer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wizbrand_influencer/model/task.dart';
import 'package:wizbrand_influencer/Service/Influencer/influencer_service.dart';
import 'package:wizbrand_influencer/model/summary.dart';

class InfluencerViewModel extends ChangeNotifier {
  final InfluencerAPI api;
  List<SearchInfluencer> influencers = [];  
   Profile? fetchprofile;
  List<SearchInfluencer> becomeinfluencers = [];
  List<Profile> profiles = [];
   Map<String, String> socialData = {}; // To store parsed socialsite data
  List<Task> fetchtask = [];
   Map<String, dynamic>? socialPrices,socialUrls; 
    String? digitalMarketer;  
    String? socialCurrency;
    String? bio;  
     List<Mytask> fetchmytask = [];
   Map<String, dynamic>? pro_socialurls;
    Map<String, dynamic>? socialurls;

  TaskSummary? taskSummary;
  InfluencerViewModel(this.api);
  double? totalSum;
  double? gst;
  double? sumGst;
  List<String>? cartId;
  List<int>? influnceradminid;
  List<int>? proid;
  List<String>? influencername;
  List<String>? influenceremail;
  String? email;

  String? currency;
   bool _isLoading = false;
  String _message = '';

 bool get isLoading => _isLoading;
  String get message => _message;

  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }
  Future<void> fetchInfluencers(String email) async {
    isLoading = true;
    notifyListeners();
    try {
      influencers = await api.getinfluencer(email); // Pass email to the API call
      socialPrices = jsonDecode(becomeinfluencers.first.cartSocials ?? '{}');
     
      print("Data fetched successfully: ${influencers.length} items");
      print(socialPrices);
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
Future<void> fetchTask(String? email) async {
    isLoading = true;
    notifyListeners();
    try {
      taskSummary = await api.fetchTask(email);
      print("Tasks fetched successfully");
      print(taskSummary);
    } catch (e) {
      print("Error fetching tasks: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchfilterwallet(String? email) async {
    isLoading = true;
    notifyListeners();    
    print("Fetching task data for email: $email");
    try { 
    // await api.fetchTask(email);
       fetchtask = await api.fetchfilterWallet(email);
      print("Tasks fetched successfully");
      // Update your state if needed, e.g., update influencers list
    } catch (e) {
      print("Error fetching tasks: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

    Future<void> rejectTask(String orderId) async {
    _message = '';
    notifyListeners();
    try {
      final response = await api.rejectTask(orderId);
      print("Response Body: ${response.body}");
      if (response.statusCode == 200) {
        _message = 'Task rejected successfully';
      } else {
        _message = 'Failed to reject task';
      }
    } catch (e) {
      _message = 'Failed to reject task: $e';
    } finally {

      notifyListeners();
    }
  }
 Future<void> fetchInfluencersData(String? email) async {
    isLoading = true;
    notifyListeners();    
    print("Fetching fetchInfluencersData data for email: $email");
    try { 
      SearchInfluencer influencer = await api.influencerData(email);
      becomeinfluencers = [influencer];
      socialPrices = jsonDecode(becomeinfluencers.first.socialPrice ?? '{}');
      socialurls = jsonDecode(becomeinfluencers.first.socialSite ?? '{}');
        print("comingsocialurls");
       print(socialurls);
      digitalMarketer = becomeinfluencers.first.digitalMarketer;
      bio = becomeinfluencers.first.bio;
      socialCurrency = becomeinfluencers.first.socialCurrency;      
      print(becomeinfluencers);
     
      print(socialCurrency);      
      print("Tasks fetched successfully");
    } catch (e) {
      print("Error fetching tasks: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
Future<void> fetchInfluencerData(String cartId, String influencerAdminId) async {
  isLoading = true;
  notifyListeners();
  try {
    final cartsocial = await api.getInfluencerData(cartId, influencerAdminId);
    if (cartsocial.isNotEmpty) {
      // Parse the socialsite JSON for the first item (assuming single item)
      final socialsiteJson = jsonDecode(cartsocial.first.socialsite) as Map<String, dynamic>;

      // Convert the JSON to a Map<String, String>
      socialData = socialsiteJson.map((key, value) => MapEntry(key.toString(), value.toString()));

      print("Parsed Social Site Data: $socialData");
    }
  } catch (e) {
    print("Error fetching data: $e");
  } finally {
    isLoading = false;
    notifyListeners();
  }
}
Future<void> uploadProfileImage(File imageFile, String email) async {
  try {
    final response = await api.uploadProfileImage(imageFile, email);
    print('Profile image uploaded successfully');
    // Optionally, you can refresh the profile after successful upload
    await fetchProfiles(email);
  } catch (e) {
    print('Error uploading profile image: $e');
  } finally {
    notifyListeners();
  }
}


   Future<void> registerUser(String name, String email, bool rememberMe) async {
    try {
      // Call your API or authentication service to register the user
      final response = await api.registerUser(name, email, rememberMe);
      notifyListeners(); 
    } catch (e) {
      // Handle exception
      print("Error registering user: $e");
    }
  }


  Future<void> fetchOrder(String? email) async {
    isLoading = true;
    notifyListeners();
    try {
      taskSummary = await api.fetchOrder(email);
      print("taskSummary fetched successfully");
      print(taskSummary);
    } catch (e) {
      print("Error fetching tasks: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchfilterTask(String? email) async {
    isLoading = true;
    notifyListeners();
    print("Fetching task data for email: $email");
    try {
      // await api.fetchTask(email);
      fetchtask = await api.fetchfilterTask(email);
      print("Tasks fetched successfully");
      // Update your state if needed, e.g., update influencers list
    } catch (e) {
      print("Error fetching tasks: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
Future<void> fetchProfiles(String? email) async {
  if (email == null || email.isEmpty) {
    print("Error: Email is null or empty");
    return;
  }

  isLoading = true;
  notifyListeners();
  print("Fetching fetchprofile for email: $email");
  try {
    fetchprofile = await api.fetchprofile(email);
 print(fetchprofile);

 Profile myprofiles = await api.fetchprofile(email);
      profiles = [myprofiles];
      socialPrices = jsonDecode(profiles.first.socialPrice ?? '{}');
     socialUrls = jsonDecode(profiles.first.socialSite ?? '{}');

     
 print(socialPrices);

    print("Orders fetched successfully");
  } catch (e) {
    print("Error fetching orders: $e");
  } finally {
    isLoading = false;
    notifyListeners();
  }
}
  
 Future<void> updatePassword(String email, String newPassword, String confirmPassword) async {
  // Check if the password is at least 7 characters long
  if (newPassword.length < 7) {
    throw Exception('Password must be at least 7 characters long');
  }
  if (confirmPassword.length < 7) {
    throw Exception('Password must be at least 7 characters long');
  }

  // Check if the passwords match
  if (newPassword != confirmPassword) {
    throw Exception('Passwords do not match');
  }

  try {
    // Send password update request
    await api.updatePassword(email, newPassword);
    print('Password updated successfully');

    // Handle UI feedback (e.g., show a success message)
  } catch (e) {
    print('Error updating password: $e');
    throw Exception('Failed to update password');
  }
}
   List<Mytask> getTasksByStatus(String status, String email) {          
          print('Filtering tasks for status: $status and email: $email');  
          print('Total tasks fetched: ${fetchmytask.length}');  
          fetchmytask.forEach((task) {
            print('Task Email: ${task.adminEmail}, Task Status: ${task.status}, Task: ');
          });
          List<Mytask> filteredTasks = fetchmytask.where((task) => task.status == status && task.influencerEmail == email).toList();
          print('Filtered tasks count: ${filteredTasks.length}');
          return filteredTasks;
        }
     Future<void> updateTaskStatus(int taskId, String status, String email, {String? workUrl, String? description}) async {
    try {
      await api.updateTaskStatus(taskId, status, email, workUrl: workUrl, description: description);
      print("Task status updated successfully");
      await fetchTasks(email); // Fetch the updated list of tasks
      notifyListeners(); // Notify listeners after updating the task status
    } catch (e) {
      print("Error updating task status: $e");
    }
  }
  
Future<void> fetchTasks(String? email) async {
  if (email == null || email.isEmpty) {
    print("Error: Email is null or empty");
    return;
  }
  isLoading = true;
  notifyListeners();
  print("Fetching orders for email: $email");
  try {
    fetchmytask = await  api.fetchmyTask(email);
    print("Orders fetched successfully");
     print(fetchmytask);
  } catch (e) {
    print("Error fetching orders: $e");
  } finally {
    isLoading = false;
    notifyListeners();
  }
}


  Future<void> updateInfluencerSelection(String influencerId, String socialKey,
      bool isSelected, String email) async {
    try {
      await api.updateInfluencerSelection(
          influencerId, socialKey, isSelected, email);
      print("Selection updated successfully");
      await fetchInfluencers(email); // Fetch the updated list of influencers
      notifyListeners(); // Notify listeners after updating the selection
    } catch (e) {
      print("Error updating selection: $e");
    }
  }
Future<void> updateTaskWithDetails(int productId, int orderId, String taskTitle, String description, String videoLink, List<String> imageLinks) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await api.updateTaskWithDetails(
        productId: productId,
        orderId: orderId,
        taskTitle: taskTitle,
        description: description,
        videoLink: videoLink,
        imageLinks: imageLinks,
      );

      if (response.statusCode == 200) {
        print("Task updated successfully");
      } else {
        print("Failed to update task");
      }
    } catch (e) {
      print("Error updating task: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  

  Future<Map<String, dynamic>> updateTask(int productId, String orderId) async {
    _isLoading = true;
    _message = '';
    notifyListeners();
    try {
      final response = await api.updateTask(productId, orderId);
      print("Response Body: ${response.body}");
      if (response.statusCode == 200) {
        // Handle success response
        _message = 'Task updated successfully';
        return jsonDecode(response.body);
      } else {
        // Handle error response
        _message = 'Failed to update task';
        return {};
      }
    } catch (e) {
      _message = 'Failed to update task: $e';
      return {};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> lockTask(String orderId, int productId) async {
    _isLoading = true;
    _message = '';
    notifyListeners();
    try {
      final response = await api.lockTask(orderId, productId);
      print("Response Body: ${response.body}");
      if (response.statusCode == 200) {
        // Handle success response
        _message = 'Task locked successfully';
      } else {
        // Handle error response
        _message = 'Failed to lock task';
      }
    } catch (e) {
      _message = 'Failed to lock task: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  
Future<void> modifyTask(String orderId, String description) async {
  _isLoading = true;
  notifyListeners();
  try {
    final response = await api.modifyTask(orderId, description);
    if (response.statusCode == 200) {
      print("Task modified successfully");
    } else {
      print("Failed to modify task");
    }
  } catch (e) {
    print("Error modifying task: $e");
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  Future<void> approveTask(String orderId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await api.approveTask(orderId);
      if (response.statusCode == 200) {
        print("Task approved successfully");
      } else {
        print("Failed to approve task");
      }
    } catch (e) {
      print("Error approving task: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  IconData getSocialIcon(String key) {
    switch (key.toLowerCase()) {
      case 'facebook':
        return FontAwesomeIcons.facebook;
      case 'twitter':
        return FontAwesomeIcons.twitter;
      case 'instagram':
        return FontAwesomeIcons.instagram;
      case 'youtube':
        return FontAwesomeIcons.youtube;
      case 'wordpress':
        return FontAwesomeIcons.wordpress;
      case 'tumblr':
        return FontAwesomeIcons.tumblr;
      case 'pinterest':
        return FontAwesomeIcons.pinterest;
      case 'quora':
        return FontAwesomeIcons.quora;
      case 'reddit':
        return FontAwesomeIcons.reddit;
      case 'telegram':
        return FontAwesomeIcons.telegram;
      case 'linkedin':
        return FontAwesomeIcons.linkedin;
      default:
        return FontAwesomeIcons.globe;
    }
  }

  Color getSocialIconColor(String key) {
    switch (key.toLowerCase()) {
      case 'facebook':
        return Color(0xFF3b5998); // Facebook blue
      case 'twitter':
        return Color(0xFF1DA1F2); // Twitter blue
      case 'instagram':
        return Color(0xFFE1306C); // Instagram pink
      case 'youtube':
        return Color(0xFFc4302b); // YouTube red
      case 'wordpress':
        return Color(0xFF21759B); // WordPress blue
      case 'tumblr':
        return Color(0xFF35465C); // Tumblr blue
      case 'pinterest':
        return Color(0xFFBD081C); // Pinterest red
      case 'quora':
        return Color(0xFFB92B27); // Quora red
      case 'reddit':
        return Color(0xFFFF4500); // Reddit orange
      case 'telegram':
        return Color(0xFF0088cc); // Telegram blue
      case 'linkedin':
        return Color(0xFF0077B5); // LinkedIn blue
      default:
        return Colors.grey; // Default color
    }
  }
}
