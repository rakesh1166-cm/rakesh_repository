import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screen/Auth/loginscreen.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/view_modal/Login_view_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application_1/Screen/layout/mixins.dart';
import 'package:flutter_application_1/view_modal/influencer_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  final String userEmail;
  ProfileScreen({required this.userEmail});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with NavigationMixin {
  bool _isLoggedIn = false;
  String? _email;
  bool _isLoading = true;
  File? _selectedImage;  // Store selected image from gallery

  @override
  void initState() {
    super.initState();
    _checkLoginStatusAndFetchData();
  }

  Future<void> _checkLoginStatusAndFetchData() async {
    final secureStorage = FlutterSecureStorage();
    String? email = await secureStorage.read(key: 'email');
    String? password = await secureStorage.read(key: 'password');

    if (widget.userEmail.isNotEmpty && widget.userEmail != email) {
      if (email != null && password != null) {
        setState(() {
          _isLoggedIn = true;
          _email = email;
        });
      }
      await Provider.of<InfluencerViewModel>(context, listen: false).fetchProfiles(widget.userEmail);
    } else if (email != null && password != null) {
      setState(() {
        _isLoggedIn = true;
        _email = email;
      });
      await Provider.of<InfluencerViewModel>(context, listen: false).fetchProfiles(email);
    }

    setState(() {
      _isLoading = false;
    });
  }

Future<void> _pickImage() async {
  if (!_isLoggedIn || widget.userEmail != _email) {
    return; // Return early if the condition is not met
  }

  final ImagePicker _picker = ImagePicker();
  final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);

  if (pickedImage != null) {
    setState(() {
      _selectedImage = File(pickedImage.path);
    });

    // Call uploadProfileImage using the view model
    await Provider.of<InfluencerViewModel>(context, listen: false)
        .uploadProfileImage(_selectedImage!, widget.userEmail);
  }
}


 Future<Map<String, String?>> _getCredentials() async {
    final secureStorage = FlutterSecureStorage();
    String? email = await secureStorage.read(key: 'email');
    String? password = await secureStorage.read(key: 'password');
    return {'email': email, 'password': password};
  }


  void _showUpdatePasswordSheet(BuildContext context) async {
    Map<String, String?> credentials = await _getCredentials();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: UpdatePasswordForm(
            initialPassword: credentials['password'],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final influencerViewModel = Provider.of<InfluencerViewModel>(context);
    final fetchprofile = influencerViewModel.fetchprofile;

    return buildBaseScreen(
      currentIndex: 0,
      title: 'Profile',
      body: RefreshIndicator(
        onRefresh: () async {
          if (_email != null) {
            await influencerViewModel.fetchProfiles(_email!);
          } else if (widget.userEmail.isNotEmpty) {
            await influencerViewModel.fetchProfiles(widget.userEmail);
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 400,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Stack(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: _pickImage, // Trigger image picker when avatar is tapped
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      width: 80,  // Adjusted width
                                      height: 80, // Adjusted height
                                      child: _selectedImage != null
                                          ? Image.file(
                                              _selectedImage!,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              fetchprofile?.filePic != null
                                                  ? 'https://www.wizbrand.com/storage/images/' + fetchprofile!.filePic.toString()
                                                  : "https://www.wizbrand.com/assets/images/users/default.png",
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Image.asset(
                                                  'assets/icon/default.png',
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                            ),
                                    ),
                                  ),
                                ),
                                 if (_isLoggedIn && widget.userEmail.isNotEmpty && widget.userEmail == _email)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: _pickImage, // Same action for picking image
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: EdgeInsets.all(4),
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_isLoggedIn && widget.userEmail.isNotEmpty && widget.userEmail == _email)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              child: ElevatedButton(
                                onPressed: () => _showUpdatePasswordSheet(context),
                                child: Text('Update Password'),
                              ),
                            ),
                                Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _formatUserName(fetchprofile?.userName ?? 'Not Available'),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            if (_isLoggedIn && widget.userEmail.isNotEmpty && widget.userEmail == _email)
                          Text(
                            widget.userEmail,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              '${fetchprofile?.countryName ?? 'Not Available'} / ${fetchprofile?.stateName ?? 'Not Available'} / ${fetchprofile?.cityName ?? 'Not Available'}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                           if (_isLoggedIn && widget.userEmail.isNotEmpty && widget.userEmail == _email)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              fetchprofile?.mobile ?? 'Not Available',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                             Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              fetchprofile?.digitalMarketer ?? 'Not Available',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                   Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  child: _buildBioText(context, fetchprofile?.bio ?? 'Not Available'),
),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          TabBar(
                            labelColor: Colors.black,
                            indicatorColor: Colors.blue,
                            tabs: [
                              Tab(text: 'Social URL'),
                              Tab(text: 'Social Price'),
                            ],
                          ),
                          Container(
                            height: 300,
                            child: TabBarView(
                              children: [
                                SocialUrlTab(socialUrls: fetchprofile?.socialSite ?? '{}'),
                                SocialPriceTab(socialPrices: fetchprofile?.socialPrice ?? '{}', isLoggedIn: _isLoggedIn),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
Widget _buildBioText(BuildContext context, String bio) {
  if (bio.length <= 30) {
    // Display the full bio if it's 30 characters or less
    return Text(
      bio,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.grey[700]),
    );
  } else {
    // Display truncated bio with "Read More" appended, and make it clickable
    return GestureDetector(
      onTap: () => _showFullBioDialog(context, bio), // Show full bio in dialog on tap
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: bio.substring(0, 30), // Show only the first 30 characters
              style: TextStyle(color: Colors.grey[700]),
            ),
            TextSpan(
              text: " read more", // Append "Read More" text
              style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ],
        ),
      ),
    );
  }
}
void _showFullBioDialog(BuildContext context, String bio) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Detail Bio'),
        content: SingleChildScrollView(
          child: Text(bio),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Close'),
          ),
        ],
      );
    },
  );
}
class UpdatePasswordForm extends StatefulWidget {
  final String? initialPassword;

  UpdatePasswordForm({this.initialPassword});

  @override
  _UpdatePasswordFormState createState() => _UpdatePasswordFormState();
}

class _UpdatePasswordFormState extends State<UpdatePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
 bool _obscurePassword = true; // Make this a state variable
 bool _obscurePasswords = true; // Make this a state variable
 
  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController(text: widget.initialPassword);
    _confirmPasswordController = TextEditingController(text: widget.initialPassword);
  }

  Future<void> _updatePassword() async {
    if (_formKey.currentState!.validate()) {
      final secureStorage = FlutterSecureStorage();
      String? email = await secureStorage.read(key: 'email');

      if (email != null) {
        final influencerViewModel = Provider.of<InfluencerViewModel>(context, listen: false);
        await influencerViewModel.updatePassword(
          email,
          _passwordController.text,
          _confirmPasswordController.text,
        );
       final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    loginViewModel.logout(context).then((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
      }
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

           
 TextFormField(
  controller: _passwordController,
  onChanged: (value) {
    print("Password value: $value"); // Confirm controller updates with user input
    setState(() {}); // Rebuild the UI if necessary
  },
  decoration: InputDecoration(
    labelText: 'Password',
    suffixIcon: IconButton(
      icon: Icon(
        _obscurePassword ? Icons.visibility_off : Icons.visibility,
      ),
      onPressed: () {
        setState(() {
          _obscurePassword = !_obscurePassword; // Toggle visibility
        });
      },
    ),
  ),
  obscureText: _obscurePassword, // Hide/show password text
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 7) {
      return 'Password must be at least 7 characters long';
    }
    return null;
  },
),

TextFormField(
  controller: _confirmPasswordController,
  onChanged: (value) {
    print("Confirm Password value: $value"); // Debugging
    setState(() {}); // Optional UI updates
  },
  decoration: InputDecoration(
    labelText: 'Confirm Password',
    suffixIcon: IconButton(
      icon: Icon(
        _obscurePasswords ? Icons.visibility_off : Icons.visibility,
      ),
      onPressed: () {
        setState(() {
          _obscurePasswords = !_obscurePasswords; // Toggle visibility
        });
      },
    ),
  ),
  obscureText: _obscurePasswords,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    } 
    else if (value.length < 7) {
      return 'Password must be at least 6 characters long';
    }else if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  },
),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updatePassword,
              child: Text('Update Password'),
            ),
          ],
        ),
      ),
    );
  }
}

class SocialUrlTab extends StatelessWidget {
  final String socialUrls;

  SocialUrlTab({required this.socialUrls});

  @override
  Widget build(BuildContext context) {
    final influencerViewModel = Provider.of<InfluencerViewModel>(context);
    Map<String, String> socialUrlMap = {};
    if (socialUrls.isNotEmpty && jsonDecode(socialUrls).isNotEmpty) {
      Map<String, dynamic> decodedUrls = jsonDecode(socialUrls);
      decodedUrls.forEach((key, value) {
        socialUrlMap[key] = value.toString();
      });
    } else {
      socialUrlMap = {
        'Facebook': 'Not Available URL',
        'Twitter': 'Not Available URL',
        'Youtube': 'Not Available URL',
        'Wordpress': 'Not Available URL',
        'Tumblr': 'Not Available URL',
        'Instagram': 'Not Available URL',
        'Quora': 'Not Available URL',
        'Pinterest': 'Not Available URL',
        'Reddit': 'Not Available URL',
      };
    }
    return ListView(
      children: socialUrlMap.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Icon(
                influencerViewModel.getSocialIcon(entry.key),
                color: influencerViewModel.getSocialIconColor(entry.key),
              ),
              SizedBox(width: 8),
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (entry.value.isNotEmpty && entry.value != 'null' && entry.value != 'Not Available URL') {
                      _launchURL(entry.value);
                    }
                  },
                  child: Text(
                    '${entry.key}: ${entry.value.isEmpty || entry.value == 'null' ? 'Not Available' : entry.value}',
                    style: TextStyle(
                      fontSize: 16,
                      color: entry.value.isNotEmpty && entry.value != 'null' && entry.value != 'Not Available URL'
                          ? Colors.blue
                          : Colors.black,
                      decoration: entry.value.isNotEmpty && entry.value != 'null' && entry.value != 'Not Available URL'
                          ? TextDecoration.underline
                          : TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class SocialPriceTab extends StatelessWidget {
  final String socialPrices;
  final bool isLoggedIn;

  SocialPriceTab({required this.socialPrices, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    final influencerViewModel = Provider.of<InfluencerViewModel>(context);
    Map<String, String> socialPriceMap = {};
    if (socialPrices.isNotEmpty && jsonDecode(socialPrices).isNotEmpty) {
      Map<String, dynamic> decodedPrices = jsonDecode(socialPrices);
      decodedPrices.forEach((key, value) {
        socialPriceMap[key] = value.toString();
      });
    } else {
      socialPriceMap = {
        'Facebook': 'Not Available Price',
        'Twitter': 'Not Available Price',
        'Youtube': 'Not Available Price',
        'Wordpress': 'Not Available Price',
        'Tumblr': 'Not Available Price',
        'Instagram': 'Not Available Price',
        'Quora': 'Not Available Price',
        'Pinterest': 'Not Available Price',
        'Reddit': 'Not Available Price',
      };
    }
    return ListView(
      children: socialPriceMap.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Icon(
                influencerViewModel.getSocialIcon(entry.key),
                color: influencerViewModel.getSocialIconColor(entry.key),
              ),
              SizedBox(width: 8),
              
Expanded(
  child: RichText(
    text: TextSpan(
      style: TextStyle(fontSize: 16, color: Colors.black), // default style
      children: [
        TextSpan(text: '${entry.key}: '),
        isLoggedIn
            ? TextSpan(
                text: entry.value.isEmpty || entry.value == 'null' ? 'Not Available' : entry.value,
              )
            : WidgetSpan(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red, // Set background color for "Please login"
                      borderRadius: BorderRadius.circular(5), // Add border radius
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Add padding for better appearance
                    child: Text(
                      'Please login',
                      style: TextStyle(
                        color: Colors.white, // Set text color to white
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
      ],
    ),
  ),
),
            ],
          ),
        );
      }).toList(),
    );
  }  
}

String _formatUserName(String userName) {
  if (userName == 'Not Available') return userName;

  return userName
      .split('-') // Split by dash
      .map((word) => word[0].toUpperCase() + word.substring(1)) // Capitalize each word
      .join(' '); // Join the words back with spaces
}