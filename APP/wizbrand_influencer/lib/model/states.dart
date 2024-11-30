import 'dart:convert';

class States {
  int id;
  int state_id;
  String state_name;
  String country_id;

  States({
    this.id = 0,
    required this.state_id,
    required this.state_name,
    required this.country_id,
  });

  factory States.fromJson(Map<String, dynamic> map) {
    return States(
      id: map["id"] ?? 0,
      state_id: map["state_id"] ?? 0,
      state_name: map["state_name"] ?? '',
      country_id: map["country_id"].toString(), // Convert to String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "state_id": state_id,
      "state_name": state_name,
      "country_id": country_id,
    };
  }

  @override
  String toString() {
    return 'States{id: $id, state_id: $state_id, state_name: $state_name, country_id: $country_id}';
  }
}

List<States> stateFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<States>.from(data.map((item) => States.fromJson(item)));
}

String stateToJson(States data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}