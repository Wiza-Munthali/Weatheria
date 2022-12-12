import 'dart:async';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:weatheria/controllers/databaseHelper.dart';
import 'package:weatheria/controllers/favoriteController.dart';
import 'package:weatheria/controllers/weatherController.dart';
import 'package:weatheria/models/favouriteModel.dart';
import 'package:weatheria/models/weather.dart';
import 'package:weatheria/models/weatherConditions.dart';
import 'package:weatheria/screens/map/maker_generator.dart';
import 'package:uuid/uuid.dart';
import 'package:weatheria/screens/next_seven.dart';

class Map extends StatefulWidget {
  final String addressName;
  final Weather weather;
  final String units;
  final ObjectBox database;
  const Map(
      {super.key,
      required this.addressName,
      required this.weather,
      required this.units,
      required this.database});

  @override
  State<Map> createState() => _MapState(addressName, weather, units, database);
}

class _MapState extends State<Map> {
  final String addressName;
  final String units;
  final ObjectBox database;
  late FavoriteController favoriteController;
  late List<Favorite> favorites;
  List<FavoriteWeather> _favoriteWeather = [];
  final Weather weather;
  String mapTheme = "";
  Completer<GoogleMapController> _controller = Completer();
  late Future future;
  WeatherController weatherController = new WeatherController();
  WeatherConditions weatherConditions = new WeatherConditions();

  Set<Marker> _markers = {};

  _MapState(this.addressName, this.weather, this.units, this.database);

  @override
  void initState() {
    favoriteController =
        FavoriteController(favoriteBox: database.store.box<Favorite>());
    future = getFavorites();
    DefaultAssetBundle.of(context)
        .loadString("assets/maps/theme.json")
        .then((value) => mapTheme = value);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return ScreenUtilInit(
      designSize: Size(_width, _height),
      builder: (context, child) => Scaffold(
        body: FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: loading(),
              );
            }

            if (snapshot.data == true) {
              return Container(
                height: _height,
                width: _width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.secondaryContainer),
                margin: const EdgeInsets.all(20),
                child: Stack(children: [
                  mapWidget(),
                  Positioned(
                    top: 0,
                    child: searchWidget(_width),
                  ),
                ]),
              );
            }

            return Container();
          },
        ),
      ),
    );
  }

  Widget mapWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.hardEdge,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.hardEdge,
        child: GoogleMap(
          markers: _markers,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          scrollGesturesEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
              target: LatLng(weather.lat, weather.lon), zoom: 11.0),
          onMapCreated: (controller) {
            controller.setMapStyle(mapTheme);
            _controller.complete(controller);
          },
        ),
      ),
    );
  }

  Widget searchWidget(double width) {
    return Container(
      height: 80.h,
      width: width - 40,
      padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
      child: TextField(
        cursorColor: Theme.of(context).colorScheme.onSurface,
        decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            focusColor: Theme.of(context).colorScheme.surface,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    width: 1, color: Theme.of(context).colorScheme.surface)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    width: 1, color: Theme.of(context).colorScheme.surface)),
            iconColor: Theme.of(context).colorScheme.onSurface,
            prefixIconColor: Theme.of(context).colorScheme.onSurface,
            prefixIcon: Icon(
              FluentIcons.search_48_regular,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            hintText: "Search",
            hintStyle:
                TextStyle(color: Theme.of(context).colorScheme.onSurface)),
      ),
    );
  }

  Widget customMarker(String title, String icon, String temp) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.30,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //Title
          Container(
            height: 45,
            child: Center(
              child: Text(title,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    fontSize: 26.sp,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  )),
            ),
          ),

          //icon & deg
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 45.w,
                height: 45.h,
                child: Align(
                  alignment: Alignment(0, 0),
                  widthFactor: 0.6,
                  heightFactor: 0.5,
                  child: Image.network(
                    icon,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Text(
                "$temp°",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 30.sp,
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<bool> makeMakers() async {
    if (_markers.length > 0) {
      return true;
    }

    return false;
  }

  Future<bool> getFavorites() async {
    // MarkerGenerator([
    //   customMarker(
    //       addressName,
    //       weatherConditions.returnIcon(weather.current.weatherElement[0].icon),
    //       weather.current.temp.toStringAsFixed(0))
    // ], (bitmap) {
    //   var uuid = Uuid();
    //   _markers.add(Marker(
    //     markerId: new MarkerId(uuid.v1()),
    //     position: new LatLng(double.parse(weather.lat.toString()),
    //         double.parse(weather.lon.toString())),
    //     icon: BitmapDescriptor.fromBytes(bitmap.first),
    //     anchor: Offset(0.5, 0.5),
    //   ));
    //   setState(() {});
    // }).generate(context);
    favorites = favoriteController.getFavorites();
    favorites.add(Favorite(
        city: addressName,
        country: "country",
        latitude: weather.lat.toString(),
        longitude: weather.lon.toString()));
    if (favorites.length > 0) {
      print("Faves: $favorites");
      List<FavoriteWeather> fw = [];

      for (Favorite favorite in favorites) {
        Weather weather = await weatherController.getOneCall(
            favorite.latitude, favorite.longitude, units);

        FavoriteWeather w = FavoriteWeather(
            city: favorite.city,
            country: favorite.country,
            latitude: favorite.latitude,
            longitude: favorite.longitude,
            weather: weather);
        fw.add(w);

        MarkerGenerator([
          customMarker(
              w.city.toString(),
              weatherConditions
                  .returnIcon(w.weather!.current.weatherElement[0].icon),
              w.weather!.current.temp.toStringAsFixed(0))
        ], (bitmap) {
          var uuid = Uuid();
          _markers.add(Marker(
              markerId: new MarkerId(uuid.v1()),
              position: new LatLng(double.parse(w.latitude.toString()),
                  double.parse(w.longitude.toString())),
              icon: BitmapDescriptor.fromBytes(bitmap.first),
              anchor: Offset(0.5, 0.5),
              onTap: (() {
                var ff = _favoriteWeather
                    .singleWhere((element) => element.latitude == w.latitude);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NextSeven(
                            location: ff.city.toString(),
                            weather: ff.weather!)));
              })));
          setState(() {});
        }).generate(context);
      }

      print("Faves Wea: $fw");
      print("MArker: $_markers");
      setState(() {
        _favoriteWeather = fw;
      });
      if (_favoriteWeather.length > 0) {
        return true;
      }

      return false;
    }
    return true;
  }

  Widget loading() {
    return Container(
      child: lottie.Lottie.asset("assets/images/weather_icons/splash.json",
          frameRate: lottie.FrameRate(60), height: 250.h, width: 250.w),
    );
  }
}
