import 'package:flutter/material.dart';
import 'package:wizbrand_influencer/Screen/layout/mixins.dart';
import 'package:wizbrand_influencer/Screen/layout/influencermixins.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Import this for date formatting
import 'package:wizbrand_influencer/view_modal/influencer_view_model.dart';

class Influencerwallet extends StatefulWidget {
  @override
  _InfluencerwalletState createState() => _InfluencerwalletState();
}

class _InfluencerwalletState extends State<Influencerwallet> with NavigationMixin, InfluencerListMixin {
  bool _isLoggedIn = false;
  String? _email;
  String _searchQuery = '';
  DateTime? _startDate;
  DateTime? _endDate;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      Map<String, String?> credentials = await _getCredentials();
      String? email = credentials['email'];
      String? password = credentials['password'];
      if (email != null && password != null) {
        setState(() {
          _isLoggedIn = true;
          _email = email;
        });
        Provider.of<InfluencerViewModel>(context, listen: false).fetchfilterwallet(email);
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

    // Filter the tasks based on the search query and date range
 final filteredTasks = fetchtask.where((task) {
      final query = _searchQuery.toLowerCase();
      final taskDate = task.orderPayDate != null ? DateFormat('yyyy-MM-dd').parse(task.orderPayDate!) : null;
      final isWithinDateRange = (_startDate == null || (taskDate != null && !taskDate.isBefore(_startDate!))) &&
                                (_endDate == null || (taskDate != null && !taskDate.isAfter(_endDate!)));
      
      return (
             (task.taskTitle?.toLowerCase().contains(query) ?? false) ||
             (task.orderCartId?.toLowerCase().contains(query) ?? false) ||
             (task.userName?.toLowerCase().contains(query) ?? false) ||
             (task.status?.toLowerCase().contains(query) ?? false) ||
             (task.payInfluencerName?.toLowerCase().contains(query) ?? false) ||
             (task.orderPayDate?.toLowerCase().contains(query) ?? false) ||
             (task.payAmount.toString().contains(query)) ||
            // Add filtering based on task ID
             ('task_${task.id}'.contains(query))
      ) && isWithinDateRange &&
             _isWithinSelectedFilter(taskDate);
    }).toList();

    double totalYearEarnings = _calculateTotalEarnings(fetchtask, 'Year');
    double totalMonthEarnings = _calculateTotalEarnings(fetchtask, 'Month');
    double totalWeekEarnings = _calculateTotalEarnings(fetchtask, 'Week');
    double totalAmount = _calculateTotalAmount(fetchtask);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Influencers'),
      ),
      body: buildBaseScreen(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Total Earnings This Year: $totalYearEarnings'),
                  Text('Month: $totalMonthEarnings'),
                  Text('Week: $totalWeekEarnings'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  _buildFilterButton('All'),
                  SizedBox(width: 8),
                  _buildFilterButton('Week'),
                  SizedBox(width: 8),
                  _buildFilterButton('Month'),
                  SizedBox(width: 8),
                  _buildFilterButton('Year'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Start Date', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)),
                        GestureDetector(
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: _startDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                _startDate = pickedDate;
                              });
                            }
                          },
                          child: AbsorbPointer(
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'yyyy-MM-dd',  // Update the format here
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                              controller: TextEditingController(
                                text: _startDate == null ? '' : DateFormat('yyyy-MM-dd').format(_startDate!),  // Change the format here to 'yyyy-MM-dd'
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('End Date', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)),
                        GestureDetector(
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: _endDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                _endDate = pickedDate;
                              });
                            }
                          },
                          child: AbsorbPointer(
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'yyyy-MM-dd',  // Update the format here
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                              controller: TextEditingController(
                                text: _endDate == null ? '' : DateFormat('yyyy-MM-dd').format(_endDate!),  // Change the format here to 'yyyy-MM-dd'
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Wallet Statement', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                  Text('Total Amount: $totalAmount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                ],
              ),
            ),
            Expanded(
              child: viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredTasks.isEmpty
                      ?  Center(
  child: Card(
    elevation: 4, // Adds shadow to make the card stand out
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10), // Rounded corners, removed 'const'
      side: BorderSide(color: Colors.grey.shade300, width: 2), // Border
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0), // This can remain const
      child: Column(
        mainAxisSize: MainAxisSize.min, // Wrap content size
        children: [
          Text(
            'No Wallet Transactions',
            style: TextStyle(
              fontSize: 18, // Increase font size for better visibility
              fontWeight: FontWeight.bold, // Bold text
            ),
          ),
          SizedBox(height: 10), // Add spacing between the texts
          Text(
            'We couldn\'t find any transactions in your wallet. Please try adjusting your filters or check back later.',
            textAlign: TextAlign.center, // Center align the text
            style: TextStyle(fontSize: 16, color: Colors.grey), // Adjust text style
          ),
        ],
      ),
    ),
  ),
)
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
                                      'Task Id: task_${fetchtask.id ?? "No Details"}',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    Text(
                                      'Publisher Name: ${fetchtask.userName ?? "No Details"}',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  
                                    Text(
                                      'Amount: ${fetchtask.payAmount}',
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
        title: 'Influencer Wallet',
      ),
    );
  }

  Widget _buildFilterButton(String filter) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedFilter = filter;
        });
      },
      child: Text(filter),
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedFilter == filter ? Colors.blue : Colors.grey,
      ),
    );
  }

  bool _isWithinSelectedFilter(DateTime? taskDate) {
    if (taskDate == null) return false;

    final now = DateTime.now();
    switch (_selectedFilter) {
      case 'Week':
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final endOfWeek = now.add(Duration(days: DateTime.daysPerWeek - now.weekday));
        return taskDate.isAfter(startOfWeek) && taskDate.isBefore(endOfWeek.add(Duration(days: 1)));
      case 'Month':
        return taskDate.year == now.year && taskDate.month == now.month;
      case 'Year':
        return taskDate.year == now.year;
      default:
        return true;
    }
  }

  double _calculateTotalEarnings(List fetchtask, String period) {
    final now = DateTime.now();
    double totalEarnings = 0.0;

    for (var task in fetchtask) {
      if (task.orderPayDate != null) {
        final taskDate = DateFormat('yyyy-MM-dd').parse(task.orderPayDate!);
        if (period == 'Week') {
          final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          final endOfWeek = now.add(Duration(days: DateTime.daysPerWeek - now.weekday));
          if (taskDate.isAfter(startOfWeek) && taskDate.isBefore(endOfWeek.add(Duration(days: 1)))) {
            totalEarnings += task.payAmount ?? 0.0;
          }
        } else if (period == 'Month') {
          if (taskDate.year == now.year && taskDate.month == now.month) {
            totalEarnings += task.payAmount ?? 0.0;
          }
        } else if (period == 'Year') {
          if (taskDate.year == now.year) {
            totalEarnings += task.payAmount ?? 0.0;
          }
        }
      }
    }

    return totalEarnings;
  }

  double _calculateTotalAmount(List fetchtask) {
    double totalAmount = 0.0;

    for (var task in fetchtask) {
      totalAmount += task.payAmount ?? 0.0;
    }

    return totalAmount;
  }

  String _truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff) ? myString : '${myString.substring(0, cutoff)}...';
  }
}