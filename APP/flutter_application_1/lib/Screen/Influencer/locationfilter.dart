import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screen/layout/mixins.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/model/city.dart';
import 'package:flutter_application_1/model/states.dart';
import 'package:flutter_application_1/Screen/layout/influencermixins.dart';
import 'package:flutter_application_1/model/country.dart';
import 'package:flutter_application_1/model/search_influencer.dart';
import 'package:flutter_application_1/view_modal/country_view_model.dart';
import 'package:flutter_application_1/view_modal/influencer_view_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocationFilterScreen extends StatefulWidget {
  @override
  _LocationFilterScreenState createState() => _LocationFilterScreenState();
}

class _LocationFilterScreenState extends State<LocationFilterScreen> with NavigationMixin, InfluencerListMixin {
  String _selectedCountryId = 'All';
  String _selectedCountryName = 'All';
  String _selectedStateId = 'All';
  String _selectedStateName = 'Select State';
  String _selectedCityId = 'All';
  String _selectedCityName = 'Select City';
  bool _isLoggedIn = false;
  String? _email;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      Provider.of<CountryViewModel>(context, listen: false).fetchCountries();

      Map<String, String?> credentials = await _getCredentials();
      String? email = credentials['email'];
      String? password = credentials['password'];

      if (email != null && password != null) {
        setState(() {
          _isLoggedIn = true;
          _email = email;
        });
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
    final countryViewModel = Provider.of<CountryViewModel>(context);
    final influencerViewModel = Provider.of<InfluencerViewModel>(context);
    List<SearchInfluencer> filteredInfluencers = influencerViewModel.influencers.where((influencer) {
      bool matchesCountry = _selectedCountryId == 'All' ||
          (influencer.countryId != null && influencer.countryId == _selectedCountryId);
      bool matchesState = _selectedStateId == 'All' ||
          (influencer.stateId != null && influencer.stateId == _selectedStateId);
      bool matchesCity = _selectedCityId == 'All' ||
          (influencer.cityName != null && influencer.cityName == _selectedCityName);
      return matchesCountry && matchesState && matchesCity;
    }).toList();

    return buildBaseScreen(
      currentIndex: 1, // Set the appropriate index for the bottom nav bar
      title: 'Filter by Location',
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: countryViewModel.isLoading
                ? CircularProgressIndicator()
                : DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedCountryName,
                    onChanged: (newValue) {
                      setState(() {
                        final selectedCountry = countryViewModel.countries.firstWhere(
                          (country) => country.country_name == newValue,
                          orElse: () => Country(country_id: 'All', country_name: 'All'),
                        );
                        _selectedCountryId = selectedCountry.country_id;
                        _selectedCountryName = selectedCountry.country_name;
                        _selectedStateId = 'All';
                        _selectedStateName = 'Select State';
                        _selectedCityId = 'All';
                        _selectedCityName = 'Select City';
                      });
                      Provider.of<CountryViewModel>(context, listen: false).fetchStates(_selectedCountryId);
                    },
                    items: ['All', ...countryViewModel.countries.map((country) => country.country_name)].map((countryName) {
                      return DropdownMenuItem<String>(
                        value: countryName,
                        child: Text(countryName),
                      );
                    }).toList(),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: countryViewModel.isLoading
                ? CircularProgressIndicator()
                : DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedStateName,
                    onChanged: (newValue) {
                      setState(() {
                        final selectedState = countryViewModel.states.firstWhere(
                          (state) => state.state_name == newValue,
                          orElse: () => States(state_id: 0, state_name: 'Select State', country_id: 'All'),
                        );
                        _selectedStateId = selectedState.state_id.toString();
                        _selectedStateName = selectedState.state_name;
                        _selectedCityId = 'All';
                        _selectedCityName = 'Select City';
                      });
                      Provider.of<CountryViewModel>(context, listen: false).fetchCities(_selectedStateId);
                    },
                    items: ['Select State', ...countryViewModel.states.map((state) => state.state_name)].map((stateName) {
                      return DropdownMenuItem<String>(
                        value: stateName,
                        child: Text(stateName),
                      );
                    }).toList(),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: countryViewModel.isLoading
                ? CircularProgressIndicator()
                : DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedCityName,
                    onChanged: (newValue) {
                      setState(() {
                        final selectedCity = countryViewModel.cities.firstWhere(
                          (city) => city.city_name == newValue,
                          orElse: () => City(city_id: 0, city_name: 'Select City', state_id: 0, country_id: 'All'),
                        );
                        _selectedCityId = selectedCity.city_id.toString();
                        _selectedCityName = selectedCity.city_name;
                      });
                    },
                    items: ['Select City', ...countryViewModel.cities.map((city) => city.city_name)].map((cityName) {
                      return DropdownMenuItem<String>(
                        value: cityName,
                        child: Text(cityName),
                      );
                    }).toList(),
                  ),
          ),
          buildInfluencerList(context, filteredInfluencers, _isLoggedIn, _email),
        ],
      ),
    );
  }
}