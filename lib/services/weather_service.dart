import 'package:dio/dio.dart';
import 'package:flutter_weather_api/models/weather_model.dart';
import 'package:geolocator/geolocator.dart';

class WeatherService {
  // final String apiKey = "3329b81908fe74f7310502a02bd17c7b";

  Future<Position> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location services are disabled");
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<WeatherModel> getWeather() async {
    final position = await _getLocation();

    final lat = position.latitude;
    final lon = position.longitude;

    final dio = Dio();

    final response = await dio.get(
      "https://api.openweathermap.org/data/2.5/weather",
      queryParameters: {
        "lat": lat,
        "lon": lon,
        "appid": "3329b81908fe74f7310502a02bd17c7b",
        "units": "metric",
        "lang": "en",
      },
    );

    return WeatherModel.fromJson(response.data);
  }
}
