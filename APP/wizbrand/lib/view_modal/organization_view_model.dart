import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wizbrand/Screen/Influencer/createwebasset.dart';
import 'package:wizbrand/Screen/Influencer/notfound.dart';
import 'package:wizbrand/Screen/Influencer/successmsg.dart';
import 'package:wizbrand/model/cart.dart';
import 'package:wizbrand/model/competitor.dart';
import 'package:wizbrand/model/currencyupdate.dart';
import 'package:wizbrand/model/email.dart';
import 'package:wizbrand/model/guest.dart';
import 'package:wizbrand/model/influencerwork.dart';
import 'package:wizbrand/model/interval_task.dart';
import 'package:wizbrand/model/keyword.dart';
import 'package:wizbrand/model/order.dart';
import 'package:wizbrand/model/organization.dart';
import 'package:wizbrand/model/page.dart';
import 'package:wizbrand/model/phone.dart';
import 'package:wizbrand/model/profile.dart';
import 'package:wizbrand/model/projectmodel.dart';
import 'package:wizbrand/model/rating.dart';
import 'package:wizbrand/model/search_influencer.dart';
import 'package:wizbrand/model/socialrank.dart';
import 'package:wizbrand/model/taskboard.dart';
import 'package:wizbrand/model/url.dart';
import 'package:wizbrand/model/userorganization.dart';
import 'package:wizbrand/model/webassets.dart';
import 'package:wizbrand/model/webrating.dart';
import 'package:wizbrand/model/webtokens.dart';
import '../model/task.dart';
import '../Service/Influencer/organization_service.dart';
import '../../model/summary.dart';
import 'dart:math';

class OrganizationViewModel extends ChangeNotifier {
  final OrganizationAPI api;
  List<Organization> organizations = [];
   List<UserOrganization> userorganizations = [];
   List<Organization> filtereduserOrganizations = [];   
   List<UserOrganization> my_org = [];
  List<Organization> users = [];
  List<Project> my_projects = [];
  List<Url> my_urls = [];
  List<Keyword> my_keywords = [];
  List<Competitor> my_competitors = [];
  List<EmailModel> my_emails = [];
  List<PhoneModel> my_phones = [];
  List<WebassetsModel> my_webassets = [];
   List<WebTokenModel> my_tokens = [];  
  List<GuestModel> my_guests = [];
  List<Rating> my_team = [];
  TaskSummary? my_task_count;
  List<WebRatings> my_website = [];
 List<PageRanking> my_page = [];
 List<SocialRanking> my_social = [];
 List<TaskBoard> my_taskboard = [];
 List<IntervalTask> my_intervaltask = [];
List<IntervalTask> my_intervaltaskfilter = [];
 

  String _message = '';

  String get message => _message;
    List<Order> orders = [];
   List<InfluncerWork> fetchwork = [];
    Profile? fetchprofile;
  List<SearchInfluencer> becomeinfluencers = [];
  List<Profile> profiles = [];
  List<Task> fetchtask = [];
  Map<String, dynamic>? socialPrices,socialUrls;
  List<UserCart> fetchcart = [];
  List<UserCart> removecart = [];
  TaskSummary? taskSummary;
  OrganizationViewModel(this.api);
  double? totalSum;
  double? gst;
  double? sumGst;
  List<String>? cartId;
    List<String>? file_pic;
  List<int>? influnceradminid;
  List<int>? proid;
  List<String>? influencername;
  List<String>? influenceremail;
  String? email;
  List<CartDetail>? cartDetail;
  String? currency;
   bool _isLoading = false;


 bool get isLoading => _isLoading;


  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
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
  Future<Map<String, dynamic>> updateOrganization(String email, String id, String newName) async {
  try {
    // Set the loading state to true
    isLoading = true;
    notifyListeners();

    // Call the API to update the organization
    final response = await api.updateOrganization(email, id, newName);

    if (response.statusCode == 200) {
      // Handle the success case
      return {
        'success': true,
        'message': 'Organization updated successfully.',
      };
    } else {
      // Parse the error message from the response if available
      final responseData = jsonDecode(response.body);
      return {
        'success': false,
        'message': responseData['message'] ?? 'Failed to update organization.',
      };
    }
  } catch (e) {
    // Handle any other errors
    return {
      'success': false,
      'message': 'An error occurred: ${e.toString()}',
    };
  } finally {
    // Set the loading state to false
    isLoading = false;
    notifyListeners();
  }
}
      
  Future<Map<String, dynamic>> saveOrganization(BuildContext context,String email, String organizationName) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await api.saveOrganization(email, organizationName);

      if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);

    if (responseData['success'] == true) {
      showDialog(
        context: context,
        builder: (context) => SuccessMsg(message: 'Organization created successfully.'),
      );
      return {'success': true, 'message': 'Project deleted successfully'};
    } else {
      print('Failed to delete project: ${responseData['message']}');
      // Use the context passed as an argument
        showDialog(
        context: context,
        builder: (context) => SuccessMsg(message: 'Organization cannot create alraedy exist.'),
      );
            return {'success': false, 'message': responseData['message']};
          }
      } else {
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to save organization.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    } finally {
      isLoading = false;
      notifyListeners();
    }
  } 

   Future<void> getOrganizationData(String? email) async {
          isLoading = true;
          notifyListeners();
          print("Fetching organization data for email: $email");
          try {             // Fetch all organizations
            organizations = await api.organizationData();
            // Filter organizations where orgUserEmail matches the provided email
            var filteredOrganizations = organizations.where((org) => org.orgUserEmail == email).toList();
            // Print the filtered organizations
            print(filteredOrganizations);
            print("Filtered organizations fetched successfully");
          } catch (e) {
            print("Error fetching organizations: $e");
          } finally {
            isLoading = false;
            notifyListeners();
          }
        }
Future<void> getuserOrganizationData(String? email) async {
  isLoading = true;
  notifyListeners();
  print("Fetching getuserOrganizationData data for email: $email");
  try {
    // Fetch organizations by email from the backend
    final List<Organization> response = await api.userorganizationData(email: email);   
    // Filtered organizations come from the backend directly
    filtereduserOrganizations = response;    
    // Print the filtered organizations
    print("Filtered getuserOrganizationData fetched successfully");
    print(filtereduserOrganizations);

    // Print the total number of records
    print("Total records: ${filtereduserOrganizations.length}");
  } catch (e) {
    print("Error fetching organizations: $e");
  } finally {
    isLoading = false;
    notifyListeners();
  }
}

Future<void> getUserFunction(String email, String orgSlug) async {
  if (email.isEmpty || orgSlug.isEmpty) {
    print("Error: email or orgSlug is empty");
    return;
  }
  isLoading = true;
  notifyListeners();
  try {  
    print("Fetching data for email: $email and orgSlug: $orgSlug");
    List<UserOrganization> fetchedUserOrganizations = await api.getUserData(email, orgSlug);
    my_org = fetchedUserOrganizations;    
    // Sort the projects in descending order by 'id'.
    fetchedUserOrganizations.sort((a, b) => b.id.compareTo(a.id));

     print(my_org);
    print("Fetched organizations: ${my_org.length}");
  } catch (e) {
    print("Error fetching user data: $e");
    _message = 'Error fetching user data: $e';
  } finally {
    isLoading = false;
    notifyListeners();  // Ensure UI rebuilds after fetching data
  }
}






 Future<Map<String, dynamic>> inviteUser(
    String? loggedInUserEmail, // logged-in user's email
    String inviteeEmail, // email of the user to invite
    String role,
    String orgSlug,
    String orgRoleId,
    String orgUserId,
    String orgUserorgId,    
     // role to assign
  ) async {
    if (loggedInUserEmail == null || loggedInUserEmail.isEmpty) {
      return {
        'success': false,
        'message': 'Logged-in user email is required',
      };
    }

    if (inviteeEmail.isEmpty) {
      return {
        'success': false,
        'message': 'Invitee email is required',
      };
    }

    isLoading = true;
    notifyListeners();

    try {
      // Make the API call to invite a user
      final response = await api.inviteUser(
        loggedInUserEmail, // email of the user inviting (logged-in user)
        inviteeEmail, // email of the user being invited
        role,
        orgSlug,
        orgRoleId,
        orgUserId,
        orgUserorgId// the role to assign
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'User invited successfully',
        };
      } else {
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to invite user',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

Future<Map<String, dynamic>> blockOrganization({
    required String? loggedEmail, // logged-in user's email
    required String email, // email of the user to invite
    required String role, // role to assign
    required String orgSlug, // orgSlug
  }) async {
    if (loggedEmail == null || loggedEmail.isEmpty) {
      return {
        'success': false,
        'message': 'Logged-in user email is required',
      };
    }

    if (email.isEmpty) {
      return {
        'success': false,
        'message': 'Invitee email is required',
      };
    }

    isLoading = true;
    notifyListeners();

    try {
      // Make the API call to invite a user
      final response = await api.blockUser(
        loggedEmail, // email of the user inviting (logged-in user)
        email, // email of the user being invited
        role, // the role to assign
        orgSlug, // the organization slug
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'User blocked successfully',
        };
      } else {
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to block user',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
 

    Future<Map<String, dynamic>> createProject(
    String? loggedInUserEmail, // Email of the logged-in user
    String projectName, // Project name
    String projectUrl, // Project URL
    String? managerEmail, // Selected manager's email
    String orgSlug, // Organization slug
    String orgRoleId, // Organization slug
    String orgUserId, // Organization slug
    String orgUserorgId, // Organization slug
  ) async {
    if (loggedInUserEmail == null || loggedInUserEmail.isEmpty) {
      return {
        'success': false,
        'message': 'Logged-in user email is required',
      };
    }

    if (projectName.isEmpty) {
      return {
        'success': false,
        'message': 'Project name is required',
      };
    }

    if (projectUrl.isEmpty) {
      return {
        'success': false,
        'message': 'Project URL is required',
      };
    }

    if (managerEmail == null || managerEmail.isEmpty) {
      return {
        'success': false,
        'message': 'Manager email is required',
      };
    }

    isLoading = true;
    notifyListeners();

    try {
      // Make the API call to create a project
      final response = await api.createProject(
      loggedInUserEmail, // Email of the user creating the project
       projectName, // Project name
       projectUrl, // Project URL
       managerEmail, // Manager email
       orgSlug, // Organization slug
       orgRoleId, // Organization slug
       orgUserId, // Organization slug
       orgUserorgId, // Organization slug
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Project created successfully',
        };
      } else {
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to create project',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

Future<Map<String, dynamic>> updateProject(
  String? loggedInUserEmail, // Email of the logged-in user
  String projectName, // Project name
  String projectUrl, // Project URL
  String? managerEmail, // Selected manager's email
  String orgSlug, // Organization slug
  String projectId, // Project ID for updating
  String orgRoleId, // Organization role ID
  String orgUserId, // Organization user ID
  String orgUserorgId, // Organization user organization ID
) async {
  if (loggedInUserEmail == null || loggedInUserEmail.isEmpty) {
    return {
      'success': false,
      'message': 'Logged-in user email is required',
    };
  }

  if (projectName.isEmpty) {
    return {
      'success': false,
      'message': 'Project name is required',
    };
  }

  if (projectUrl.isEmpty) {
    return {
      'success': false,
      'message': 'Project URL is required',
    };
  }

  if (managerEmail == null || managerEmail.isEmpty) {
    return {
      'success': false,
      'message': 'Manager email is required',
    };
  }

  isLoading = true;
  notifyListeners();

  try {
    // Make the API call to update the project
    final response = await api.updateProject(
      loggedInUserEmail, // Email of the user updating the project
      projectName, // Project name
      projectUrl, // Project URL
      managerEmail, // Manager email
      orgSlug, // Organization slug
      projectId, // Project ID for updating
      orgRoleId, // Organization role ID
      orgUserId, // Organization user ID
      orgUserorgId, // Organization user organization ID
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      // Check if the API response also contains success as true
      if (responseData['success'] == true) {
        return {
          'success': true,
          'message': 'Project updated successfully',
        };
      } else {
        // If success is false, return the message from the response
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to update project',
        };
      }
    } else {
      // Handle cases where status code is not 200
      final responseData = jsonDecode(response.body);
      return {
        'success': false,
        'message': responseData['message'] ?? 'Failed to update project',
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'An error occurred: ${e.toString()}',
    };
  } finally {
    isLoading = false;
    notifyListeners();
  }
}

Future<Map<String, dynamic>> deleteProject(BuildContext context, int projectId, String orgSlug) async {
  final response = await api.deleteProject(projectId, orgSlug);

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);

    if (responseData['success'] == true) {
      print('Project deleted successfully');
      return {'success': true, 'message': 'Project deleted successfully'};
    } else {
      print('Failed to delete project: ${responseData['message']}');
      // Use the context passed as an argument
  showDialog(
  context: context,
  builder: (context) => SuccessMsg(message: 'Project cannot be deleted as it is already in use.'),
);
      return {'success': false, 'message': responseData['message']};
    }
  } else {
    print('Failed to delete project. Status code: ${response.statusCode}');
    return {'success': false, 'message': 'Failed to delete project'};
  }
}


  Future<void> deleteEmail(int emailId, String orgSlug) async {
  isLoading = true;
  notifyListeners();

  try {
    // Make API call to delete the project
    final response = await api.deleteEmail(emailId, orgSlug);

    if (response.statusCode == 200) {
      print('Project deleted successfully');
    } else {
      final responseData = jsonDecode(response.body);
      print('Failed to delete project: ${responseData['message']}');
    }
  } catch (e) {
    print('Error deleting project: $e');
  } finally {
    isLoading = false;
    notifyListeners();
  }
}




  Future<void> deletePhone(int phoneId, String orgSlug) async {
  isLoading = true;
  notifyListeners();

  try {
    // Make API call to delete the project
    final response = await api.deletePhone(phoneId, orgSlug);

    if (response.statusCode == 200) {
      print('Project deleted successfully');
    } else {
      final responseData = jsonDecode(response.body);
      print('Failed to delete project: ${responseData['message']}');
    }
  } catch (e) {
    print('Error deleting project: $e');
  } finally {
    isLoading = false;
    notifyListeners();
  }
}


 Future<void> deleteGuest(int guest, String orgSlug) async {
  isLoading = true;
  notifyListeners();

  try {
    // Make API call to delete the project
    final response = await api.deleteGuest(guest, orgSlug);

    if (response.statusCode == 200) {
      print('Project deleted successfully');
    } else {
      final responseData = jsonDecode(response.body);
      print('Failed to delete project: ${responseData['message']}');
    }
  } catch (e) {
    print('Error deleting project: $e');
  } finally {
    isLoading = false;
    notifyListeners();
  }
}


Future<void> deleteAsset(String Webid) async {
  isLoading = true;
  notifyListeners();

  try {
    // Make API call to delete the project
    final response = await api.deleteasset(Webid);
    if (response.statusCode == 200) {
      print('Project deleted successfully');
    } else {
      final responseData = jsonDecode(response.body);
      print('Failed to delete project: ${responseData['message']}');
    }
  } catch (e) {
    print('Error deleting project: $e');
  } finally {
    isLoading = false;
    notifyListeners();
  }
}


Future<void> deleteKey(String Keyid) async {
  isLoading = true;
  notifyListeners();
  try {
    // Make API call to delete the project
    final response = await api.deleteKey(Keyid);
    if (response.statusCode == 200) {
      print('assets deleted successfully');
    } else {
      final responseData = jsonDecode(response.body);
      print('Failed to delete project: ${responseData['message']}');
    }
  } catch (e) {
    print('Error deleting project: $e');
  } finally {
    isLoading = false;
    notifyListeners();
  }
}



Future<void> deleteWeb(String Webid) async {
  isLoading = true;
  notifyListeners();

  try {
    // Make API call to delete the project
    final response = await api.deleteWeb(Webid);
    if (response.statusCode == 200) {
      print('Project deleted successfully');
    } else {
      final responseData = jsonDecode(response.body);
      print('Failed to delete project: ${responseData['message']}');
    }
  } catch (e) {
    print('Error deleting project: $e');
  } finally {
    isLoading = false;
    notifyListeners();
  }
}


Future<void> deletePageRank(String Pageid) async {
  isLoading = true;
  notifyListeners();

  try {
    // Make API call to delete the project
    final response = await api.deletePage(Pageid);
    if (response.statusCode == 200) {
      print('Project deleted successfully');
    } else {
      final responseData = jsonDecode(response.body);
      print('Failed to delete project: ${responseData['message']}');
    }
  } catch (e) {
    print('Error deleting project: $e');
  } finally {
    isLoading = false;
    notifyListeners();
  }
}


 Future<Map<String, dynamic>> deleteUrl(String urlId) async {
    isLoading = true;
    notifyListeners();

    try {
      // Call the deleteUrl function from the ApiService
      final response = await api.deleteUrl(urlId);

      // Decode the response body
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'URL deleted successfully',
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to delete URL',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }



   Future<Map<String, dynamic>> deleteCompetitor(String competitorid) async {
    isLoading = true;
    notifyListeners();

    try {
      // Call the deleteUrl function from the ApiService
      final response = await api.deleteCompetitor(competitorid);

      // Decode the response body
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'URL deleted successfully',
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to delete URL',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }



  Future<Map<String, dynamic>> deleteRating(String ratingid) async {
    isLoading = true;
    notifyListeners();
    try {
      // Call the deleteUrl function from the ApiService
      final response = await api.deleteRating(ratingid);
      // Decode the response body
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'URL deleted successfully',
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to delete URL',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }



 Future<Map<String, dynamic>> deleteTask(String taskid) async {
    isLoading = true;
    notifyListeners();
    try {
      // Call the deleteUrl function from the ApiService
      final response = await api.deleteTask(taskid);
      // Decode the response body
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'URL deleted successfully',
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to delete URL',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }



 Future<Map<String, dynamic>> deleteIntervaltask(String taskid) async {
    isLoading = true;
    notifyListeners();
    try {
      // Call the deleteUrl function from the ApiService
      final response = await api.deleteIntervaltask(taskid);
      // Decode the response body
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'URL deleted successfully',
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to delete URL',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  

Future<Map<String, dynamic>> deleteKeyword(BuildContext context,String urlId) async {
  final response = await api.deleteKeyword(urlId);   

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);

    if (responseData['success'] == true) {
      print('Keyword deleted successfully');
      return {'success': true, 'message': 'Keyword deleted successfully'};
    } else {
      print('Failed to delete Keyword: ${responseData['message']}');
      // Use the context passed as an argument
  showDialog(
  context: context,
  builder: (context) => SuccessMsg(message: 'Keyword cannot be deleted as it is already in use.'),
);
      return {'success': false, 'message': responseData['message']};
    }
  } else {
    print('Failed to delete Keyword. Status code: ${response.statusCode}');
    return {'success': false, 'message': 'Failed to delete Keyword'};
  }
}
Future<Map<String, dynamic>> updateKeyword(
  String keywordId, // Keyword ID for updating
  String loggedInUserEmail,
  String projectId,
  String urlId,
  List<String> keywords,
  String orgSlug,
  String orgRoleId,
  String orgUserId,
  String orgUserorgId,
  String projectName,
  String urlName,
) async {
  isLoading = true;
  notifyListeners();

  try {
    // Prepare request body for the API call
    final requestBody = {
      'email': loggedInUserEmail,
      'project_id': projectId,
      'url_id': urlId,
      'keywords': keywords, // List of keywords to update
      'org_slug': orgSlug,
      'org_role_id': orgRoleId,
      'org_user_id': orgUserId,
      'org_user_org_id': orgUserorgId,
      'project_name': projectName,
      'url_name': urlName,
    };

    // Call the `updateKeyword` function from the ApiService
    final response = await api.updateKeyword(keywordId, requestBody);

    // Parse the response from the server
    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {
        'success': true,
        'message': 'Keyword updated successfully',
      };
    } else {
      return {
        'success': false,
        'message': responseData['message'] ?? 'Failed to update keyword',
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'An error occurred: $e',
    };
  } finally {
    isLoading = false;
    notifyListeners();
  }
}


 Future<Map<String, dynamic>> updateCompetitorUrl(
    String loggedInUserEmail, // Email of the logged-in user
    String competitorId, // Competitor ID for updating
    String projectId,
    String projectName,
    String name,
    String website,
    String facebook,
    String twitter,
    String instagram,
    String youtube,
    String linkedin,
    String pinterest,
    String reddit,
    String tiktok,
      String orgSlug,              // Organization slug
  String orgRoleId,            // Organization role ID
  String orgUserId,            // Organization user ID
  String orgUserorgId
  ) async {
    isLoading = true;
    notifyListeners();

    try {
      // Prepare request body for the API call
      final requestBody = {
        'email': loggedInUserEmail,
        'project_id': projectId,
        'project_name': projectName,
        'name': name,
        'website': website,
        'facebook': facebook,
        'twitter': twitter,
        'instagram': instagram,
        'youtube': youtube,
        'linkedin': linkedin,
        'pinterest': pinterest,
        'reddit': reddit,
        'tiktok': tiktok,
          "org_slug": orgSlug,
      "org_roleid": orgRoleId,
      "org_userid": orgUserId,
      "org_userorgid": orgUserorgId,
      };

      // Call the `updateCompetitorUrl` function from the ApiService
      final response =  await api.updateCompetitorUrl(competitorId, requestBody);

      // Parse the response from the server
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Competitor updated successfully',
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to update competitor',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  

  



Future<Map<String, dynamic>> updateUrl(
  String loggedInUserEmail,
  String url,
  String urlId, // Assuming you're passing `urlId`
  String orgSlug,
  String orgRoleId,
  String orgUserId,
  String orgUserorgId,
) async {
  isLoading = true;
  notifyListeners();
  try {
    // Create the body for the request
    final requestBody = {
      'email': loggedInUserEmail,     
      'url': url,     
      'url_id': urlId,  // Ensure the URL id is passed correctly
      'org_slug': orgSlug,
      'org_role_id': orgRoleId,
      'org_user_id': orgUserId,
      'org_user_org_id': orgUserorgId,
    };

    // Call the updateUrl function from the ApiService
    final response = await api.updateUrl(requestBody);
    // Decode the response body
    final responseData = jsonDecode(response.body);
    // Check if the request was successful
    if (response.statusCode == 200) {
      return {
        'success': true,
        'message': 'URL updated successfully',
      };
    } else {
      return {
        'success': false,
        'message': responseData['message'] ?? 'Failed to update URL',
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'An error occurred: $e',
    };
  } finally {
    isLoading = false;
    notifyListeners();
  }
}



 Future<Map<String, dynamic>> updateWebrank(
    String webid,
    String loggedInUserEmail,
    String selectedProject,
    String selectedProjectName,
    String domainAuthority,
    String alexaGlobalRank,
    String alexaUSARank,
    String alexaIndiaRank,
    String externalBacklinks,
    String referringDomains,
    String orgSlug,
    String orgRoleId,
    String orgUserId,
    String orgUserorgId,
  ) async {
    isLoading = true;
    notifyListeners();

    // Create the request body
    final requestBody = {
      'webid': webid, // Existing web rank ID
      'email': loggedInUserEmail, // User email
      'project_id': selectedProject, // Selected project ID
      'project_name': selectedProjectName, // Selected project name
      'domain_authority': domainAuthority, // Domain authority value
      'alexa_global_rank': alexaGlobalRank, // Alexa global rank value
      'alexa_usa_rank': alexaUSARank, // Alexa USA rank value
      'alexa_india_rank': alexaIndiaRank, // Alexa India rank value
      'external_backlinks': externalBacklinks, // External backlinks value
      'referring_domains': referringDomains, // Referring domains value
      'org_slug': orgSlug, // Organization slug
      'org_role_id': orgRoleId, // Organization role ID
      'org_user_id': orgUserId, // Organization user ID
      'org_user_org_id': orgUserorgId, // Organization user organization ID
    };

    try {
      // Call the service to update the Webrank
      final response = await api.updateWebRating(requestBody);

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Webrank updated successfully',
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to update Webrank',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

Future<Map<String, dynamic>> updateRating(
  String ratingId,       // widget.ratingId!
  String loggedInUserEmail, // Pass logged in user email as required/ Email from secure storage
  String selectedManager, // selectedManager!
  String selectedUser,    // selectedUser!
  String selectedWeek,    // selectedWeek!
  String selectedMonth,   // selectedMonth!
  String year,            // widget.year ?? DateTime.now().year.toString()
  String selectedRating,  // selectedRating!
  String orgSlug,         // widget.orgSlug
  String orgRoleId,       // Pass orgRoleId as required
  String orgUserId,       // Pass orgUserId as required
  String orgUserorgId,    // Pass orgUserorgId as required
  
) async {
  isLoading = true;
  notifyListeners();

  try {
    // Create the body for the request
    final requestBody = {
      'email': loggedInUserEmail,    // Pass user email     
      'rating': selectedRating,         // Map `selectedRating` to URL field
      'rating_id': ratingId,            // Use `ratingId` for urlId field
      'org_slug': orgSlug,
      'org_role_id': orgRoleId,      // Pass selectedManager (if that's your role)
      'org_user_id': orgUserId,
      'org_user_org_id': orgUserorgId,
      'week': selectedWeek,          // Additional metadata
      'month': selectedMonth,        // Additional metadata
      'year': year,
      'manager': selectedManager,
      'user': selectedUser,                   // Pass year as metadata
    };

    // Call the updateUrl function from the ApiService
    final response = await api.updateRating(requestBody);

    // Decode the response body
    final responseData = jsonDecode(response.body);

    // Check if the request was successful
    if (response.statusCode == 200) {
      return {
        'success': true,
        'message': 'URL updated successfully',
      };
    } else {
      return {
        'success': false,
        'message': responseData['message'] ?? 'Failed to update URL',
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'An error occurred: $e',
    };
  } finally {
    isLoading = false;
    notifyListeners();
  }
}

  Future<Map<String, dynamic>> createKeyword(
    String? loggedInUserEmail, // Email of the logged-in user
    String projectId, // Selected project ID
    String url, // Selected URL
    List<String> keywords, // List of keywords
    String orgSlug, // Organization slug
    String orgRoleId, // Organization role ID
    String orgUserId, // Organization user ID
    String orgUserorgId, // Organization user organization ID
    String projectName, // Organization user organization ID
    String urlName, // Organization user organization ID

  ) async {
    if (loggedInUserEmail == null || loggedInUserEmail.isEmpty) {
      return {
        'success': false,
        'message': 'Logged-in user email is required',
      };
    }

    if (projectId.isEmpty) {
      return {
        'success': false,
        'message': 'Project ID is required',
      };
    }

    if (url.isEmpty) {
      return {
        'success': false,
        'message': 'URL is required',
      };
    }

    if (keywords.isEmpty) {
      return {
        'success': false,
        'message': 'At least one keyword is required',
      };
    }

    isLoading = true;
    notifyListeners();
    try {
      // Prepare data for the API call
      final Map<String, dynamic> requestData = {
        'email': loggedInUserEmail,
        'project_id': projectId,
        'url': url,
        'keywords': keywords,
        'org_slug': orgSlug,
        'org_role_id': orgRoleId,
        'org_user_id': orgUserId,
        'org_user_org_id': orgUserorgId,
        'project_name': projectName,
        'url_name': urlName,
      };

      // Make the API call to create keywords
      final response = await api.createKeyword(requestData);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Keywords created successfully',
        };
      } else {
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to create keywords',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }  


   Future<Map<String, dynamic>> createUrl(
    String? loggedInUserEmail, // Email of the logged-in user
    String projectId, // Project name
    String projectUrl, // Project URL
    String projectName, // Project name 
    String orgSlug, // Organization slug
    String orgRoleId, // Organization role ID
    String orgUserId, // Organization user ID
    String orgUserorgId, // Organization user organization ID
  ) async {
    // Validate the necessary inputs
    if (loggedInUserEmail == null || loggedInUserEmail.isEmpty) {
      return {
        'success': false,
        'message': 'Logged-in user email is required',
      };
    }
    if (projectName.isEmpty) {
      return {
        'success': false,
        'message': 'Project name is required',
      };
    }
    if (projectUrl.isEmpty) {
      return {
        'success': false,
        'message': 'Project URL is required',
      };
    }

    // Set loading to true and notify listeners
    isLoading = true;
    notifyListeners();
    try {
      // Make the API call to create the URL
      final response = await api.createUrl(
        loggedInUserEmail, // Email of the user creating the URL
        projectId, // Project name
        projectUrl, // Project URL
        projectName, // Manager email
        orgSlug, // Organization slug
        orgRoleId, // Organization role ID
        orgUserId, // Organization user ID
        orgUserorgId, // Organization user organization ID
      );
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'URL created successfully',
        };
      } else {
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to create URL',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> createCompetitorUrl(
  String? loggedInUserEmail,  // Email of the logged-in user
  String projectId, 
   String projectName,             // Project ID or name
  String competitorName,       // Competitor name
  String website,              // Competitor website
  String facebookUrl,          // Facebook URL
  String twitterUrl,           // Twitter URL
  String instagramUrl,         // Instagram URL
  String youtubeUrl,           // YouTube URL
  String linkedinUrl,          // LinkedIn URL
  String pinterestUrl,         // Pinterest URL
  String redditUrl,            // Reddit URL
  String tiktokUrl,            // TikTok URL
  String orgSlug,              // Organization slug
  String orgRoleId,            // Organization role ID
  String orgUserId,            // Organization user ID
  String orgUserorgId          // Organization user organization ID
) async {
  // Validate the necessary inputs
  if (loggedInUserEmail == null || loggedInUserEmail.isEmpty) {
    return {
      'success': false,
      'message': 'Logged-in user email is required',
    };
  }
  if (projectId.isEmpty) {
    return {
      'success': false,
      'message': 'Project ID or name is required',
    };
  }
  if (competitorName.isEmpty) {
    return {
      'success': false,
      'message': 'Competitor name is required',
    };
  }
  if (website.isEmpty) {
    return {
      'success': false,
      'message': 'Competitor website is required',
    };
  }

  // Set loading to true and notify listeners
  isLoading = true;
  notifyListeners();

  try {
    // Prepare the request data
    final requestData = {
      "logged_in_user_email": loggedInUserEmail,
      "project_id": projectId,
       "project_name": projectName,        
      "competitor_name": competitorName,
      "website": website,
      "facebook_url": facebookUrl,
      "twitter_url": twitterUrl,
      "instagram_url": instagramUrl,
      "youtube_url": youtubeUrl,
      "linkedin_url": linkedinUrl,
      "pinterest_url": pinterestUrl,
      "reddit_url": redditUrl,
      "tiktok_url": tiktokUrl,
      "org_slug": orgSlug,
      "org_roleid": orgRoleId,
      "org_userid": orgUserId,
      "org_userorgid": orgUserorgId,
    };

    final response = await api.createCompetitorUrl(requestData);

    if (response.statusCode == 200) {
      return {
        'success': true,
        'message': 'Competitor URL created successfully',
      };
    } else {
      final responseData = jsonDecode(response.body);
      return {
        'success': false,
        'message': responseData['message'] ?? 'Failed to create competitor URL',
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'An error occurred: ${e.toString()}',
    };
  } finally {
    // Set loading to false and notify listeners
    isLoading = false;
    notifyListeners();
  }
}

 Future<Map<String, dynamic>> createTask(
    String? loggedInUserEmail, // Email of the logged-in user
    String projectId, 
    String taskTitle,          // Task title
    String taskDeadline,       // Task deadline
    String webUrl,             // Selected URL
    String assignedTo,         // Assigned user email
    String keyword,            // Keyword
    String severity,           // Task severity
    String taskType,           // Task type
    String description,        // Task description
    String attachmentFilePath, // File attachment path
    String orgSlug,            // Organization slug
    String orgRoleId,          // Organization role ID
    String orgUserId,          // Organization user ID
    String orgUserorgId        // Organization user organization ID
  ) async {
    // Validate the necessary inputs
    if (loggedInUserEmail == null || loggedInUserEmail.isEmpty) {
      return {
        'success': false,
        'message': 'Logged-in user email is required',
      };
    }
    if (projectId.isEmpty) {
      return {
        'success': false,
        'message': 'Project ID is required',
      };
    }
    if (taskTitle.isEmpty) {
      return {
        'success': false,
        'message': 'Task title is required',
      };
    }

    // Set loading to true and notify listeners
    isLoading = true;
    notifyListeners();

    try {
      // Prepare the request data
      final requestData = {
        "logged_in_user_email": loggedInUserEmail,
        "project_id": projectId,
        "task_title": taskTitle,
        "task_deadline": taskDeadline,
        "web_url": webUrl,
        "assigned_to": assignedTo,
        "keyword": keyword,
        "severity": severity,
        "task_type": taskType,
        "description": description,
        "attachment_file_path": attachmentFilePath,
        "org_slug": orgSlug,
        "org_roleid": orgRoleId,
        "org_userid": orgUserId,
        "org_userorgid": orgUserorgId,
      };

     final response = await api.createTask(requestData, attachmentFilePath);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Task created successfully',
        };
      } else {
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to create task',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    } finally {
      // Set loading to false and notify listeners
      isLoading = false;
      notifyListeners();
    }
  }

  
 Future<Map<String, dynamic>> createIntervalTask(
    String loggedInUserEmail, // Email of the logged-in user
    String taskTitle,          // Task title
    String taskDetails,        // Task details
    String taskFreq,           // Task frequency
    List<String> assignedUsers, // Assigned users
    String orgSlug,            // Organization slug
    String orgRoleId,          // Organization role ID
    String orgUserId,          // Organization user ID
    String orgUserorgId        // Organization user organization ID
  ) async {
    if (loggedInUserEmail.isEmpty) {
      return {
        'success': false,
        'message': 'Logged-in user email is required',
      };
    }

    if (taskTitle.isEmpty) {
      return {
        'success': false,
        'message': 'Task title is required',
      };
    }

    isLoading = true;

    try {
      final requestData = {
        "logged_in_user_email": loggedInUserEmail,
        "task_title": taskTitle,
        "task_details": taskDetails,
        "task_freq": taskFreq,
        "assigned_users": assignedUsers,
        "org_slug": orgSlug,
        "org_roleid": orgRoleId,
        "org_userid": orgUserId,
        "org_userorgid": orgUserorgId,
      };
 final response = await api.createTaskinterval(requestData);
      

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Interval task created successfully',
        };
      } else {
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to create interval task',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    } finally {
      isLoading = false;
    }
  } 

   Future<Map<String, dynamic>> openwebasset( 
    String orgSlug,
    String orgRoleId,
    String orgUserId,
    String orgUserorgId,
    String pro_name,
    String? token_name,
    String? attachmentFilePath,
    String? loggedInUserEmail,
    String? webid,
 //   BuildContext context, // Add context to navigate
    
  ) async {
    if (loggedInUserEmail!.isEmpty) {
      return {
        'success': false,
        'message': 'Logged-in user email is required',
      };
    } 
    isLoading = true;
    try {
      final requestData = {
        "logged_in_user_email": loggedInUserEmail,
        "pro_name": pro_name,
        "token_name": token_name,
        "attachment_file_path": attachmentFilePath,
        "webid": webid,     
        "org_slug": orgSlug,
        "org_roleid": orgRoleId,
        "org_userid": orgUserId,
        "org_userorgid": orgUserorgId,
      };
       print("Request Data: $requestData");
       final response = await api.openwebasset(requestData,attachmentFilePath);
      if (response.statusCode == 200) {
        print("coming inside");
        print(response.statusCode);
         print("Response Body: ${response.body}");
      final Map<String, dynamic> responseData = jsonDecode(response.body); 

       print(responseData);
       return responseData; // Return the decoded response
      } else {
             print("coming else inside");
        print(response.statusCode);
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to create interval task',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    } finally {
      isLoading = false;
    }
  }

   Future<Map<String, dynamic>> createWebsiteAsset(

    String loggedInUserEmail,
    String emailAddress,
    String userName,
    String password,
    String website,
    String? projectId,
    String? assetType,
    String? publicKey,
    String? manager,
    String orgSlug,
    String orgRoleId,
    String orgUserId,
    String orgUserorgId,     // Organization user organization ID
  ) async {
    if (loggedInUserEmail.isEmpty) {
      return {
        'success': false,
        'message': 'Logged-in user email is required',
      };
    } 
    isLoading = true;
    try {
      final requestData = {
        "logged_in_user_email": loggedInUserEmail,
        "email_address": emailAddress,
        "user_name": userName,
        "password": password,
        "website": website,
        "project_id": projectId,
        "asset_type": assetType,
        "public_key": publicKey,
         "manager": manager,
        "org_slug": orgSlug,
        "org_roleid": orgRoleId,
        "org_userid": orgUserId,
        "org_userorgid": orgUserorgId,
      };
       final response = await api.createWebAsset(requestData);
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Interval task created successfully',
        };
      } else {
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to create interval task',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    } finally {
      isLoading = false;
    }
  }
 // Update Interval Task
  Future<Map<String, dynamic>> updateIntervalTask(
    int id,                    // Task ID
    String loggedInUserEmail,  // Email of the logged-in user
    String taskTitle,          // Task title
    String taskDetails,        // Task details
    String taskFreq,           // Task frequency
    List<String> assignedUsers, // Assigned users
    String users,
    String orgSlug,            // Organization slug
    String orgRoleId,          // Organization role ID
    String orgUserId,          // Organization user ID
    String orgUserorgId        // Organization user organization ID
  ) async {
    if (loggedInUserEmail.isEmpty) {
      return {
        'success': false,
        'message': 'Logged-in user email is required',
      };
    }

    if (taskTitle.isEmpty) {
      return {
        'success': false,
        'message': 'Task title is required',
      };
    }

    isLoading = true;

    try {
      final requestData = {
        "id": id.toString(),
        "logged_in_user_email": loggedInUserEmail,
        "task_title": taskTitle,
        "task_details": taskDetails,
        "task_freq": taskFreq,
        "assigned_users": assignedUsers,
        "users": users,
        "org_slug": orgSlug,
        "org_roleid": orgRoleId,
        "org_userid": orgUserId,
        "org_userorgid": orgUserorgId,
      };

      final response = await api.updateTaskinterval(requestData);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Interval task updated successfully',
        };
      } else {
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to update interval task',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    } finally {
      isLoading = false;
    }
  }  

   Future<Map<String, dynamic>> updateWebsiteAsset(
    int id,                    // Task ID
    String loggedInUserEmail,
    String emailAddress,
    String userName,
    String password,
    String website,
    String? projectId,
    String? assetType,
    String? publicKey,
    String? manager,
    String orgSlug,
    String orgRoleId,
    String orgUserId,
    String orgUserorgId,      // Organization user organization ID
  ) async {
    if (loggedInUserEmail.isEmpty) {
      return {
        'success': false,
        'message': 'Logged-in user email is required',
      };
    }  
    isLoading = true;
    try {
      final requestData = {
        "id": id.toString(),
        "logged_in_user_email": loggedInUserEmail,
         "email_address": emailAddress,
        "user_name": userName,
        "password": password,
        "website": website,
        "project_id": projectId,
        "asset_type": assetType,
        "public_key": publicKey,
         "manager": manager,
        "org_slug": orgSlug,
        "org_roleid": orgRoleId,
        "org_userid": orgUserId,
        "org_userorgid": orgUserorgId,
      };
      print("updateWebasset cominh");

      final response = await api.updateWebasset(requestData);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Interval task updated successfully',
        };
      } else {
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to update interval task',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    } finally {
      isLoading = false;
    }
  }
Future<Map<String, dynamic>> createSocialwizard(
  String? loggedInUserEmail, // Email of the logged-in user
  String projectId,
  String projectName,         // Project name
  String facebookUrl,         // Facebook URL
  String tiktokUrl,           // TikTok URL
  String slideshareUrl,       // Slideshare URL
  String dailymotionUrl,      // Dailymotion URL
  String youtubeUrl,          // YouTube URL
  String twitterUrl,          // Twitter URL
  String linkedinUrl,         // LinkedIn URL
  String instagramUrl,        // Instagram URL
  String tumblrUrl,           // Tumblr URL
  String wordpressUrl,        // WordPress URL
  String pinterestUrl,        // Pinterest URL
  String redditUrl,           // Reddit URL
  String plurkUrl,            // Plurk URL
  String debugschoolUrl,      // Debug School URL
  String bloggerUrl,          // Blogger URL
  String mediumUrl,           // Medium URL
  String quoraUrl,            // Quora URL
  String githubUrl,           // GitHub URL
  String gurukulgalaxyUrl,    // Gurukulgalaxy URL
  String professnowUrl,       // Professnow URL
  String hubpagesUrl,         // HubPages URL
  String mymedicplusUrl,      // MyMedicPlus URL
  String holidaylandmarkUrl,  // Holiday Landmark URL
  String devopsschoolUrl, 
  String facebook_page ,    // DevOps School URL
  String orgSlug,             // Organization slug
  String orgRoleId,           // Organization role ID
  String orgUserId,           // Organization user ID
  String orgUserorgId,
          // Organization user organization ID
) async {
  // Validate the necessary inputs
  if (loggedInUserEmail == null || loggedInUserEmail.isEmpty) {
    return {
      'success': false,
      'message': 'Logged-in user email is required',
    };
  }
  // Set loading to true and notify listeners
  isLoading = true;
  notifyListeners();

  try {
    // Prepare the request data
    final requestData = {
      "logged_in_user_email": loggedInUserEmail,
      "project_id": projectId, 
      "project_name": projectName,
      "facebooks": facebookUrl,
      "tiktok": tiktokUrl,
      "slideshare": slideshareUrl,
      "dailymotion": dailymotionUrl,
      "youtube": youtubeUrl,
      "twitter": twitterUrl,
      "linkedin": linkedinUrl,
      "instagram": instagramUrl,
      "tumblr": tumblrUrl,
      "wordpress": wordpressUrl,
      "pinterest": pinterestUrl,
      "reddit": redditUrl,
      "plurk": plurkUrl,
      "debugschool": debugschoolUrl,
      "blogger": bloggerUrl,
      "medium": mediumUrl,
      "quora": quoraUrl,
      "github": githubUrl,
      "gurukulgalaxy": gurukulgalaxyUrl,
      "professnow": professnowUrl,
      "hubpages": hubpagesUrl,
      "mymedicplus": mymedicplusUrl,
      "holidaylandmark": holidaylandmarkUrl,
      "devopsschool": devopsschoolUrl,
      "facebook_page": facebook_page,
      "org_slug": orgSlug,
      "org_roleid": orgRoleId,
      "org_userid": orgUserId,
      "org_userorgid": orgUserorgId,
   
      
    };

    final response = await api.createSocialwizard(requestData);

    if (response.statusCode == 200) {
      return {
        'success': true,
        'message': 'Social wizard created successfully',
      };
    } else {
      final responseData = jsonDecode(response.body);
      return {
        'success': false,
        'message': responseData['message'] ?? 'Failed to create social wizard',
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'An error occurred: ${e.toString()}',
    };
  } finally {
    // Set loading to false and notify listeners
    isLoading = false;
    notifyListeners();
  }
}
 // Function to create a Social Rank entry
  Future<Map<String, dynamic>> createSocialRank(
    String? loggedInUserEmail,  // Email of the logged-in user
    String projectId, 
    String projectName,         // Project ID or name
    String youtubeSubscribers,  // YouTube Subscribers
    String twitterFollowers,    // Twitter Followers
    String instagramFollowers,  // Instagram Followers
    String facebookLikes,       // Facebook Likes
    String orgSlug,             // Organization slug
    String orgRoleId,           // Organization role ID
    String orgUserId,           // Organization user ID
    String orgUserorgId         // Organization user organization ID
  ) async {
    // Validate the necessary inputs
    if (loggedInUserEmail == null || loggedInUserEmail.isEmpty) {
      return {
        'success': false,
        'message': 'Logged-in user email is required',
      };
    }
    if (projectId.isEmpty) {
      return {
        'success': false,
        'message': 'Project ID or name is required',
      };
    }
    
    // Set loading to true and notify listeners
    isLoading = true;
    notifyListeners();

    try {
      // Prepare the request data
      final requestData = {
        "logged_in_user_email": loggedInUserEmail,
        "project_id": projectId,
        "project_name": projectName,        
        "youtube_subscribers": youtubeSubscribers,
        "twitter_followers": twitterFollowers,
        "instagram_followers": instagramFollowers,
        "facebook_likes": facebookLikes,
        "org_slug": orgSlug,
        "org_roleid": orgRoleId,
        "org_userid": orgUserId,
        "org_userorgid": orgUserorgId,
      };

      final response = await api.createSocialRank(requestData);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Social Rank created successfully',
        };
      } else {
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to create Social Rank',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    } finally {
      // Set loading to false and notify listeners
      isLoading = false;
      notifyListeners();
    }
  }

 Future<Map<String, dynamic>> createPagerank(
    String? loggedInUserEmail, // Email of the logged-in user
    String projectId,
    String ProjectName,
    String selectedUrlname, // Selected URL
    String selectedUrl, // Selected URL
    String googlePagerank, // Google PageRank
    String pageAuthority, // Page Authority
    String googleSearchPlacement, // Google Search Page Placement
    String bsPagePlacement, // BS Page Placement
    String orgSlug, // Organization slug
    String orgRoleId, // Organization role ID
    String orgUserId, // Organization user ID
    String orgUserorgId // Organization user organization ID
  ) async {
    // Validate the necessary inputs
    if (loggedInUserEmail == null || loggedInUserEmail.isEmpty) {
      return {
        'success': false,
        'message': 'Logged-in user email is required',
      };
    }
    if (projectId.isEmpty) {
      return {
        'success': false,
        'message': 'Project ID or name is required',
      };
    }
    if (selectedUrl.isEmpty) {
      return {
        'success': false,
        'message': 'URL is required',
      };
    }

    // Set loading to true and notify listeners
    isLoading = true;
    notifyListeners();

    try {
      // Prepare the request data
      final requestData = {
        "logged_in_user_email": loggedInUserEmail,
        "project_id": projectId,
        "project_name": ProjectName,
          "url_name": selectedUrlname,
        "url": selectedUrl,      
        "google_pagerank": googlePagerank,
        "page_authority": pageAuthority,
        "google_search_placement": googleSearchPlacement,
        "bs_page_placement": bsPagePlacement,
        "org_slug": orgSlug,
        "org_roleid": orgRoleId,
        "org_userid": orgUserId,
        "org_userorgid": orgUserorgId,
      };

      final response = await api.createPagerank(requestData);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'PageRank created successfully',
        };
      } else {
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to create PageRank',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    } finally {
      // Set loading to false and notify listeners
      isLoading = false;
      notifyListeners();
    }
  }

Future<Map<String, dynamic>> updatePagerank(
  String pageid, // Existing page rank ID
  String loggedInUserEmail, // User email
  String selectedProject, // Selected project ID
  String selectedProjectName, // Selected project name
  String selectedUrl, // Selected URL
  String googlePagerank, // Google page rank value
  String pageAuthority, // Page authority value
  String googlePagePlacement, // Google search page placement value
  String bsPagePlacement, // Bing search page placement value
  String orgSlug, // Organization slug
  String orgRoleId, // Organization role ID
  String orgUserId, // Organization user ID
  String orgUserorgId, // Organization user organization ID
) async {
  isLoading = true;
  notifyListeners();

  // Create the request body
  final requestBody = {
    'pageid': pageid, // Existing page rank ID
    'email': loggedInUserEmail, // User email
    'project_id': selectedProject, // Selected project ID
    'project_name': selectedProjectName, // Selected project name
    'url_id': selectedUrl, // Selected URL
    'google_pagerank': googlePagerank, // Google pagerank value
    'page_authority': pageAuthority, // Page authority value
    'google_page_placement': googlePagePlacement, // Google search page placement
    'bs_page_placement': bsPagePlacement, // Bing search page placement
    'org_slug': orgSlug, // Organization slug
    'org_role_id': orgRoleId, // Organization role ID
    'org_user_id': orgUserId, // Organization user ID
    'org_user_org_id': orgUserorgId, // Organization user organization ID
  };

  try {
    // Call the service to update the Pagerank
    final response = await api.updatePagerank(requestBody);

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {
        'success': true,
        'message': 'Pagerank updated successfully',
      };
    } else {
      return {
        'success': false,
        'message': responseData['message'] ?? 'Failed to update Pagerank',
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'An error occurred: $e',
    };
  } finally {
    isLoading = false;
    notifyListeners();
  }
}

Future<Map<String, dynamic>> updateTask(
  String loggedInUserEmail, // User email
  String taskId, // Existing task ID
  String selectedProjectId, // Selected project ID
  String taskTitle, // Task title
  String taskDeadline, // Task deadline
  String selectedUrl, // Selected URL
  String selectedOwner, // Task owner
  String selectedKeywords, // Keywords
  String selectedSeverity, // Severity level
  String selectedTaskType, // Task type
  String description, // Task description
  String document, // Document path
  String orgSlug, // Organization slug
  String orgRoleId, // Organization role ID
  String orgUserId, // Organization user ID
  String orgUserorgId, // Organization user organization ID
) async {
  isLoading = true;
  notifyListeners();

  // Create the request body with task update details
  final requestBody = {
    'task_id': taskId, // Task ID for update
    'email': loggedInUserEmail, // User email
    'project_id': selectedProjectId, // Selected project ID
    'task_title': taskTitle, // Task title
    'task_deadline': taskDeadline, // Task deadline
    'url': selectedUrl, // Selected URL
    'owner': selectedOwner, // Task owner
    'keywords': selectedKeywords, // Keywords
    'severity': selectedSeverity, // Task severity
    'task_type': selectedTaskType, // Task type
    'description': description, // Task description
    'document': document, // Document path
    'org_slug': orgSlug, // Organization slug
    'org_role_id': orgRoleId, // Organization role ID
    'org_user_id': orgUserId, // Organization user ID
    'org_user_org_id': orgUserorgId, // Organization user org ID
  };

  try {
    // Call the API to update the task
    final response = await api.updateTaskboard(requestBody);

    // Decode the response body
    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // If the response is successful
      return {
        'success': true,
        'message': 'Task updated successfully',
      };
    } else {
      // Handle unsuccessful response
      return {
        'success': false,
        'message': responseData['message'] ?? 'Failed to update task',
      };
    }
  } catch (e) {
    // Handle errors
    return {
      'success': false,
      'message': 'An error occurred: $e',
    };
  } finally {
    isLoading = false;
    notifyListeners();
  }
}

 Future<Map<String, dynamic>> createWebrank(
    String? loggedInUserEmail,  // Email of the logged-in user
    String projectId, 
    String projectName,         
    String domainAuthority,     
    String alexaGlobalRank,     
    String alexaUSARank,        
    String alexaIndiaRank,      
    String externalBacklinks,   
    String referringDomains,    
    String orgSlug,             
    String orgRoleId,           
    String orgUserId,           
    String orgUserorgId         
  ) async {
    // Validate the necessary inputs
    if (loggedInUserEmail == null || loggedInUserEmail.isEmpty) {
      return {
        'success': false,
        'message': 'Logged-in user email is required',
      };
    }
    if (projectId.isEmpty) {
      return {
        'success': false,
        'message': 'Project ID or name is required',
      };
    }

    // Set loading to true and notify listeners
    isLoading = true;
    notifyListeners();

    try {
      // Prepare the request data
      final requestData = {
        "logged_in_user_email": loggedInUserEmail,
        "project_id": projectId,
        "project_name": projectName,
        "domain_authority": domainAuthority,
        "alexa_global_rank": alexaGlobalRank,
        "alexa_usa_rank": alexaUSARank,
        "alexa_india_rank": alexaIndiaRank,
        "external_backlinks": externalBacklinks,
        "referring_domains": referringDomains,
        "org_slug": orgSlug,
        "org_roleid": orgRoleId,
        "org_userid": orgUserId,
        "org_userorgid": orgUserorgId,
      };

      // Assuming your API service has a method for creating Webrank entries
      final response = await api.createWebrank(requestData);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Webrank created successfully',
        };
      } else {
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to create Webrank',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    } finally {
      // Set loading to false and notify listeners
      isLoading = false;
      notifyListeners();
    }
  }

Future<Map<String, dynamic>> createRating(
    String? loggedInUserEmail, // Email of the logged-in user
    String managerId,          // Selected manager ID
    String managerName,        // Selected manager name
    String selectedWeek,       // Selected week
    String selectedMonth,      // Selected month
    String year,               // Current year
    String rating,             // Selected rating
    String orgSlug,            // Organization slug
    String orgRoleId,          // Organization role ID
    String orgUserId,          // Organization user ID
    String orgUserorgId,       // Organization user organization ID

    // Additional parameters
    String? managerEmail,
    String? managerInvitedBy,
    String? managerInvitedByEmail,
    String? managerOrgUserId,
    String? managerOrgRoleId,
    String? managerOrgRoleName,
    String? managerOrgOrganizationId,
    String? managerOrgSlugName,
    String? managerStatus,
    String? managerInvitedRemoved,
  ) async {
    // Validate input parameters
    if (loggedInUserEmail == null || loggedInUserEmail.isEmpty) {
      return {
        'success': false,
        'message': 'Logged-in user email is required',
      };
    }

    if (managerId.isEmpty) {
      return {
        'success': false,
        'message': 'Manager ID is required',
      };
    }

    if (selectedWeek.isEmpty) {
      return {
        'success': false,
        'message': 'Week is required',
      };
    }

    if (selectedMonth.isEmpty) {
      return {
        'success': false,
        'message': 'Month is required',
      };
    }

    if (rating.isEmpty) {
      return {
        'success': false,
        'message': 'Rating is required',
      };
    }

    // Set loading to true and notify listeners
    isLoading = true;
    notifyListeners();

    try {
      // Prepare data for the API call
      final requestData = {
        'email': loggedInUserEmail,
        'manager_id': managerId,
        'manager_name': managerName,
        'week': selectedWeek,
        'month': selectedMonth,
        'year': year,
        'rating': rating,
        'org_slug': orgSlug,
        'org_role_id': orgRoleId,
        'org_user_id': orgUserId,
        'org_user_org_id': orgUserorgId,

        // Include additional parameters in the request data
        'manager_email': managerEmail,
        'manager_invited_by': managerInvitedBy,
        'manager_invited_by_email': managerInvitedByEmail,
        'manager_org_user_id': managerOrgUserId,
        'manager_org_role_id': managerOrgRoleId,
        'manager_org_role_name': managerOrgRoleName,
        'manager_org_organization_id': managerOrgOrganizationId,
        'manager_org_slug_name': managerOrgSlugName,
        'manager_status': managerStatus,
        'manager_invited_removed': managerInvitedRemoved,
      };

      // Make the API call using the ApiService
      final response = await api.createRating(requestData);

      // Check the response status code
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'message': responseData['message'] ?? 'Rating created successfully',
        };
      } else {
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to create rating',
        };
      }
    } catch (e) {
      // Handle errors during the API call
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    } finally {
      // Set loading to false and notify listeners
      isLoading = false;
      notifyListeners();
    }
  }


  
  Future<void> deletemyOrganization({
    required String loggedEmail, 
    required String email, 
    required String role, 
    required String orgSlug,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      // Make API call to delete the user
      final response = await api.deleteUser(loggedEmail, email, role, orgSlug);

      if (response.statusCode == 200) {
        print('User deleted successfully');
      } else {
        print('Failed to delete user');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

 Future<Map<String, dynamic>> deleteOrganization(String email, String id) async {
  try {
    // Call the API to delete the organization
    final response = await api.deleteOrganization(email, id);

    if (response.statusCode == 200) {
      // Parse the response
      final data = jsonDecode(response.body);

      // Convert 'success' field from String to bool if necessary
      bool isSuccess = data['success'].toString().toLowerCase() == 'true';

      if (isSuccess) {
        // Remove the organization from the local list
        organizations.removeWhere((org) => org.id.toString() == id);
        notifyListeners();
        return {'success': true};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Failed to delete organization'};
      }
    } else {
      // Handle non-200 status code
      return {'success': false, 'message': 'Failed to delete organization, server error'};
    }
  } catch (e) {
    // Handle any other errors
    return {'success': false, 'message': 'Exception: ${e.toString()}'};
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

  Future<void> getProject(String email, String orgSlug, String orgRoleId, String orgUserId, String orgUserorgId) async {
  isLoading = true;
  notifyListeners();  
  try {
    // Pass the parameters to your API call as needed.
  List<Project> projects = await api.fetchProjects(email, orgSlug, orgRoleId, orgUserId, orgUserorgId);   
    // Sort the projects in descending order by 'id'.
    projects.sort((a, b) => b.id.compareTo(a.id));
    // Set the sorted projects to my_projects.
    my_projects = projects;    
    print(my_projects);
     print("fetching all project is there");
  } catch (error) {
    print("Error fetching projects: $error");
    my_projects = [];
  } finally {
    isLoading = false;
    notifyListeners();
  }
}


Future<void> getCount(String email, String orgSlug, String orgRoleId, String orgUserId, String orgUserorgId) async {
  isLoading = true;
  notifyListeners();

  try {
    // Fetch the data as a TaskSummary instance
    my_task_count = await api.fetchtaskcount(email, orgSlug, orgRoleId, orgUserId, orgUserorgId);
    
    print("Fetched task counts: $my_task_count");
  } catch (error) {
    print("Error fetching task counts: $error");
    my_task_count = null; // Reset to null in case of error
  } finally {
    isLoading = false;
    notifyListeners();
  }
}



  Future<void> getUrl(String email, String orgSlug, String orgRoleId, String orgUserId, String orgUserorgId) async {
    isLoading = true;
    notifyListeners();
    try {     
  List<Url> urls  = await api.fetchUrls(email, orgSlug, orgRoleId, orgUserId, orgUserorgId);
       urls.sort((a, b) => b.id.compareTo(a.id)); 
      my_urls = urls;
      print("all url coming");
        print(my_urls);
    } catch (error) {
      print("Error fetching projects: $error");
      my_urls = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  Future<void> getKeyword(String email, String orgSlug, String orgRoleId, String orgUserId, String orgUserorgId) async {
    isLoading = true;
    notifyListeners();
    try {
      // API call to fetch projects
  List<Keyword> keywords  = await api.fetchKeywords(email, orgSlug, orgRoleId, orgUserId, orgUserorgId);
      print("keys are there");
          print(keywords);
      keywords.sort((a, b) => b.id.compareTo(a.id)); 
      my_keywords = keywords;
       print("all my_keywords coming");
        print(my_keywords);
    } catch (error) {
      print("Error fetching keywording: $error");
      my_keywords = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

Future<void> getCompetitor(String email, String orgSlug, String orgRoleId, String orgUserId, String orgUserorgId) async {
    isLoading = true;
    notifyListeners();
    try {
  List<Competitor> competitors  = await api.fetchCompetitors(email, orgSlug, orgRoleId, orgUserId, orgUserorgId);
     competitors.sort((a, b) => b.id.compareTo(a.id));  
      my_competitors = competitors;
      print("my getcompetitor is coming");      
          print(my_competitors);          
    } catch (error) {
      print("Error fetching getCompetitor: $error");
      my_competitors = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }



Future<void> getEmailassets(String email, String orgSlug, String orgRoleId, String orgUserId, String orgUserorgId) async {
    isLoading = true;
    notifyListeners();
    try {    
  List<EmailModel> emails  = await api.fetchEmails(email, orgSlug, orgRoleId, orgUserId, orgUserorgId);
     emails.sort((a, b) => b.id.compareTo(a.id));  
      my_emails = emails;
      print("my getEmailassets is coming");      
          print(my_emails);          
    } catch (error) {
      print("Error fetching getCompetitor: $error");
      my_emails = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  Future<void> getGuestassets(String email, String orgSlug, String orgRoleId, String orgUserId, String orgUserorgId) async {
    isLoading = true;
    notifyListeners();
    try {    
  List<GuestModel> guest_post  = await api.fetchGuests(email, orgSlug, orgRoleId, orgUserId, orgUserorgId);
     guest_post.sort((a, b) => b.id.compareTo(a.id));  
      my_guests = guest_post;
      print("my getGuestassets is coming");      
          print(my_guests);          
    } catch (error) {
      print("Error fetching getCompetitor: $error");
      my_guests = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }




  Future<void> getPhoneassets(String email, String orgSlug, String orgRoleId, String orgUserId, String orgUserorgId) async {
    isLoading = true;
    notifyListeners();
    try {      
  List<PhoneModel> phones  = await api.fetchPhones(email, orgSlug, orgRoleId, orgUserId, orgUserorgId);
     phones.sort((a, b) => b.id.compareTo(a.id));  
      my_phones = phones;
      print("my my_phones is coming");      
          print(my_phones);          
    } catch (error) {
      print("Error fetching my_phones: $error");
      my_phones = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getWebassets(String email, String orgSlug, String orgRoleId, String orgUserId, String orgUserorgId) async {
    isLoading = true;
    notifyListeners();
    try {   
  List<WebassetsModel> webassets  = await api.fetchWebassets(email, orgSlug, orgRoleId, orgUserId, orgUserorgId);
     webassets.sort((a, b) => b.id.compareTo(a.id));  
      my_webassets = webassets;
      print("my getWebassets is coming");      
          print(my_webassets);          
    } catch (error) {
      print("Error fetching getWebassets: $error");
      my_webassets = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  
  Future<void> getToken(String email, String orgSlug, String orgRoleId, String orgUserId, String orgUserorgId) async {
    isLoading = true;
    notifyListeners();
    try {   
  List<WebTokenModel> webtokens  = await api.fetchWebtokens(email, orgSlug, orgRoleId, orgUserId, orgUserorgId);
     webtokens.sort((a, b) => b.id.compareTo(a.id));  
      my_tokens = webtokens;
      print("my my_tokens is coming");      
          print(my_tokens);          
    } catch (error) {
      print("Error fetching webtokens: $error");
      my_tokens = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getRating(String email, String orgSlug, String orgRoleId, String orgUserId, String orgUserorgId) async {
    isLoading = true;
    notifyListeners();
    try {  
  List<Rating> ratings  = await api.fetchRatings(email, orgSlug, orgRoleId, orgUserId, orgUserorgId);
      ratings.sort((a, b) => b.id.compareTo(a.id));
      my_team = ratings;
      print("mera rating aata hain");
      print(my_team);

    } catch (error) {
      print("Error fetching projects: $error");
      my_team = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
 Future<void> getWebRating(String email, String orgSlug, String orgRoleId, String orgUserId, String orgUserorgId) async {
    isLoading = true;
    notifyListeners();
    try {  
  List<WebRatings> webratings  = await api.fetchWebratings(email, orgSlug, orgRoleId, orgUserId, orgUserorgId);
    webratings.sort((a, b) => b.id.compareTo(a.id));
      my_website = webratings;
    } catch (error) {
      print("Error fetching getWebRating: $error");
      my_website = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


    Future<void> getPageranking(String email, String orgSlug, String orgRoleId, String orgUserId, String orgUserorgId) async {
    isLoading = true;
    notifyListeners();
    try {
      // API call to fetch projects
  List<PageRanking> pageranking  = await api.fetchPagerating(email, orgSlug, orgRoleId, orgUserId, orgUserorgId);
      pageranking.sort((a, b) => b.id.compareTo(a.id));
      my_page = pageranking;
      print("getpage ranking come");
      print(my_page);

    } catch (error) {
      print("Error fetching projects: $error");
      my_page = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


    Future<void> getSocialranking(String email, String orgSlug, String orgRoleId, String orgUserId, String orgUserorgId) async {
    isLoading = true;
    notifyListeners();
    try {
      // API call to fetch projects
  List<SocialRanking> socialrating  = await api.fetchSocailrating(email, orgSlug, orgRoleId, orgUserId, orgUserorgId);
       socialrating.sort((a, b) => b.id.compareTo(a.id));
      my_social = socialrating;
      
    } catch (error) {
      print("Error fetching projects: $error");
      my_social = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
    }

Future<Map<String, dynamic>> createEmail(
    String? loggedInUserEmail, // Email of the logged-in user
    String email,               // New email to be created
    String phoneNumber,         // Phone number
    String password,            // Password
    String passwordHint,        // Password hint
    String accountRecovery,      // Account recovery info
    String orgSlug,             // Organization slug
    String orgRoleId,           // Organization role ID
    String orgUserId,           // Organization user ID
    String orgUserorgId,        // Organization user organization ID
) async {
    // Validate input parameters
    if (loggedInUserEmail == null || loggedInUserEmail.isEmpty) {
        return {
            'success': false,
            'message': 'Logged-in user email is required',
        };
    }
    if (email.isEmpty) {
        return {
            'success': false,
            'message': 'Email is required',
        };
    }
    if (phoneNumber.isEmpty) {
        return {
            'success': false,
            'message': 'Phone number is required',
        };
    }
    if (password.isEmpty) {
        return {
            'success': false,
            'message': 'Password is required',
        };
    }
    
    isLoading = true;
    notifyListeners();

    try {
        // Prepare data for the API call
        final requestData = {
            'email': loggedInUserEmail,
            'new_email': email,
            'phone_number': phoneNumber,
            'password': password,
            'password_hint': passwordHint,
            'account_recovery': accountRecovery,
            'org_slug': orgSlug,
            'org_role_id': orgRoleId,
            'org_user_id': orgUserId,
            'org_user_org_id': orgUserorgId,
        };

        // Make the API call using the ApiService
        final response = await api.createEmail(requestData);

        // Check the response status code
        if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            return {
                'success': true,
                'message': responseData['message'] ?? 'Email created successfully',
            };
        } else {
            final responseData = jsonDecode(response.body);
            return {
                'success': false,
                'message': responseData['message'] ?? 'Failed to create email',
            };
        }
    } catch (e) {
        return {
            'success': false,
            'message': 'An error occurred: ${e.toString()}',
        };
    } finally {
        isLoading = false;
        notifyListeners();
    }
}
Future<Map<String, dynamic>> generatekey(
  String loggedInUserEmail, // Email of the logged-in user
  String orgSlug,           // Organization slug
  String orgRoleId,         // Organization role ID
  String orgUserId,         // Organization user ID
  String orgUserorgId,       // Organization user organization ID
    String keyname       // Organization user organization ID
) async {
  // Validate input parameters
  if (loggedInUserEmail.isEmpty) {
    return {
      'success': false,
      'message': 'Logged-in user email is required',
    };
  }

  isLoading = true;
  notifyListeners();

  try {
    // Prepare data for the API call with only the required parameters
    final requestData = {
      'email': loggedInUserEmail,
      'org_slug': orgSlug,
      'org_role_id': orgRoleId,
      'org_user_id': orgUserId,
      'org_user_org_id': orgUserorgId,
      'key_name': keyname,
    };

    // Make the API call using the ApiService
    final response = await api.generatekey(requestData);

    // Check the response status code
  if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      print('Response Data generate key: $responseData'); // Debugging
      return {
        'success': true,
        'response': responseData['response'], // Make sure this matches your backend response
        'message': responseData['message'] ?? 'Key generated successfully',
      };
    } else {
      final responseData = jsonDecode(response.body);
      return {
        'success': false,
        'message': responseData['message'] ?? 'Failed to generate key',
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'An error occurred: ${e.toString()}',
    };
  } finally {
    isLoading = false;
    notifyListeners();
  }
}

Future<Map<String, dynamic>> updateEmail(
    String? loggedInUserEmail, // Email of the logged-in user
    String email,               // Updated email
    String phoneNumber,         // Updated phone number
    String password,            // Updated password
    String passwordHint,        // Updated password hint
    String accountRecovery,      // Updated account recovery info
    String orgSlug,             // Organization slug
    String id,                  // ID of the email record to update
    String orgRoleId,           // Organization role ID
    String orgUserId,           // Organization user ID
    String orgUserorgId,        // Organization user organization ID
) async {
    // Validate input parameters
    if (loggedInUserEmail == null || loggedInUserEmail.isEmpty) {
        return {
            'success': false,
            'message': 'Logged-in user email is required',
        };
    }
    if (email.isEmpty) {
        return {
            'success': false,
            'message': 'Email is required',
        };
    }
    if (phoneNumber.isEmpty) {
        return {
            'success': false,
            'message': 'Phone number is required',
        };
    }
    
    isLoading = true;
    notifyListeners();

    try {
        // Prepare data for the API call
        final requestData = {
            'email': loggedInUserEmail,
            'email_id': id, // ID of the email being updated
            'updated_email': email,
            'phone_number': phoneNumber,
            'password': password,
            'password_hint': passwordHint,
            'account_recovery': accountRecovery,
            'org_slug': orgSlug,
            'org_role_id': orgRoleId,
            'org_user_id': orgUserId,
            'org_user_org_id': orgUserorgId,
        };

        // Make the API call using the ApiService
        final response = await api.updateEmail(requestData);

        // Check the response status code
        if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            return {
                'success': true,
                'message': responseData['message'] ?? 'Email updated successfully',
            };
        } else {
            final responseData = jsonDecode(response.body);
            return {
                'success': false,
                'message': responseData['message'] ?? 'Failed to update email',
            };
        }
    } catch (e) {
        return {
            'success': false,
            'message': 'An error occurred: ${e.toString()}',
        };
    } finally {
        isLoading = false;
        notifyListeners();
    }
}

Future<Map<String, dynamic>> createGuestMessage(
      String? loggedInUserEmail, String title, String url, String orgSlug, String orgRoleId, String orgUserId, String orgUserorgId) async {
    if (loggedInUserEmail == null || loggedInUserEmail.isEmpty) {
      return {
        'success': false,
        'message': 'Logged-in user email is required',
      };
    }
    if (title.isEmpty) {
      return {
        'success': false,
        'message': 'Title is required',
      };
    }
    if (url.isEmpty) {
      return {
        'success': false,
        'message': 'URL is required',
      };
    }

    isLoading = true;
    notifyListeners();

    try {
      // Prepare data for the API call
      final requestData = {
        'email': loggedInUserEmail,
        'title': title,
        'url': url,
        'org_slug': orgSlug,
        'org_role_id': orgRoleId,
        'org_user_id': orgUserId,
        'org_user_org_id': orgUserorgId,
      };

      // Make the API call using the ApiService
      final response = await api.createGuestMessage(requestData);

      // Check the response status code
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'message': responseData['message'] ?? 'Guest message created successfully',
        };
      } else {
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to create guest message',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> updateGuestMessage(
      String? loggedInUserEmail, String title, String url, String orgSlug, String id, String orgRoleId, String orgUserId, String orgUserorgId) async {
    if (loggedInUserEmail == null || loggedInUserEmail.isEmpty) {
      return {
        'success': false,
        'message': 'Logged-in user email is required',
      };
    }
    if (title.isEmpty) {
      return {
        'success': false,
        'message': 'Title is required',
      };
    }
    if (url.isEmpty) {
      return {
        'success': false,
        'message': 'URL is required',
      };
    }

    isLoading = true;
    notifyListeners();

    try {
      // Prepare data for the API call
      final requestData = {
        'email': loggedInUserEmail,
        'title': title,
        'url': url,
        'org_slug': orgSlug,
        'message_id': id, // ID of the message being updated
        'org_role_id': orgRoleId,
        'org_user_id': orgUserId,
        'org_user_org_id': orgUserorgId,
      };

      // Make the API call using the ApiService
      final response = await api.updateGuestMessage(requestData);

      // Check the response status code
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'message': responseData['message'] ?? 'Guest message updated successfully',
        };
      } else {
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to update guest message',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

Future<Map<String, dynamic>> createPhone(
    String? loggedInUserEmail, // Email of the logged-in user
    String phone,               // Phone number to be created
    String carrier,             // Carrier for the phone
    String owner,               // Owner of the phone
    String status,              // Status of the phone
    String lastUsed,            // Last used date
    String lastRecharge,        // Last recharge date
    String orgSlug,             // Organization slug
    String orgRoleId,           // Organization role ID
    String orgUserId,           // Organization user ID
    String orgUserorgId, 
    String country, 
          // Organization user organization ID
) async {
    // Validate input parameters
    if (loggedInUserEmail == null || loggedInUserEmail.isEmpty) {
        return {
            'success': false,
            'message': 'Logged-in user email is required',
        };
    }
    if (phone.isEmpty) {
        return {
            'success': false,
            'message': 'Phone number is required',
        };
    }
    
    isLoading = true;
    notifyListeners();

    try {
        // Prepare data for the API call
        final requestData = {
            'email': loggedInUserEmail,
            'phone': phone,
            'carrier': carrier,
            'owner': owner,
            'status': status,
            'last_used': lastUsed,
            'last_recharged': lastRecharge,
            'org_slug': orgSlug,
            'org_role_id': orgRoleId,
            'org_user_id': orgUserId,
            'org_user_org_id': orgUserorgId,
             'country': country,
        };

        // Make the API call using the ApiService
        final response = await api.createPhone(requestData);

        // Check the response status code
        if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            return {
                'success': true,
                'message': responseData['message'] ?? 'Phone created successfully',
            };
        } else {
            final responseData = jsonDecode(response.body);
            return {
                'success': false,
                'message': responseData['message'] ?? 'Failed to create phone',
            };
        }
    } catch (e) {
        return {
            'success': false,
            'message': 'An error occurred: ${e.toString()}',
        };
    } finally {
        isLoading = false;
        notifyListeners();
    }
}

Future<Map<String, dynamic>> updatePhone(
    String? loggedInUserEmail, // Email of the logged-in user
    String phone,               // Updated phone number
    String carrier,             // Updated carrier
    String owner,               // Updated owner
    String status,              // Updated status
    String lastUsed,            // Updated last used date
    String lastRecharge,        // Updated last recharge date
    String orgSlug,             // Organization slug
    String id,                  // ID of the phone record to update
    String orgRoleId,           // Organization role ID
    String orgUserId,           // Organization user ID
    String orgUserorgId,  
     String country, 
        // Organization user organization ID
) async {
    // Validate input parameters
    if (loggedInUserEmail == null || loggedInUserEmail.isEmpty) {
        return {
            'success': false,
            'message': 'Logged-in user email is required',
        };
    }
    if (phone.isEmpty) {
        return {
            'success': false,
            'message': 'Phone number is required',
        };
    }
    
    isLoading = true;
    notifyListeners();

    try {
        // Prepare data for the API call
        final requestData = {
            'email': loggedInUserEmail,
            'phone': phone,
            'carrier': carrier,
            'owner': owner,
            'status': status,
            'last_used': lastUsed,
            'last_recharged': lastRecharge,
            'org_slug': orgSlug,
            'phone_id': id, // ID of the phone being updated
            'org_role_id': orgRoleId,
            'org_user_id': orgUserId,
            'org_user_org_id': orgUserorgId,
              'country': country,
        };
    print('Request Data: $requestData');
        // Make the API call using the ApiService
        final response = await api.updatePhone(requestData);

        // Check the response status code
        if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            return {
                'success': true,
                'message': responseData['message'] ?? 'Phone updated successfully',
            };
        } else {
            final responseData = jsonDecode(response.body);
            return {
                'success': false,
                'message': responseData['message'] ?? 'Failed to update phone',
            };
        }
    } catch (e) {
        return {
            'success': false,
            'message': 'An error occurred: ${e.toString()}',
        };
    } finally {
        isLoading = false;
        notifyListeners();
    }
}

 Future<void> getTaskboard(String email, String orgSlug, String orgRoleId, String orgUserId, String orgUserorgId) async {
    isLoading = true;
    notifyListeners();
    try {
      // API call to fetch projects
  List<TaskBoard> taskboards  = await api.fetchTaskboard(email, orgSlug, orgRoleId, orgUserId, orgUserorgId);
      taskboards.sort((a, b) => b.id.compareTo(a.id));
      my_taskboard = taskboards; 
    
    print(my_taskboard);

    } catch (error) {
      print("Error fetching projects: $error");
      my_taskboard = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
    Future<void> getIntervaltask(String email, String orgSlug, String orgRoleId, String orgUserId, String orgUserorgId) async {
    isLoading = true;
    notifyListeners();
    try {
      // API call to fetch projects
  List<IntervalTask> interval_task  = await api.fetchIntervaltask(email, orgSlug, orgRoleId, orgUserId, orgUserorgId);

    interval_task.sort((a, b) => b.id.compareTo(a.id));
      my_intervaltask = interval_task;

         my_intervaltaskfilter = interval_task.where((task) {
      // Uncomment and modify the filter condition as needed
      // return task.taskFreq != null && task.taskFreq!.toLowerCase().contains("hourly");
      return task.taskFreq != null && task.taskFreq!.toLowerCase().contains("hourly"); // replace 'your_filter_condition' with your desired condition
    }).toList();
    } catch (error) {
      print("Error fetching projects: $error");
      my_intervaltask = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  String generateOrderId() {
  int timestamp = DateTime.now().millisecondsSinceEpoch; // Current timestamp
  int randomNumber = Random().nextInt(100000); // Random number up to 5 digits
  return 'ORD-$timestamp-$randomNumber'; // Concatenate to form order ID
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
