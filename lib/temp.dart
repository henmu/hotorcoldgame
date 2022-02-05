class Temp {
  final num valueTemp;

  const Temp({required this.valueTemp});

  factory Temp.fromJson(Map<String, dynamic> json) {
    return Temp(
      valueTemp: json['main']['temp'],
    );
  }
}
