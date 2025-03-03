import 'package:flutter/foundation.dart';
import 'package:wizbrand/Service/Influencer/organization_service.dart';
import 'package:wizbrand/model/city.dart';
import 'package:wizbrand/model/country.dart';
import 'package:wizbrand/model/states.dart';


class CountryViewModel extends ChangeNotifier {
  final OrganizationAPI api;
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
      cities = await api.getCities(stateId);
      print("Fetched cities: ${cities.map((c) => c.city_name).toList()}");
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}