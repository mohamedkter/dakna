class AddressModel {
  final String name;
  final String details;
  final double lat;
  final double lng;

  AddressModel({
    required this.name,
    required this.details,
    required this.lat,
    required this.lng,
  });

  /// From JSON
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      name: json['name'] as String,
      details: json['details'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'details': details,
      'lat': lat,
      'lng': lng,
    };
  }
}
