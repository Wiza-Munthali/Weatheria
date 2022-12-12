import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:weatheria/controllers/databaseHelper.dart';
import 'package:weatheria/controllers/favoriteController.dart';
import 'package:weatheria/controllers/weatherController.dart';
import 'package:weatheria/screens/favorite/favoriteDetail.dart';
import 'package:weatheria/models/favouriteModel.dart';
import 'package:weatheria/models/weather.dart';
import 'package:weatheria/search.dart';

import '../../models/weatherConditions.dart';

class FavoritePage extends StatefulWidget {
  final String units;
  final ObjectBox database;
  const FavoritePage({Key? key, required this.units, required this.database})
      : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState(units, database);
}

class _FavoritePageState extends State<FavoritePage> {
  _FavoritePageState(this.units, this.database);
  final String units;
  final ObjectBox database;
  late FavoriteController favoriteController;
  late List<Favorite> favorites;
  List<FavoriteWeather> _favoriteWeather = [];
  late Future future;
  WeatherController weatherController = new WeatherController();
  WeatherConditions weatherConditions = new WeatherConditions();

  @override
  void initState() {
    favoriteController =
        FavoriteController(favoriteBox: database.store.box<Favorite>());
    future = getFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return ScreenUtilInit(
        builder: ((context, child) => Scaffold(
              body: FutureBuilder(
                future: future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: loading(),
                    );
                  } else {
                    if (favorites.length > 0) {
                      return Center(child: grid(_width));
                    } else {
                      return Center(
                        child: Text(
                          "Add your favorite cities",
                          style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic,
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                        ),
                      );
                    }
                  }
                },
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Search(
                                favoriteBox: database.store.box<Favorite>())))
                    .then((value) {
                  setState(() {
                    getFavorites();
                  });
                }),
                child: Icon(IcoFontIcons.plus),
                mini: false,
              ),
            )));
  }

  Widget loading() {
    return Container(
      child: Lottie.asset("assets/images/weather_icons/splash.json",
          frameRate: FrameRate(60), height: 250.h, width: 250.w),
    );
  }

  Future<bool> getFavorites() async {
    favorites = favoriteController.getFavorites();
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
    }

    print("Faves Wea: $fw");
    setState(() {
      _favoriteWeather = fw;
    });
    if (_favoriteWeather.length > 0) {
      return true;
    }
    return false;
  }

  Widget grid(double width) {
    return Container(
      width: width,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
        child: GridView.count(
            shrinkWrap: false,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            crossAxisCount: 2,
            children: List.generate(
              _favoriteWeather.length,
              (index) {
                return gridItem(
                    _favoriteWeather[index]
                        .weather!
                        .current
                        .temp
                        .toStringAsFixed(0),
                    weatherConditions.returnIcon(_favoriteWeather[index]
                        .weather!
                        .current
                        .weatherElement[0]
                        .icon),
                    _favoriteWeather[index].city.toString(),
                    _favoriteWeather[index].country.toString(),
                    _favoriteWeather[index]
                        .weather!
                        .current
                        .humidity
                        .toString(),
                    _favoriteWeather[index]
                        .weather!
                        .current
                        .windSpeed
                        .toStringAsFixed(0),
                    index);
              },
            )),
      ),
    );
  }

  Widget gridItem(String temp, String icon, String city, String country,
      String humidity, String wind, int index) {
    return FocusedMenuHolder(
      menuWidth: MediaQuery.of(context).size.width * 0.50,
      blurSize: 5.0,
      menuItemExtent: 45,
      menuBoxDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      duration: Duration(milliseconds: 100),
      animateMenuItems: true,
      blurBackgroundColor: Colors.black54,
      openWithTap: false, // Open Focused-Menu on Tap rather than Long Press
      menuOffset: 10.0, // Offset value to show menuItem from the selected item
      bottomOffsetHeight:
          80.0, // Offset height to consider, for showing the menu item ( for example bottom navigation bar), so that the popup menu will be shown on top of selected item.
      menuItems: [
        // Add Each FocusedMenuItem  for Menu Options

        FocusedMenuItem(
            title: Text(
              "Delete",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            trailingIcon: Icon(Icons.delete,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            onPressed: () => delete(index)),
      ],
      onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FavoriteDetail(
                weather: _favoriteWeather[index].weather!,
                address: _favoriteWeather[index].city!,
                units: units),
          )),
      child: Container(
        height: 40.h,
        width: 40.w,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Degree & Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    temp,
                    style: TextStyle(
                        fontSize: 46.sp,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: 45.w,
                    height: 45.h,
                    child: Align(
                      alignment: Alignment(0, 0),
                      widthFactor: 0.6,
                      heightFactor: 0.5,
                      child: Image.network(
                        icon,
                        height: 80.h,
                        width: 80.h,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
              //Location
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          city,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                              fontWeight: FontWeight.w500,
                              fontSize: 18.sp),
                        ),
                        Text(
                          country,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                              fontWeight: FontWeight.normal,
                              fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //humidity & speed
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(
                          CupertinoIcons.drop,
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          humidity,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(
                          IcoFontIcons.wind,
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          wind,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void delete(int index) {
    Favorite item = favorites[index];
    bool success = favoriteController.removeFavorite(item);
    print("SUC: $success");
    if (success) {
      setState(() {
        favorites = List.from(favorites)..removeAt(index);
      });
      print(favorites);
    }
  }
}
