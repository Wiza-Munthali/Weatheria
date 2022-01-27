class FavouriteModel {
  final int? id;
  final String? city;
  final String? country;
  final String? latitude;
  final String? longitude;

  FavouriteModel(
      {this.id, this.city, this.country, this.latitude, this.longitude});

  factory FavouriteModel.fromMap(Map<String, dynamic> map) =>
      new FavouriteModel(
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
