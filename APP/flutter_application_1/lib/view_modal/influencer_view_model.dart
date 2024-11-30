import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screen/Influencer/Influencerscreen.dart';
import 'package:flutter_application_1/Screen/Influencer/cancelled.dart';
import 'package:flutter_application_1/Screen/Influencer/ordersuccess.dart';
import 'package:flutter_application_1/model/cart.dart';
import 'package:flutter_application_1/model/cartsocial.dart';
import 'package:flutter_application_1/model/currencyupdate.dart';
import 'package:flutter_application_1/model/influencerwork.dart';
import 'package:flutter_application_1/model/order.dart';
import 'package:flutter_application_1/model/profile.dart';
import 'package:paytm/paytm.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
import 'package:flutter_application_1/model/search_influencer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../model/task.dart';
import '../Service/Influencer/influencer_service.dart';
import '../../model/summary.dart';
import 'dart:math';

class InfluencerViewModel extends ChangeNotifier {
  final InfluencerAPI api;
  List<SearchInfluencer> influencers = [];
  
    List<CartSite> cartsocial = [];
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
  InfluencerViewModel(this.api);
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
  String _message = '';
 Map<String, String> socialData = {}; // To store parsed socialsite data
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



  Future<void> updateCurrency(
      String currency, List<String> cartIds, String email) async {
    try {
      var response = await api.updateCurrency(currency, cartIds, email);
      // Log the API response directly
      print("API updateCurrency response: $response");
      // Log individual values
      print("Total Sum: ${response.totalSum}");
      print("GST: ${response.gst}");
      print("Sum GST: ${response.sumGst}");
      // Save the values
      totalSum = response.totalSum;
      gst = response.gst;
      sumGst = response.sumGst;
      cartId = response.cartId;
      this.email = response.email;     
      cartDetail = response.cartDetail;
      this.currency = response.currency;
      proid = response.productid;
      influencername = response.influencername;
      influenceremail = response.influenceremail;
      influnceradminid = response.influenceradmin;
      print("Currency updated successfully");
      await fetchCart(email); // Refresh the cart after currency update
      notifyListeners();
    } catch (e) {
      print("Error updating currency: $e");
    }
  }

Future<void> removeFromCart(String addCartId, String email) async {
  try {
    fetchcart = await api.removeFromCart(addCartId, email);
    print("Item removed from cart successfully");
    await fetchInfluencers(email); // Refresh the cart after removal
    notifyListeners();
  } catch (e) {
    print("Error removing from cart: $e");
  }
}

  Future<void> fetchOrder(String? email) async {
    isLoading = true;
    notifyListeners();
    try {
      taskSummary = await api.fetchOrder(email);
      print("Tasks fetched successfully");
      print(taskSummary);
    } catch (e) {
      print("Error fetching tasks: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


Future<void> uploadProfileImage(File imageFile, String email) async {
  // Check if the file extension is JPG, JPEG, or PNG
  List<String> validExtensions = ['jpg', 'jpeg', 'png'];
  String fileExtension = imageFile.path.split('.').last.toLowerCase();

  if (!validExtensions.contains(fileExtension)) {
    throw Exception('Invalid file format. Please upload a JPG, JPEG, or PNG image.');
  }
  try {
    final response = await api.uploadProfileImage(imageFile, email);
    print('Profile image uploaded successfully');    
    // Optionally, refresh the profile after successful upload
    await fetchProfiles(email);
  } catch (e) {
    print('Error uploading profile image: $e');
  } finally {
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

Future<void> fetchCart(String? email) async {
  isLoading = true;
  notifyListeners();
  print("Fetching task data for email: $email");

  try {
    fetchcart = await api.fetchcart(email);
    // Assuming 'fetchcart' is a List of UserCart objects
    print("Fetched cart data: ${fetchcart.length} items");

    if (fetchcart.isNotEmpty) {
      // Safely parse cartSocials if it's not null
      try {
        socialPrices = jsonDecode(fetchcart.first.cartSocials ?? "{}");
        print(socialPrices);
      } catch (e) {
        print("Error parsing cartSocials: $e");
      }
    }

    print("Tasks fetched successfully");
  } catch (e) {
    print("Error fetching tasks: $e");
  } finally {
    isLoading = false;
    notifyListeners();  // Let the UI know that data fetching is done
  }
}

Future<void> fetchOrders(String? email) async {
  if (email == null || email.isEmpty) {
    print("Error: Email is null or empty");
    return;
  }
  isLoading = true;
  notifyListeners();
  print("Fetching fetchOrders for email: $email");
  try {
    orders = await api.fetchmyOrder(email);
    print("Orders fetched successfully");
  } catch (e) {
    print("Error fetching orders: $e");
  } finally {
    isLoading = false;
    notifyListeners();
  }
}

Future<void> fetchWorkdetail(String? email) async {
  if (email == null || email.isEmpty) {
    print("Error: Email is null or empty");
    return;
  }

  isLoading = true;
  notifyListeners();
  print("Fetching orders for email: $email");
  try {
    fetchwork = await api.fetchmyWork(email);
    print(fetchwork);
    print("fetchWorkdetail fetched successfully");
  } catch (e) {
    print("Error fetching orders: $e");
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
     print("response is here");
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
  Future<void> fetchInfluencersdata(String? email) async {
    isLoading = true;
    notifyListeners();
    print("Fetching task data for email: $email");
    try {
      // await api.fetchTask(email);
      becomeinfluencers = await api.influencerData(email);
      print("Tasks fetched successfully");
      // Update your state if needed, e.g., update influencers list
    } catch (e) {
      print("Error fetching tasks: $e");
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
Future<void> updateTaskWithDetails(int productId, String orderId, String taskTitle, String description, String videoLink,   List<File> images) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await api.updateTaskWithDetails(
        productId: productId,
        orderId: orderId,
        taskTitle: taskTitle,
        description: description,
        videoLink: videoLink,
        imageLinks: images,
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

Future<List<Map<String, dynamic>>?> getOrderDetails(String orderId, String email) async {
  _isLoading = true;
  notifyListeners();

  try {
    final response = await api.orderDetail(orderId, email);
    if (response.statusCode == 200) {
      // Decode the response as a List of Maps
      final List<dynamic> data = json.decode(response.body);

      if (data.isNotEmpty && data[0] is Map<String, dynamic>) {
        // Cast the list to List<Map<String, dynamic>> if the first element is a Map
        List<Map<String, dynamic>> orderDetails = data.cast<Map<String, dynamic>>();
        print("Order details fetched successfully: $orderDetails");
        return orderDetails; // Return the parsed order details
      } else {
        print("Unexpected response format");
        return null; // Return null if the format is unexpected
      }
    } else {
      print("Failed to fetch order details, Status Code: ${response.statusCode}, Body: ${response.body}");
      return null; // Return null in case of failure
    }
  } catch (e) {
    print("Error fetching order details: $e");
    return null; // Return null in case of an error
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

  String generateOrderId() {
  int timestamp = DateTime.now().millisecondsSinceEpoch; // Current timestamp
  int randomNumber = Random().nextInt(100000); // Random number up to 5 digits
  return 'ORD-$timestamp-$randomNumber'; // Concatenate to form order ID
   }

  Future<Map<String, dynamic>> makePayment({
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
    required BuildContext context, // Add context to navigate
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      print('Initiating payment with cartId: $cartId, totalSum: $totalSum');
      String orderId = generateOrderId(); // Generate unique order ID
      String txnToken = await api.generateTransactionTokens(
        orderId: orderId,
        totalSum: totalSum,
        gst: gst,
        sumGst: sumGst,
        cartId: cartId,
        email: email,
        currency: currency,
        proid: proid,
        influencername: influencername,
        influenceremail: influenceremail,
        influnceradminid: influnceradminid,
      );   
      var paytmResponse = await Paytm.payWithPaytm(
        mId: 'COTOCU83816930595730', // Paytm Merchant ID
        orderId: orderId,
        txnToken: txnToken,
        txnAmount: totalSum.toString(),
        callBackUrl: 'https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=$orderId',
        staging: true,
        appInvokeEnabled: true,
      );   
      // Handle the Paytm response inside ViewModel
      if (!paytmResponse['error']) {
        print("Payment successful!");
        // Navigate to the success screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderSuccessScreen(orderId: orderId),
          ),
        );
      } else {      
        // Show a failure dialog
    Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Cancelled(),
          ),
        );
      }
      return {
        'status': 'success',
        'txnToken': txnToken,
        'orderId': orderId,
        'amount': totalSum.toString(),
      };
    } catch (e, stackTrace) {
      print('Error initiating transaction: $e');
      print('StackTrace: $stackTrace');
      return {
        'status': 'error',
        'errorMessage': e.toString(),
      };
    } finally {
      isLoading = false;
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
