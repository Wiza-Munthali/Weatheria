import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:lottie/lottie.dart';
import 'package:uuid/uuid.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:weatheria/controllers/searchAddress.dart';
import 'package:weatheria/controllers/weatherController.dart';
import 'package:weatheria/models/currentWeather.dart';
import 'package:weatheria/models/favouriteModel.dart';
import 'package:weatheria/models/suggestions.dart';

import 'controllers/databaseHelper.dart';
import 'models/weatherConditions.dart';

class Favourite extends StatefulWidget {
  final String units;
  const Favourite({Key? key, required this.units}) : super(key: key);

  @override
  _FavouriteState createState() => _FavouriteState(units);
}

class _FavouriteState extends State<Favourite> {
  _FavouriteState(this.units);
  WeatherController weatherController = new WeatherController();
  WeatherConditions weatherConditions = new WeatherConditions();
  late List<CurrentWeather> currentWeather;
  late String units;
  late Future getFavs;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: ((context, child) => Scaffold()));
  }

  Widget loading() {
    return Center(
      child: Container(
        child: Lottie.asset("assets/images/weather_icons/splash.json",
            frameRate: FrameRate(60), height: 250.h, width: 250.w),
      ),
    );
  }
}
