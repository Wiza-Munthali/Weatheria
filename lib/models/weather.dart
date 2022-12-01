class Weather {
  double lat;
  double lon;
  String timezone;
  int timezoneOffset;
  Current current;
  List<Hourly> hourly;
  List<Daily> daily;

  Weather(
      {required this.lat,
      required this.lon,
      required this.timezone,
      required this.timezoneOffset,
      required this.current,
      required this.hourly,
      required this.daily});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        lat: json['lat'] ?? 0,
        lon: json['lon'] ?? 0,
        timezone: json['timezone'] ?? "",
        timezoneOffset: json['timezone_offset'] ?? "",
        current: Current.fromJson(json["current"]),
        hourly:
            List<Hourly>.from(json["hourly"].map((x) => Hourly.fromJson(x))),
        daily: List<Daily>.from(json["daily"].map((x) => Daily.fromJson(x))));
  }
}

class Current {
  int dt;
  int sunrise;
  int sunset;
  double temp;
  double feelsLike;
  int pressure;
  int humidity;
  double dewPoint;
  double uvi;
  int clouds;
  int visibility;
  double windSpeed;
  int windDeg;
  List<WeatherElement> weatherElement;

  Current(
      {required this.dt,
      required this.sunrise,
      required this.sunset,
      required this.temp,
      required this.feelsLike,
      required this.pressure,
      required this.humidity,
      required this.dewPoint,
      required this.uvi,
      required this.clouds,
      required this.visibility,
      required this.windSpeed,
      required this.windDeg,
      required this.weatherElement});

  factory Current.fromJson(Map<String, dynamic> json) {
    return Current(
      dt: json["dt"] ?? 0,
      sunrise: json["sunrise"] ?? 0,
      sunset: json["sunset"] ?? 0,
      temp: json["temp"].toDouble() ?? 0.0,
      feelsLike: json["feels_like"].toDouble() ?? 0.0,
      pressure: json["pressure"] ?? 0,
      humidity: json["humidity"] ?? 0,
      dewPoint: json["dew_point"].toDouble() ?? 0,
      uvi: json["uvi"].toDouble() ?? 0,
      clouds: json["clouds"] ?? 0,
      visibility: json["visibility"] ?? 0,
      windSpeed: json["wind_speed"].toDouble() ?? 0,
      windDeg: json["wind_deg"] ?? 0,
      weatherElement: List<WeatherElement>.from(
          json["weather"].map((x) => WeatherElement.fromJson(x))),
    );
  }
}

class WeatherElement {
  final int id;
  final String main;
  final String description;
  final String icon;

  WeatherElement(
      {required this.id,
      required this.main,
      required this.description,
      required this.icon});

  factory WeatherElement.fromJson(Map<String, dynamic> json) {
    return WeatherElement(
      id: json["id"] ?? 0,
      main: json["main"] ?? "",
      description: json["description"] ?? "",
      icon: json["icon"] ?? "",
    );
  }
}

class Hourly {
  int dt;
  double temp;
  double feelsLike;
  int pressure;
  int humidity;
  double dewPoint;
  double uvi;
  int clouds;
  int visibility;
  double windSpeed;
  int windDeg;
  double windGust;
  List<WeatherElement> weatherElement;
  double pop;

  Hourly(
      {required this.dt,
      required this.temp,
      required this.feelsLike,
      required this.pressure,
      required this.humidity,
      required this.dewPoint,
      required this.uvi,
      required this.clouds,
      required this.visibility,
      required this.windSpeed,
      required this.windDeg,
      required this.windGust,
      required this.weatherElement,
      required this.pop});

  factory Hourly.fromJson(Map<String, dynamic> json) {
    return Hourly(
      dt: json["dt"] ?? 0,
      temp: json["temp"].toDouble() ?? 0,
      feelsLike: json["feels_like"].toDouble() ?? 0,
      pressure: json["pressure"] ?? 0,
      humidity: json["humidity"] ?? 0,
      dewPoint: json["dew_point"].toDouble() ?? 0,
      uvi: json["uvi"].toDouble() ?? 0,
      clouds: json["clouds"] ?? 0,
      visibility: json["visibility"] ?? 0,
      windSpeed: json["wind_speed"].toDouble() ?? 0,
      windDeg: json["wind_deg"] ?? 0,
      windGust: json["wind_gust"].toDouble() ?? 0,
      weatherElement: List<WeatherElement>.from(
          json["weather"].map((x) => WeatherElement.fromJson(x))),
      pop: json["pop"].toDouble() ?? 0,
    );
  }
}

class Daily {
  int dt;
  int sunrise;
  int sunset;
  int moonrise;
  int moonset;
  double moonPhase;
  Temp temp;
  FeelsLike feelsLike;
  int pressure;
  int humidity;
  double dewPoint;
  double windSpeed;
  int windDeg;
  double windGust;
  List<WeatherElement> weatherElement;
  int clouds;
  double pop;
  double uvi;

  Daily(
      {required this.dt,
      required this.sunrise,
      required this.sunset,
      required this.moonrise,
      required this.moonset,
      required this.moonPhase,
      required this.temp,
      required this.feelsLike,
      required this.pressure,
      required this.humidity,
      required this.dewPoint,
      required this.windSpeed,
      required this.windDeg,
      required this.windGust,
      required this.weatherElement,
      required this.clouds,
      required this.pop,
      required this.uvi});

  factory Daily.fromJson(Map<String, dynamic> json) {
    print("Daily: $json");
    return Daily(
      dt: json["dt"] ?? 0,
      sunrise: json["sunrise"] ?? 0,
      sunset: json["sunset"] ?? 0,
      moonrise: json["moonrise"] ?? 0,
      moonset: json["moonset"] ?? 0,
      moonPhase: json["moon_phase"].toDouble() ?? 0,
      temp: Temp.fromJson(json["temp"]),
      feelsLike: FeelsLike.fromJson(json["feels_like"]),
      pressure: json["pressure"] ?? 0,
      humidity: json["humidity"] ?? 0,
      dewPoint: json["dew_point"].toDouble() ?? 0,
      windSpeed: json["wind_speed"].toDouble() ?? 0,
      windDeg: json["wind_deg"] ?? 0,
      windGust: json["wind_gust"].toDouble() ?? 0,
      weatherElement: List<WeatherElement>.from(
          json["weather"].map((x) => WeatherElement.fromJson(x))),
      clouds: json["clouds"] ?? 0,
      pop: json["pop"].toDouble() ?? 0,
      uvi: json["uvi"].toDouble() ?? 0,
    );
  }
}

class Temp {
  double day;
  double min;
  double max;
  double night;
  double eve;
  double morn;

  Temp(
      {required this.day,
      required this.min,
      required this.max,
      required this.night,
      required this.eve,
      required this.morn});

  factory Temp.fromJson(Map<String, dynamic> json) {
    return Temp(
      day: json["day"].toDouble() ?? 0,
      min: json["min"].toDouble() ?? 0,
      max: json["max"].toDouble() ?? 0,
      night: json["night"].toDouble() ?? 0,
      eve: json["eve"].toDouble() ?? 0,
      morn: json["morn"].toDouble() ?? 0,
    );
  }
}

class FeelsLike {
  double day;
  double night;
  double eve;
  double morn;

  FeelsLike(
      {required this.day,
      required this.night,
      required this.eve,
      required this.morn});

  factory FeelsLike.fromJson(Map<String, dynamic> json) {
    return FeelsLike(
      day: json["day"].toDouble() ?? 0,
      night: json["night"].toDouble() ?? 0,
      eve: json["eve"].toDouble() ?? 0,
      morn: json["morn"].toDouble() ?? 0,
    );
  }
}
