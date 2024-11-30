import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand_influencer/Screen/layout/mixins.dart';
import 'package:wizbrand_influencer/model/mytask.dart';
import 'package:wizbrand_influencer/Screen/Influencer/influencerdetail.dart';
import 'package:wizbrand_influencer/view_modal/influencer_view_model.dart';

class TabDesign extends StatefulWidget {
  @override
  _TabDesignState createState() => _TabDesignState();
}

class _TabDesignState extends State<TabDesign> with SingleTickerProviderStateMixin, NavigationMixin {
  late TabController _tabController;
  bool _isLoggedIn = false;
  String? _email;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // Updated to 4 tabs
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    Map<String, String?> credentials = await _getCredentials();
    String? email = credentials['email'];
    if (email != null) {
      setState(() {
        _isLoggedIn = true;
        _email = email;
      });
      Provider.of<InfluencerViewModel>(context, listen: false).fetchTasks(email);
    }
  }

  Future<Map<String, String?>> _getCredentials() async {
    final secureStorage = FlutterSecureStorage();
    String? email = await secureStorage.read(key: 'email');
    String? password = await secureStorage.read(key: 'password');
    return {'email': email, 'password': password};
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildBaseScreen(
      currentIndex: 0, // Set the appropriate index for the bottom nav bar
      title: 'Task Board',
      body: content(),
    );
  }

  Widget content() {
    return Column(
      children: [
        Container(
          color: Colors.blue, // Background color of the tab bar
          child: Align(
            alignment: Alignment.centerLeft, // Align the tabs to the left
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25), // Creates border radius for the indicator
                color: Colors.white, // Background color of the selected tab
              ),
              tabs: [
                _buildTab('Todo'),
                _buildTab('Onhold'),
                _buildTab('Inprogress'),
                _buildTab('Completed'),
              ],
              labelPadding: EdgeInsets.symmetric(horizontal: 5.0), // Adjusts the space between tabs
              indicatorPadding: EdgeInsets.zero, // Removes padding around the indicator
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              Container(
                color: Colors.yellow[100],
                child: buildTaskList('todo', Colors.yellow[100]!),
              ),
              Container(
                color: Colors.orange[100],
                child: buildTaskList('onhold', Colors.orange[100]!),
              ),
              Container(
                color: Colors.blue[100],
                child: buildTaskList('inprogress', Colors.blue[100]!),
              ),
              Container(
                color: Colors.green[100],
                child: buildTaskList('completed', Colors.green[100]!, showTextField: true),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTab(String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white, width: 2), // Border color matching the background
        color: Color.fromARGB(255, 21, 54, 245), // Tab background color matching the AppBar
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget buildTaskList(String status, Color backgroundColor, {bool showTextField = false}) {
    return Consumer<InfluencerViewModel>(
      builder: (context, viewModel, child) {
        final email = _email;
        if (email == null) {
          return Center(child: CircularProgressIndicator());
        }
        final tasks = viewModel.getTasksByStatus(status, email);
        print("Filtered tasks for status '$status': $tasks");
        if (tasks.isEmpty) {
          return Center(child: Text('No tasks available'));
        }
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            print("Task: $task");
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: backgroundColor, // Use the background color passed to the function
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [                   

                      Text(
                      'Task: task_${task.id}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Publisher: ${task.userName}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text('Task: ${task.taskTitle}'),
                    SizedBox(height: 5),
                  
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (!showTextField)
                          DropdownButton<String>(
                            value: task.status,
                            onChanged: (value) {
                              if (value != null) {
                                if (value == 'completed') {
                                  _showBottomSheet(context, task.id, email);
                                } else {
                                  Provider.of<InfluencerViewModel>(context, listen: false)
                                      .updateTaskStatus(task.id, value, email);
                                }
                              }
                            },
                            items: ['todo', 'inprogress', 'onhold', 'completed']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value[0].toUpperCase() + value.substring(1)),
                              );
                            }).toList(),
                          ),
                        IconButton(
                          icon: Icon(Icons.visibility),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InfluencerDetailScreen(order: task),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

void _showBottomSheet(BuildContext context, int taskId, String email) {
  final workUrlController = TextEditingController();
  final descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return AnimatedPadding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: workUrlController,
                    decoration: InputDecoration(
                      labelText: 'Work URL',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Work URL is required';
                      }

                      // URL validation for http://, https://, or plain http
                      final urlPattern = r'^(http|https):\/\/?([a-zA-Z\d-]+\.)*[a-zA-Z\d-]+\.[a-zA-Z]{2,}(:\d+)?(\/[^\s]*)?$';
                      final regExp = RegExp(urlPattern);

                      if (!regExp.hasMatch(value)) {
                        return 'Please enter a valid URL starting with http:// or https://';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Description is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final workUrl = workUrlController.text;
                        final description = descriptionController.text;

                        Provider.of<InfluencerViewModel>(context, listen: false)
                            .updateTaskStatus(taskId, 'completed', email, workUrl: workUrl, description: description);

                        Navigator.pop(context);
                      }
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
}