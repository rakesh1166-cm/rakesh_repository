import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand/Screen/Influencer/createrating.dart';
import 'package:wizbrand/Screen/layout/drawer.dart';
import 'package:wizbrand/Screen/layout/mixins.dart';
import 'package:wizbrand/Screen/layout/rolemixins.dart';
import 'package:wizbrand/model/rating.dart';
import 'package:wizbrand/view_modal/organization_view_model.dart';

class TeamRating extends StatefulWidget {
  final String orgSlug;

  TeamRating({required this.orgSlug});

  @override
  _TeamRatingState createState() => _TeamRatingState();
}

class _TeamRatingState extends State<TeamRating> with DrawerMixin, RoleMixin, NavigationMixin {
  String _userRole = ''; // Variable to store the role for AppBar
   String _userName = ''; // Variable to store the user's name

TextEditingController _searchController = TextEditingController();
List<Rating> _filteredRatings = []; // List to hold filtered ratings
  @override
  void initState() {
    super.initState();
    _fetchData(); // Fetch organization data when the screen initializes
  }

  Future<void> _fetchData() async {
    final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
    final credentials = await _getCredentials();
    final email = credentials['email'];
    final orgSlug = widget.orgSlug;
    final secureStorage = FlutterSecureStorage();
    final orgRoleId = await secureStorage.read(key: 'orgRoleId');
    final orgUserId = await secureStorage.read(key: 'orgUserId');
    final orgUserorgId = await secureStorage.read(key: 'orgUserorgId');  
final username = await secureStorage.read(key: 'userName');

 setState(() {
    _userRole = determineUserRole(orgRoleId);
    _userName = username ?? 'User'; // Set the user name or default to 'User'
    print("my role is $_userRole");
  });

   if (email != null && orgSlug.isNotEmpty) {
      await organizationViewModel.getRating(email, orgSlug, orgRoleId.toString(), orgUserId.toString(), orgUserorgId.toString());
      _filteredRatings = organizationViewModel.my_team; // Initialize with full data
    }

    setState(() {}); // Rebuild the widget after fetching data
  }

  Future<Map<String, String?>> _getCredentials() async {
    final secureStorage = FlutterSecureStorage();
    String? email = await secureStorage.read(key: 'email');
    String? password = await secureStorage.read(key: 'password');
    return {'email': email, 'password': password};
  }
void _filterRatings(String query) {
    final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
    final allRatings = organizationViewModel.my_team;

    setState(() {
      _filteredRatings = allRatings.where((rating) {
        final nameLower = rating.ratingUserName?.toLowerCase() ?? '';
        final monthLower = rating.month?.toLowerCase() ?? '';
        final queryLower = query.toLowerCase();

        return nameLower.contains(queryLower) || 
               monthLower.contains(queryLower); // You can add other fields to filter by as needed
      }).toList();
    });
}
  @override
  Widget build(BuildContext context) {
    final organizationViewModel = Provider.of<OrganizationViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
       '$_userName - $_userRole', // Display role dynamically in the AppBar
          style: TextStyle(color: Colors.white),
        ),
        actions: buildAppBarActions(context),
      ),
      drawer: buildDrawer(context, orgSlug: widget.orgSlug),
      body: organizationViewModel.isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                buildBaseScreen(
                  body: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                         if (_userRole != 'User')
                        ElevatedButton(
                          onPressed: () {
                            _showCreateRatingDialog(context);
                          },
                          child: Text('Add New Rating'),
                        ),
                        SizedBox(height: 20),
                         Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search by Team Member Name or Month',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      _filterRatings(value); // Call filter method on text change
                    },
                  ),
                ),
SingleChildScrollView(
  scrollDirection: Axis.horizontal, // Allow horizontal scrolling
  child: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: _filteredRatings.map((rating) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0), // Add some horizontal spacing
        child: GestureDetector(
          onTap: () {
            _showDetailsDialog(context, rating.ratingUserName!); // Call the details dialog
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Add padding for the pill shape
            decoration: BoxDecoration(
              color: Colors.purple, // Background color
              borderRadius: BorderRadius.circular(20), // Rounded corners
            ),
            child: Row(
              children: [
                Text(
                  rating.ratingUserName ?? 'No Name',
                  style: TextStyle(color: Colors.white), // Text color
                ),
                SizedBox(width: 5), // Space between text and icon
                Icon(
                  Icons.visibility, // Eye icon
                  color: Colors.white, // Icon color
                  size: 16, // Icon size
                ),
              ],
            ),
          ),
        ),
      );
    }).toList(),
  ),
),  Expanded(
  child: _filteredRatings.isEmpty // Check filtered ratings
      ? Center(
          child: Text('No ratings found for this team'),
        )
      : ListView.builder(
          itemCount: _filteredRatings.length,
          itemBuilder: (context, index) {
            final rating = _filteredRatings[index];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.grey[300]!),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ID
                    Text(
                      'Id: ${index + 1}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),

                    // Team Member Name
                    GestureDetector(
                                              onTap: () {
                                            _showDetailsDialog(context, rating.ratingUserName!); // Cal
                                              },
                                              child: Text(
                                                'Name: ${rating.ratingUserName ?? 'No Name'}',
                                                style: TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline),
                                              ),
                                            ),
                    SizedBox(height: 8),

                    // Month
                    Text(
                      'Month: ${rating.month ?? 'No Month'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),

                    // Week
                    Text(
                      'Week: ${rating.week ?? 'No Week'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),

                    // Year
                    Text(
                      'Year: ${rating.year ?? 'No Year'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),

                    // Rating
                    Text(
                      'Rating: ${rating.rating ?? 'No Rating'}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),

                    // Row for edit and delete icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                         if (_userRole != 'User') 
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _showEditRatingDialog(context, rating);
                          },
                          tooltip: 'Edit Rating',
                        ),
                         if (_userRole != 'Manager' && _userRole != 'User') 
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showDeleteRatingDialog(context, rating);
                          },
                          tooltip: 'Delete Rating',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
),
                      ],
                    ),
                  ),
                  currentIndex: 0, // Set an appropriate index
            title: 'Team Rating', // Set the title as needed
                ),
              ],
            ),
    );
  }
void _showDetailsDialog(BuildContext context, String userName) async {
  final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);

  // Fetch the ratings for the selected team member
  final userRatings = organizationViewModel.my_team
      .where((rating) => rating.ratingUserName == userName)
      .toList();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('$userName Ratings'),
        content: Container(
          width: double.maxFinite, // Make the dialog width flexible
          constraints: BoxConstraints(maxHeight: 400), // Set a max height to prevent overflow
          child: SingleChildScrollView( // Allow scrolling if content is too long
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: userRatings.map((rating) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0), // Add spacing between ratings
                  child: Text(
                    'Rating: ${rating.rating ?? 'No Rating'}\n'
                    'Month: ${rating.month ?? 'No Month'}\n'
                    'Week: ${rating.week ?? 'No Week'}\n'
                    'Year: ${rating.year ?? 'No Year'}\n',
                    style: TextStyle(fontSize: 14), // Adjust font size for better readability
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        actions: [
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
  void _showCreateRatingDialog(BuildContext context) async {
    final secureStorage = FlutterSecureStorage();
    final orgRoleId = await secureStorage.read(key: 'orgRoleId');
    final orgUserId = await secureStorage.read(key: 'orgUserId');
    final orgUserorgId = await secureStorage.read(key: 'orgUserorgId');
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateRatingDialog(
          orgSlug: widget.orgSlug,
          orgRoleId: orgRoleId!,
          orgUserId: orgUserId!,
          orgUserorgId: orgUserorgId!,
        );
      },
    );
  }

void _showEditRatingDialog(BuildContext context, dynamic ratingData) async {
  final secureStorage = FlutterSecureStorage();
  final orgRoleId = await secureStorage.read(key: 'orgRoleId');
  final orgUserId = await secureStorage.read(key: 'orgUserId');
  final orgUserorgId = await secureStorage.read(key: 'orgUserorgId');

  print("Inside edit rating dialog");

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return CreateRatingDialog(
        orgSlug: widget.orgSlug,                          // Organization slug
        orgRoleId: orgRoleId!,                            // Organization role ID
        orgUserId: orgUserId!,                            // Organization user ID
        orgUserorgId: orgUserorgId!,                      // Organization user organization ID       
        ratingId: ratingData.id.toString(),               // Convert Rating ID to String
        ratingUserName: ratingData.ratingUserName,        // Team member's name
        managerid: ratingData.userId?.toString() ?? '',  
        week: ratingData.week?.toString() ?? '',          // Convert week to String (if it's an int)
        month: ratingData.month?.toString() ?? '',        // Convert month to String (if necessary)
        year: ratingData.year?.toString() ?? '',          // Convert year to String (if necessary)
        ratingValue: ratingData.rating?.toString() ?? '', // Convert rating value to String (if necessary)
      );
    },
  );
}

  void _showDeleteRatingDialog(BuildContext context, rating) async {
    final confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Rating'),
          content: Text('Are you sure you want to delete this rating?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel action
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm action
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      final organizationViewModel = Provider.of<OrganizationViewModel>(context, listen: false);
      // Implement the deletion logic here
await organizationViewModel.deleteRating(rating.id.toString()); 
      _fetchData(); // Optionally, refresh the data after deletion
    }
  }

Widget buildBaseScreen({required Widget body, required int currentIndex, required String title}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
    ),
    child: Column(
      children: [
        // Optionally, add a title if needed
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(child: body),
      ],
    ),
  );
}
}