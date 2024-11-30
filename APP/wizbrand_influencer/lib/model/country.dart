import 'dart:convert';

class Country {
  int id;
  String country_id;
  String country_name;

  Country({
    this.id = 0,
    required this.country_id,
    required this.country_name,
  });

  factory Country.fromJson(Map<String, dynamic> map) {
    return Country(
      id: map["id"] ?? 0,
      country_id: map["country_id"].toString(),
      country_name: map["country_name"].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "country_id": country_id,
      "country_name": country_name,
    };
  }

  @override
  String toString() {
    return 'Country{id: $id, country_id: $country_id, country_name: $country_name}';
  }
}

List<Country> countryFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Country>.from(data.map((item) => Country.fromJson(item)));
}

String countryToJson(Country data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}