import 'package:flutter/material.dart';
import 'package:flutter_weather_api/models/weather_model.dart';
import 'package:flutter_weather_api/services/weather_service.dart';

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const HomePage({super.key, required this.toggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WeatherModel? weather;
  List forecast = [];
  bool isLoading = false;
  String city = "Ankara";

  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData(city);
  }

  void fetchData(String cityName) async {
    setState(() => isLoading = true);

    try {
      weather = await WeatherService().getWeatherByCity(cityName);
      forecast = await WeatherService().getForecast(cityName);
    } catch (e) {
      print(e);
    }

    setState(() => isLoading = false);
  }

  List<Color> _getThemeAwareColors(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (weather == null) {
      return isDark
          ? [Colors.black, Colors.grey.shade900]
          : [Colors.white, Colors.blue.shade100];
    }

    String desc = weather!.description.toLowerCase();

    if (desc.contains("rain")) {
      return isDark
          ? [Colors.indigo.shade900, Colors.black]
          : [Colors.blue.shade200, Colors.blue.shade50];
    }

    if (desc.contains("cloud")) {
      return isDark
          ? [Colors.grey.shade800, Colors.black]
          : [Colors.grey.shade300, Colors.white];
    }

    if (desc.contains("clear")) {
      return isDark
          ? [Colors.orange.shade900, Colors.black]
          : [Colors.orange.shade200, Colors.yellow.shade100];
    }

    return isDark
        ? [Colors.blueGrey.shade900, Colors.black]
        : [Colors.blue.shade100, Colors.white];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _getThemeAwareColors(context),
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: "Enter city",
                          filled: true,
                          fillColor: isDark
                              ? Colors.white.withOpacity(0.1)
                              : Colors.black.withOpacity(0.05),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              city = controller.text;
                              fetchData(city);
                            },
                          ),
                        ),
                      ),
                    ),

                    if (weather != null)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            gradient: LinearGradient(
                              colors: isDark
                                  ? [
                                      Colors.white.withOpacity(0.1),
                                      Colors.white.withOpacity(0.05),
                                    ]
                                  : [
                                      Colors.white.withOpacity(0.7),
                                      Colors.white.withOpacity(0.3),
                                    ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                weather!.city,
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Image.network(
                                "https://openweathermap.org/img/wn/${weather!.icon}@2x.png",
                                width: 100,
                              ),

                              Text(
                                "${weather!.temp.toStringAsFixed(1)}°C",
                                style: TextStyle(
                                  fontSize: 44,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),

                              Text(
                                weather!.description.toUpperCase(),
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.black54,
                                ),
                              ),

                              const SizedBox(height: 20),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _infoItem(
                                    "💧",
                                    "${weather!.humidity}%",
                                    isDark,
                                  ),
                                  _infoItem("🌬", "${weather!.wind}", isDark),
                                  _infoItem(
                                    "🌡",
                                    "${weather!.feelsLike}",
                                    isDark,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                    SizedBox(
                      height: 170,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: forecast.length > 10 ? 10 : forecast.length,
                        itemBuilder: (context, index) {
                          final item = forecast[index];

                          String dateTime = item['dt_txt'];
                          String time = dateTime.substring(11, 16);

                          return Container(
                            width: 95,
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: isDark
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.black.withOpacity(0.05),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  time,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                ),

                                Image.network(
                                  "https://openweathermap.org/img/wn/${item['weather'][0]['icon']}@2x.png",
                                  width: 50,
                                ),

                                Text(
                                  "${item['main']['temp'].round()}°",
                                  style: TextStyle(
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _infoItem(String icon, String value, bool isDark) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
      ],
    );
  }
}
