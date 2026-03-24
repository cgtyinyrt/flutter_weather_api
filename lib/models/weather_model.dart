class WeatherModel {
  final String city;
  final double temp;
  final String description;
  final String icon;

  WeatherModel({
    required this.city,
    required this.temp,
    required this.description,
    required this.icon,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['name'],
      temp: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
    );
  }
}
