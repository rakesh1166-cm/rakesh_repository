import 'dart:convert';

class City {
  int id;
  int city_id;
  int state_id;
  String city_name;
  String country_id;

  City({
    this.id = 0,
    required this.city_id,
    required this.state_id,
    required this.city_name,
    required this.country_id,
  });

  factory City.fromJson(Map<String, dynamic> map) {
    return City(
      id: map["id"] ?? 0,
      city_id: map["city_id"] ?? 0,
      state_id: map["state_id"] ?? 0,
      city_name: map["city_name"] ?? '',
      country_id: map["country_id"].toString(), // Convert to String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "city_id": city_id,
      "state_id": state_id,
      "city_name": city_name,
      "country_id": country_id,
    };
  }

  @override
  String toString() {
    return 'City{id: $id, city_id: $city_id, state_id: $state_id, city_name: $city_name, country_id: $country_id}';
  }
}

List<City> cityFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<City>.from(data.map((item) => City.fromJson(item)));
}

String cityToJson(City data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}