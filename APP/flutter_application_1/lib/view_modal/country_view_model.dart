import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/model/city.dart';
import 'package:flutter_application_1/model/country.dart';
import 'package:flutter_application_1/model/states.dart';
import '../Service/Influencer/influencer_service.dart';

class CountryViewModel extends ChangeNotifier {
  final InfluencerAPI api;
  List<Country> countries = [];
  List<States> states = [];
  List<City> cities = [];
  bool isLoading = false;

  CountryViewModel(this.api);

  Future<void> fetchCountries() async {
    isLoading = true;
    notifyListeners();

    try {
      countries = await api.getcountry();
      print("Fetched countries: ${countries.map((c) => c.country_name).toList()}");
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchStates(String countryId) async {
    isLoading = true;
    notifyListeners();

    try {
      states = await api.getStates(countryId);
      print("Fetched states: ${states.map((s) => s.state_name).toList()}");
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
Future<void> fetchCities(String stateId) async {
  isLoading = true;
  notifyListeners();

  try {
    // Fetch cities from the API
    List<City> fetchedCities = await api.getCities(stateId);

    // Filter for unique city names
    List<City> uniqueCities = [];
    Set<String> cityNames = {};

    for (var city in fetchedCities) {
      if (!cityNames.contains(city.city_name)) {
        uniqueCities.add(city);
        cityNames.add(city.city_name);
      }
    }

    // Assign the unique cities to the dropdown list
    cities = uniqueCities;

    print("Unique cities: ${uniqueCities.map((c) => c.city_name).toList()}");
  } catch (e) {
    print("Error fetching cities: $e");
  } finally {
    isLoading = false;
    notifyListeners();
  }
}
}