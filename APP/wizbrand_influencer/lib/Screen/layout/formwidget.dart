import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wizbrand_influencer/Screen/Influencer/profilescreen.dart';
import 'package:wizbrand_influencer/view_modal/form_view_model.dart';
import 'package:wizbrand_influencer/view_modal/influencer_view_model.dart';

class FormWidget extends StatefulWidget {
  final String title;
  final List<String> fieldLabels;
  final String? selectedCurrency;
  final List<String>? socialSite;

  FormWidget({
    required this.title,
    required this.fieldLabels,
    this.selectedCurrency,
    this.socialSite,
  });

  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  String? _selectedCurrency;
  bool _isCurrencySelected = false;  // Boolean variable to track if a currency is selected
  bool _isLoggedIn = false;
  String? _email;

  @override
  void initState() {
    super.initState();
    _selectedCurrency = widget.selectedCurrency;
    _isCurrencySelected = _selectedCurrency != null;  // Initialize based on initial currency value
  }

  Future<Map<String, String?>> _getCredentials() async {
    final secureStorage = FlutterSecureStorage();
    String? email = await secureStorage.read(key: 'email');
    String? password = await secureStorage.read(key: 'password');
    return {'email': email, 'password': password};
  }

  String extractSocialSite(String label) {
    final RegExp regex = RegExp(r'Enter your (.*?) url');
    final match = regex.firstMatch(label);
    return match?.group(1) ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<FormViewModel>(context);
    final influencerViewModel = Provider.of<InfluencerViewModel>(context);

    return FutureBuilder(
      future: _getCredentials(),
      builder: (context, AsyncSnapshot<Map<String, String?>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          Map<String, String?> credentials = snapshot.data ?? {};
          String? email = credentials['email'];
          String? password = credentials['password'];

          if (email != null && password != null && !_isLoggedIn) {
            _isLoggedIn = true;
            _email = email;
            Provider.of<InfluencerViewModel>(context, listen: false)
                .fetchInfluencersData(email)
                .then((_) {
              setState(() {
                _selectedCurrency = influencerViewModel.socialCurrency;
                _isCurrencySelected = _selectedCurrency != null;
              });
            });
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (widget.title == 'Set Price')
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          children: [
                            Text('Select Currency'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Radio<String>(
                                  value: 'INR',
                                  groupValue: _selectedCurrency,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _selectedCurrency = value;
                                      _isCurrencySelected = value != null;
                                    });
                                  },
                                ),
                                Text('INR'),
                                Radio<String>(
                                  value: 'USD',
                                  groupValue: _selectedCurrency,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _selectedCurrency = value;
                                      _isCurrencySelected = value != null;
                                    });
                                  },
                                ),
                                Text('USD'),
                                Radio<String>(
                                  value: 'EURO',
                                  groupValue: _selectedCurrency,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _selectedCurrency = value;
                                      _isCurrencySelected = value != null;
                                    });
                                  },
                                ),
                                Text('EURO'),
                              ],
                            ),
                          ],
                        ),
                      ),

                    for (int i = 0; i < widget.fieldLabels.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Consumer<InfluencerViewModel>(
                          builder: (context, influencerViewModel, child) {
                            String fieldKey = extractSocialSite(widget.fieldLabels[i]);
                            
                            String? initialValue;

                            if (widget.title == 'Describe') {
                              if (i == 0) {
                                initialValue = influencerViewModel.digitalMarketer;
                              } else if (i == 1) {
                                initialValue = influencerViewModel.bio;
                              }
                            } else if (widget.title == 'Set Price') {
                              initialValue = influencerViewModel.socialPrices?[fieldKey]?.toString();
                            } else if (widget.title == 'Add social site') {
                              initialValue = influencerViewModel.socialurls?[fieldKey]?.toString();
                            }

                            bool isFieldEnabled = true;
                            if (widget.title == 'Set Price') {
                              String? urlValue = influencerViewModel.socialurls?[fieldKey];
                              isFieldEnabled = (urlValue != null && urlValue.isNotEmpty) && _isCurrencySelected;
                            }

                            String labelText;
                            if (widget.title == 'Set Price' && !isFieldEnabled) {
                              labelText = !_isCurrencySelected ? 'Select currency first' : 'Enter URL first';
                            } else if (widget.title == 'Set Price') {
                             labelText = 'Enter Price for ${fieldKey}';
                            } else {
                              labelText = widget.fieldLabels[i];
                            }

                            return TextFormField(
                              enabled: isFieldEnabled,
                              initialValue: initialValue ?? '',
                              decoration: InputDecoration(
                                labelText: labelText,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                fillColor: Colors.grey[200],
                              ),
                              validator: (value) {
                                if (widget.title == 'Add social site' && (initialValue != null && initialValue.isNotEmpty) && (value == null || value.isEmpty)) {
                                  return 'URL cannot be left empty';
                                }
                                if (widget.title == 'Set Price' && (initialValue != null && initialValue.isNotEmpty) && (value == null || value.isEmpty)) {
                                  return 'Price cannot be left empty';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _formData[widget.fieldLabels[i]] = value ?? '';
                              },
                            );
                          },
                        ),
                      ),
                    SizedBox(height: 20),
ElevatedButton(
  onPressed: () {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      if (widget.title == 'Set Price' && !_isCurrencySelected) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a currency')),
        );
      } else {
   
          // Define activeTabIndex based on title
          int activeTabIndex;
          if (widget.title == 'Add social site') {
            activeTabIndex = 0;
          } else if (widget.title == 'Set Price') {
            activeTabIndex = 1;
          } else {
            activeTabIndex = 0; // Default to first tab if title doesn't match
          }

          // Print activeTabIndex for debugging
          print('Navigating with activeTabIndex: $activeTabIndex');

          // Submit form and navigate to TabScreen with the correct tab index
          viewModel.submitForm(
            _formData,
            _selectedCurrency,
            widget.title,
            _email,
            context,
            activeTabIndex,
          );
        
      }
    }
  },
  child: Text('Save'),
),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
