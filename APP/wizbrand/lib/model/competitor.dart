import 'dart:convert';

class Competitor {
  final int id;
  final String? projectName;
  final String? name;
  final int? projectId;
  final String? website;
  final String? facebook;
  final String? youtube;
  final String? twitter;
  final String? linkedin;
  final String? instagram;
  final String? pinterest;
  final String? reddit;
  final String? tiktok;
  final DateTime? createdAt;

  Competitor({
    required this.id,
    this.projectName,
    this.name,
    this.projectId,
    this.website,
    this.facebook,
    this.youtube,
    this.twitter,
    this.linkedin,
    this.instagram,
    this.pinterest,
    this.reddit,
    this.tiktok,
    this.createdAt,
  });

  // Factory method to create an instance of Competitor from JSON
  factory Competitor.fromJson(Map<String, dynamic> json) {
    return Competitor(
      id: json['id'] ?? 0, // Ensure `id` is always an integer
      projectName: json['project_name'] as String?,
      name: json['name'] as String?,
      projectId: json['project_id'] != null ? int.tryParse(json['project_id'].toString()) : null,
      website: json['website'] as String?,
      facebook: json['facebook'] as String?,
      youtube: json['youtube'] as String?,
      twitter: json['twitter'] as String?,
      linkedin: json['linedin'] as String?,
      instagram: json['instagram'] as String?,
      pinterest: json['pinterest'] as String?,
      reddit: json['reddit'] as String?,
      tiktok: json['tiktok'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }

  // Method to convert a Competitor object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_name': projectName,
      'name': name,
      'project_id': projectId,
      'website': website,
      'facebook': facebook,
      'youtube': youtube,
      'twitter': twitter,
      'linkedin': linkedin,
      'instagram': instagram,
      'pinterest': pinterest,
      'reddit': reddit,
      'tiktok': tiktok,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Competitor{id: $id, projectName: $projectName, name: $name, projectId: $projectId, website: $website, facebook: $facebook, youtube: $youtube, twitter: $twitter, linkedin: $linkedin, instagram: $instagram, pinterest: $pinterest, reddit: $reddit, tiktok: $tiktok, createdAt: $createdAt}';
  }
}

// Function to convert a JSON string to a list of Competitors
List<Competitor> competitorFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Competitor>.from(data.map((item) => Competitor.fromJson(item)));
}

// Function to convert a Competitor object to a JSON string
String competitorToJson(Competitor data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}

// Function to convert a list of Competitors to a JSON string
String competitorsToJson(List<Competitor> data) {
  final jsonData = data.map((competitor) => competitor.toJson()).toList();
  return json.encode(jsonData);
}