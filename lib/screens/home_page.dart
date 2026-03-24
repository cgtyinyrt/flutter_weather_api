import 'package:flutter/material.dart';
import 'package:flutter_weather_api/models/weather_model.dart';
import 'package:flutter_weather_api/services/weather_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WeatherModel? weather;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  void fetchWeather() async {
    try {
      weather = await WeatherService().getWeather();
    } catch (e) {
      print("ERROR: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(title: const Text("Weather App"), centerTitle: true),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : weather == null
            ? const Text("Error loading data")
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.lightBlueAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          weather!.city,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Image.network(
                          "https://openweathermap.org/img/wn/${weather!.icon}@2x.png",
                          width: 100,
                        ),

                        Text(
                          "${weather!.temp.toStringAsFixed(1)}°C",
                          style: const TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          weather!.description.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                            letterSpacing: 1,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _infoItem("💧", "Humidity"),
                            _infoItem("🌬", "Wind"),
                            _infoItem("🌡", "Feels"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _infoItem(String icon, String label) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}
