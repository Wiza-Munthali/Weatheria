import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:weatheria/controllers/databaseHelper.dart';
import 'package:weatheria/favourite.dart';
import 'package:weatheria/models/favouriteModel.dart';
import 'package:weatheria/models/preferences.dart';
import 'package:weatheria/search.dart';
import 'package:weatheria/settings.dart';

import 'controllers/locationCotroller.dart';
import 'controllers/weatherController.dart';
import 'home.dart';
import 'models/weather.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Sans Pro",
        backgroundColor: Color.fromRGBO(250, 249, 246, 1),
      ),
      title: 'Weatheria',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int pageIndex = 0;
  late TabController controller;

  late Weather _weather;
  late String? units;
  late String? address;
  late String? longAddress;

  late List<FavouriteModel> favouriteModel;

  WeatherController weatherController = new WeatherController();
  LocationController locationController = new LocationController();
  late Position currentPosition;

  UserPreferences userPreferences = new UserPreferences();
  late Future _future;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: tabItems.length, vsync: this);
    firstRun();
    _future = getFunction();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: () {
      return Scaffold(
        body: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.data == "done") {
                return TabBarView(
                  children: [
                    Home(
                      weather: _weather,
                      address: address.toString(),
                      units: units.toString(),
                    ),
                    Favourite(
                      favouriteModel: favouriteModel,
                      units: units.toString(),
                    ),
                    Settings(
                      address: longAddress.toString(),
                      units: units.toString(),
                      weather: _weather,
                    )
                  ],
                  controller: controller,
                );
              } else if (snapshot.data == "failed") {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //icon
                      Image.asset(
                        "assets/images/icons/offline.ico",
                        height: 64.h,
                        width: 64.h,
                      ),

                      //Text
                      Text(
                        "You are currently offline",
                        style: TextStyle(
                            color: Color.fromRGBO(0, 35, 102, 1),
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                );
              }

              return Center(
                child: loading(),
              );
            }),
        bottomNavigationBar: Material(
          elevation: 0,
          child: TabBar(
            indicatorWeight: 2,
            indicatorColor: Color.fromRGBO(0, 35, 102, 1),
            indicatorPadding: EdgeInsets.zero,
            isScrollable: false,
            tabs: tabItems,
            controller: controller,
          ),
        ),
      );
    });
  }

  //Navigation
  List<BottomNavigationBarItem> items = [
    //Home
    BottomNavigationBarItem(
        icon: Image.asset(
          "assets/images/icons/home.ico",
          height: 30,
          width: 30,
        ),
        label: "Home"),

    //Favourite
    BottomNavigationBarItem(
        icon: Image.asset(
          "assets/images/icons/heart.ico",
          height: 30,
          width: 30,
        ),
        label: "Favourite"),

    //Current Location
    BottomNavigationBarItem(
        icon: Image.asset(
          "assets/images/icons/settings.ico",
          height: 30,
          width: 30,
        ),
        label: "More"),
  ];

  final tabItems = [
    Padding(
      padding: const EdgeInsets.all(10.0),
      child: Tab(
        icon: Image.asset(
          "assets/images/icons/home.ico",
          height: 30,
          width: 30,
        ),
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(10.0),
      child: Tab(
        icon: Image.asset(
          "assets/images/icons/heart.ico",
          height: 30,
          width: 30,
        ),
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(10.0),
      child: Tab(
        icon: Image.asset(
          "assets/images/icons/settings.ico",
          height: 30,
          width: 30,
        ),
      ),
    ),
  ];
  //Widgets

  Widget bottom() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: Color.fromRGBO(0, 35, 102, 1),
      items: items,
      iconSize: 24.sp,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      elevation: 0,
      currentIndex: pageIndex,
      onTap: (int i) => setState(() {
        pageIndex = i;
      }),
    );
  }

  Widget loading() {
    return Container(
      child: Lottie.asset("assets/images/weather_icons/splash.json",
          frameRate: FrameRate(60), height: 250.h, width: 250.w),
    );
  }

  firstRun() async {
    bool? firstTime = await userPreferences.isFirstTime();
    if (firstTime == true) {
      userPreferences.setUnits("metric");
      userPreferences.setFirstTime();
    }
  }

  Future getFunction() async {
    try {
      units = await userPreferences.getUnits();

      currentPosition = await LocationController().determinePosition();
      List<Placemark> _address = await placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);
      Placemark place = _address[0];
      address = place.locality;
      longAddress = "${place.locality}, ${place.country}";
      _weather = await weatherController.getOneCall(
          currentPosition.latitude, currentPosition.longitude, units);

      //get favourites
      favouriteModel = await DatabaseHelper.instance.getFavourite();

      return "done";
    } catch (e) {
      print(e.toString());
      return "failed";
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
