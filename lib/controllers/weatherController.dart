import 'dart:convert';
import 'package:weatheria/models/currentWeather.dart' as current;
import 'package:weatheria/models/weather.dart';
import 'package:http/http.dart' as http;

class WeatherController {
  final String apiKey = "7ed8f61149bd0d5492a2afe397d915a4";

  Future getOneCall(lat, long, units) async {
    var client = http.Client();
    Uri uri = Uri.parse(
        "https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$long&units=$units&appid=$apiKey");

    Weather _weather;
    try {
      var response = await client.get(uri);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        _weather = Weather.fromJson(data);
        return _weather;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future currentWeather(city, units) async {
    var client = http.Client();
    Uri uri = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$city&units=$units&appid=$apiKey");

    current.CurrentWeather currentWeather;
    try {
      var response = await client.get(uri);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        currentWeather = current.CurrentWeather.fromJson(data);
        return currentWeather;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
