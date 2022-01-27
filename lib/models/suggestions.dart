// For storing our result
import 'dart:convert';
import 'dart:io';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart';

class Place {
  String? city;
  String? country;
  String? latitude;
  String? longitude;

  Place({this.city, this.country, this.latitude, this.longitude});

  @override
  String toString() {
    return 'Place(city: $city, country: $country, latitude: $latitude, longitude: $longitude)';
  }
}

class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}

class PlaceApiProvider {
  final client = Client();

  PlaceApiProvider(this.sessionToken);

  final sessionToken;

  static final String androidKey = 'AIzaSyCSJ4uIJTpmnlIEVKNrvQCTBAwMOj6giAM';
  static final String iosKey = 'YOUR_API_KEY_HERE';
  final apiKey = Platform.isAndroid ? androidKey : iosKey;

  Future<List<Suggestion>> fetchSuggestions(String input, String lang) async {
    Uri request = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey&sessiontoken=$sessionToken');
    final response = await client.get(request);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        return result['predictions']
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<Place> getPlaceDetailFromId(String placeId) async {
    Uri request = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=address_component&key=$apiKey&sessiontoken=$sessionToken');
    final response = await client.get(request);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        final components =
            result['result']['address_components'] as List<dynamic>;

        // build result
        final place = Place();
        components.forEach((c) {
          final List type = c['types'];
          if (type.contains('locality')) {
            place.city = c['long_name'];
          }
          if (type.contains('country')) {
            place.country = c['long_name'];
          }
        });

        //find latitude and longitude
        //List<Placemark> _address = await placemarkFromCoordinates(latitude, longitude);
        List<Location> locations = await locationFromAddress("${place.city}");
        place.latitude = locations[0].latitude.toString();
        place.longitude = locations[0].longitude.toString();
        return place;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }
}
