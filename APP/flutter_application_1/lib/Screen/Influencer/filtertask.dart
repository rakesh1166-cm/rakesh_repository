import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screen/layout/mixins.dart';
import 'package:flutter_application_1/Screen/layout/influencermixins.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import '../../view_modal/influencer_view_model.dart';

class FilterTask extends StatefulWidget {
  final String email;

  FilterTask({required this.email});

  @override
  _FilterTaskState createState() => _FilterTaskState();
}

class _FilterTaskState extends State<FilterTask> with NavigationMixin, InfluencerListMixin {
  bool _isLoggedIn = false;
  String? _email;
  String _searchQuery = '';
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _email = widget.email;
    Future.microtask(() async {
      Map<String, String?> credentials = await _getCredentials();
      String? email = credentials['email'];
      String? password = credentials['password'];
      if (email != null && password != null) {
        setState(() {
          _isLoggedIn = true;
          _email = email;
        });
        Provider.of<InfluencerViewModel>(context, listen: false).fetchfilterTask(email);
      }
    });
  }

  Future<Map<String, String?>> _getCredentials() async {
    final secureStorage = FlutterSecureStorage();
    String? email = await secureStorage.read(key: 'email');
    String? password = await secureStorage.read(key: 'password');
    return {'email': email, 'password': password};
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<InfluencerViewModel>(context);
    final fetchtask = viewModel.fetchtask;

    // Define the status groups with custom logic
    final statusGroups = {
      'All': (task) => true, // No filter
      'completed': (task) => task.status == 'completed' && task.publisherStatus == 'approve',
     'Pending': (task) => 
      ['Pending', 'todo', 'onhold', 'inprogress'].contains(task.status) ||
      (task.status == 'completed' && task.publisherStatus != 'approve'),
      'reject': (task) => task.status == 'reject',
      'not approved': (task) => task.status == 'not approved',
    };

    // Filter the tasks based on the search query and selected filter
    final filteredTasks = fetchtask.where((task) {
      final query = _searchQuery.toLowerCase();
      final matchesSearchQuery = (task.taskTitle?.toLowerCase().contains(query) ?? false) ||
          (task.orderCartId?.toLowerCase().contains(query) ?? false) ||
          (task.userName?.toLowerCase().contains(query) ?? false) ||
          (task.status?.toLowerCase().contains(query) ?? false) ||
          (task.payInfluencerName?.toLowerCase().contains(query) ?? false) ||
          (task.orderPayDate?.toLowerCase().contains(query) ?? false);

      final matchesFilter = statusGroups[_selectedFilter]?.call(task) ?? false;

      return matchesSearchQuery && matchesFilter;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Publishers'),
      ),
      body: buildBaseScreen(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(),
                ),
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterButton('All', 'All'),
                    SizedBox(width: 8),
                    _buildFilterButton('Completed', 'completed'),
                    SizedBox(width: 8),
                    _buildFilterButton('Pending', 'Pending'),
                    SizedBox(width: 8),
                    _buildFilterButton('Rejected', 'reject'),
                    SizedBox(width: 8),
                    _buildFilterButton('Not Approved', 'not approved'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredTasks.isEmpty
                      ? const Center(child: Text('We couldnot find any tasks for your search'))
                      : ListView.builder(
                          itemCount: filteredTasks.length,
                          itemBuilder: (context, index) {
                            final fetchtask = filteredTasks[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              color: Colors.blue.shade100,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16.0),
                                title: Text(
                                  _truncateWithEllipsis(40, fetchtask.taskTitle ?? "No Title"), // Limit to 40 characters
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Publisher Name: ${fetchtask.userName ?? "No Details"}',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    Text(
                                      'Influencer: ${fetchtask.payInfluencerName ?? "No Influencer"}',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    Text(
                                      'Cart Id: ${fetchtask.orderCartId ?? "No Cart id"}',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    Text(
                                      'Status: ${fetchtask.status == 'completed' && fetchtask.publisherStatus != 'approve' ? "Completed w/o approval" : fetchtask.status ?? "No Status"}',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    Text(
                                      'Amount: ${fetchtask.payAmount ?? "Amount"}',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    Text(
                                      'PayDate: ${fetchtask.orderPayDate ?? "PayDate"}',
                                      style: TextStyle(color: Colors.grey[600]),
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
        currentIndex: 0,
        title: 'Filter Task',
      ),
    );
  }

  Widget _buildFilterButton(String displayText, String filterValue) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedFilter = filterValue;
        });
      },
      child: Text(displayText),
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedFilter == filterValue ? Colors.blue : Colors.grey,
      ),
    );
  }

  String _truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff) ? myString : '${myString.substring(0, cutoff)}...';
  }
}