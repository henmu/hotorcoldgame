class City {
  final double lat;
  final double lon;

  const City({required this.lat, required this.lon});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      lat: json['lat'],
      lon: json['lon'],
    );
  }
}
