// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'weather_screen.dart';
import 'hourly_forecast_api.dart'; // Import the HourlyForecastApi class

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData.dark(),
      home: const WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({Key? key});

  @override
  // ignore: library_private_types_in_public_api
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final String _apiKey = '20c4d017ad0d45e3ac7123633241403';
  double _temperature = 0.0;
  int _cloudCover = 0;
  double _windSpeed = 0.0;
  int _humidity = 0;
  String _condition = '';
  int _pressure = 0; // Added pressure variable
  List<Map<String, String>> _hourlyForecast = []; // Hourly forecast data
  // ignore: unused_field
  final List<String> _locations = ['Current Location'];
  final String _selectedLocation = 'Current Location';

  Future<void> _fetchWeatherData(String? location) async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    final response = await http.get(Uri.parse(
        'http://api.weatherapi.com/v1/current.json?key=$_apiKey&q=${location == 'Current Location' ? '${position.latitude},${position.longitude}' : location}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _temperature = data['current']['temp_c'];
        _cloudCover = data['current']['cloud'];
        _windSpeed = data['current']['wind_kph'];
        _humidity = data['current']['humidity'];
        _condition = data['current']['condition']['text'];
        _pressure = data['current']['pressure_mb']; // Fetch pressure data
      });
      // Fetch hourly forecast data
      await _fetchHourlyForecast(location);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<void> _fetchHourlyForecast(String? location) async {
    final hourlyForecastApi = HourlyForecastApi(apiKey: _apiKey);
    final hourlyForecastData = await hourlyForecastApi.fetchHourlyForecast(location!);
    setState(() {
      _hourlyForecast = hourlyForecastData;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchWeatherData(_selectedLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
        ),
        centerTitle: true, // Center the title
        toolbarHeight: 60, // Reduce the height of the AppBar
      ),
      body: Center(
        child: WeatherScreen(
          temperature: '$_temperature°C', // Display temperature with degree symbol
          cloudCover: _cloudCover.toString(),
          windSpeed: '$_windSpeed km/h',
          humidity: '$_humidity%',
          condition: _condition,
          pressure: _pressure.toString(),
          title: '',
          hourlyForecast: _hourlyForecast, // Pass hourly forecast data
        ),
      ),
    );
  }
}
