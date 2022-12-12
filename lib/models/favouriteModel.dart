import 'package:objectbox/objectbox.dart';
import 'package:weatheria/models/weather.dart';

@Entity()
class Favorite {
  @Id()
  int? id;
  final String? city;
  final String? country;
  final String? latitude;
  final String? longitude;

  Favorite(
      {this.id,
      required this.city,
      required this.country,
      required this.latitude,
      required this.longitude});

  factory Favorite.fromMap(Map<String, dynamic> map) => new Favorite(
      id: map['id'],
      city: map['city'],
      country: map['country'],
      latitude: map['latitude'],
      longitude: map['longitude']);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'city': city,
      'country': country,
      'latitude': latitude,
      'longitude': longitude
    };
  }
}

class FavoriteWeather {
  final String? city;
  final String? country;
  final String? latitude;
  final String? longitude;
  final Weather? weather;

  FavoriteWeather({
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.weather,
  });
}
