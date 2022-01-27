import 'package:intl/intl.dart';

class WeatherConditions {
  returnImage(condition) {
    switch (condition) {
      case "light rain":
        return "assets/images/weather_icons/light-rain.json";
      case "shower rain":
        return "assets/images/weather_icons/moderate-rain.json";
      case "rain":
        return "assets/images/weather_icons/heavy-rain.json";
      case "clear sky":
        return "assets/images/weather_icons/sunny.json";
      case "overcast clouds":
        return "assets/images/weather_icons/overcast.json";
      case "few clouds":
        return "assets/images/weather_icons/cloudy.json";
      case "broken clouds":
        return "assets/images/weather_icons/cloudy.json";
      case "scattered clouds":
        return "assets/images/weather_icons/cloudy.json";
      case "Snow":
        return "assets/images/weather_icons/snow.json";
      case "light snow":
        return "assets/images/weather_icons/light-snow.json";
      case "Sleet":
        return "assets/images/weather_icons/sleet.json";
      case "Heavy snow":
        return "assets/images/weather_icons/heavy-snow.json";
      case "very heavy rain":
        return "assets/images/weather_icons/heavy-rain.json";
      case "extreme rain":
        return "assets/images/weather_icons/heavy-rain.json";
      case "heavy intensity rain":
        return "assets/images/weather_icons/heavy-rain.json";
      case "moderate rain":
        return "assets/images/weather_icons/moderate-rain.json";
      default:
    }
  }

  returnIcon(condition) {
    return "http://openweathermap.org/img/wn/$condition@2x.png";
  }

  returndate(date) {
    var d = DateTime.fromMillisecondsSinceEpoch(date * 1000);
    var datetime = DateFormat().add_jm().format(d);
    return datetime;
  }

  returnStringDate(date) {
    var d = DateTime.fromMillisecondsSinceEpoch(date * 1000);
    var datetime = DateFormat("EEEE").format(d);
    return datetime;
  }

  returnMeasurement(unit) {
    switch (unit) {
      case "metric":
        return "metre/sec";
      case "imperial":
        return "miles/hour";
      default:
    }
  }
}
