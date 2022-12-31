import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/weather_model.dart';

class WeatherRebo {
  Future<WeatherModel> getWeather(String city) async {
    try {
      final result = await http.Client()
          .get(Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=$city&APPID=43ea6baaad7663dc17637e22ee6f78f2"))
          .timeout(Duration(seconds: 2));
      if (result.statusCode == 404)
        throw FormatException("Invalid City");
      else if (result.statusCode != 200)
        throw FormatException("Connection Error");

      return WeatherModel.fromJson(json.decode(result.body)["main"]);
    } catch (ex) {
      if (ex.toString() == "FormatException: Invalid City")
        throw FormatException("Invalid City");
      throw FormatException("Connection Error");
    }
  }
}
