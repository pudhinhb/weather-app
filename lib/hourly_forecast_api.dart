// hourly_forecast_api.dart

import 'package:http/http.dart' as http;
import 'dart:convert';

class HourlyForecastApi {
  final String apiKey;

  HourlyForecastApi({required this.apiKey});

  Future<List<Map<String, String>>> fetchHourlyForecast(String location) async {
    final response = await http.get(Uri.parse(
        'http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$location&days=1&aqi=no&alerts=no'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return _extractHourlyForecast(data);
    } else {
      throw Exception('Failed to load hourly forecast data');
    }
  }

  List<Map<String, String>> _extractHourlyForecast(Map<String, dynamic> data) {
    List<Map<String, String>> hourlyForecast = [];
    if (data.containsKey('forecast') && data['forecast'].containsKey('forecastday')) {
      List<dynamic> forecastDays = data['forecast']['forecastday'];
      if (forecastDays.isNotEmpty) {
        for (var hour in forecastDays[0]['hour']) {
          String time = hour['time'];
          String temperature = hour['temp_c'].toString();
          String condition = hour['condition']['text'];
          hourlyForecast.add({'time': time, 'temperature': temperature, 'condition': condition});
        }
      }
    }
    return hourlyForecast;
  }
}
