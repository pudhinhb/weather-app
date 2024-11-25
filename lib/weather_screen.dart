import 'dart:ui';
import 'package:flutter/material.dart';

class WeatherScreen extends StatelessWidget {
  final String temperature;
  final String condition;
  final List<Map<String, String>> hourlyForecast;
  final String humidity;
  final String windSpeed;
  final String pressure;

  const WeatherScreen({
    super.key,
    required this.temperature,
    required this.condition,
    required this.hourlyForecast,
    required this.humidity,
    required this.windSpeed,
    required this.pressure, required String cloudCover, required String title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Add functionality for options icon
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            Text(
                              temperature,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildWeatherIcon(),
                            const SizedBox(height: 16),
                            Text(
                              condition,
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'weather Forecast',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildHourlyForecastCards(hourlyForecast),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Additional Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildAdditionalInfo('Humidity', humidity, Icons.opacity),
                      _buildAdditionalInfo('Wind Speed', windSpeed, Icons.air),
                      _buildAdditionalInfo('Pressure', pressure, Icons.beach_access),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfo(String label, String value, IconData iconData) {
    return Column(
      children: [
        Icon(iconData, size: 36),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }

  List<Widget> _buildHourlyForecastCards(List<Map<String, String>> hourlyForecast) {
    return hourlyForecast.map((hourData) {
      return _buildForecastCard(hourData);
    }).toList();
  }

  Widget _buildForecastCard(Map<String, String> hourData) {
    IconData iconData = _getWeatherIcon(hourData['condition'] ?? '');
    if (iconData == Icons.error) {
      // Change icon based on temperature
      double temperature = double.tryParse(hourData['temperature'] ?? '') ?? 0.0;
      if (temperature > 25) {
        iconData = Icons.wb_sunny;
      } else if (temperature > 15) {
        iconData = Icons.cloud;
      } else {
        iconData = Icons.grain;
      }
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(right: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(hourData['time'] ?? ''),
            Icon(iconData, size: 36),
            const SizedBox(height: 5),
            Text(hourData['time'] ?? ''),
            Text(hourData['temperature'] ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherIcon() {
    switch (condition.toLowerCase()) {
      case 'clear':
        return const Icon(Icons.wb_sunny, size: 64);
      case 'cloudy':
        return const Icon(Icons.cloud, size: 64);
      case 'partly cloudy':
        return const Icon(Icons.wb_cloudy, size: 64);
      case 'rain':
        return const Icon(Icons.beach_access_sharp, size: 64);
        case 'mist':
        return const Icon(Icons.cloud_circle, size: 64);
      default:
        return const Icon(Icons.error, size: 64);
    }
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'cloudy':
        return Icons.cloud;
      case 'rain':
        return Icons.umbrella;
      default:
        return Icons.error;
    }
  }
}
