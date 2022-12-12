import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:weatheria/controllers/databaseHelper.dart';
import 'package:weatheria/screens/favorite/favourite.dart';
import 'package:weatheria/models/preferences.dart';
import 'package:weatheria/screens/map/map.dart';
import 'package:weatheria/settings.dart';

import 'controllers/locationCotroller.dart';
import 'controllers/weatherController.dart';
import 'home.dart';
import 'models/weather.dart';

late ObjectBox objectBox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectBox = await ObjectBox.create();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          useMaterial3: true,
          fontFamily: "Nunito",
          colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: Color(0xFF894486),
            onPrimary: Color(0xFFFFFFFF),
            primaryContainer: Color(0xFFFFD7F6),
            onPrimaryContainer: Color(0xFF380039),
            secondary: Color(0xFF6D5869),
            onSecondary: Color(0xFFFFFFFF),
            secondaryContainer: Color(0xFFF7DAEF),
            onSecondaryContainer: Color(0xFF261625),
            tertiary: Color(0xFF9C413C),
            onTertiary: Color(0xFFFFFFFF),
            tertiaryContainer: Color(0xFFFFDAD6),
            onTertiaryContainer: Color(0xFF410003),
            error: Color(0xFFBA1A1A),
            errorContainer: Color(0xFFFFDAD6),
            onError: Color(0xFFFFFFFF),
            onErrorContainer: Color(0xFF410002),
            background: Color(0xFFFFFBFF),
            onBackground: Color(0xFF1E1A1D),
            surface: Color(0xFFFFFBFF),
            onSurface: Color(0xFF1E1A1D),
            surfaceVariant: Color(0xFFEEDEE7),
            onSurfaceVariant: Color(0xFF4E444B),
            outline: Color(0xFF7F747C),
            onInverseSurface: Color(0xFFF8EEF2),
            inverseSurface: Color(0xFF342F32),
            inversePrimary: Color(0xFFFEABF5),
            shadow: Color(0xFF000000),
            surfaceTint: Color(0xFF894486),
          )),
      darkTheme: ThemeData(
          useMaterial3: true,
          fontFamily: "Nunito",
          colorScheme: ColorScheme(
            brightness: Brightness.dark,
            primary: Color(0xFFFEABF5),
            onPrimary: Color(0xFF541354),
            primaryContainer: Color(0xFF6E2C6C),
            onPrimaryContainer: Color(0xFFFFD7F6),
            secondary: Color(0xFFDABFD3),
            onSecondary: Color(0xFF3D2B3A),
            secondaryContainer: Color(0xFF544151),
            onSecondaryContainer: Color(0xFFF7DAEF),
            tertiary: Color(0xFFFFB3AD),
            onTertiary: Color(0xFF5F1413),
            tertiaryContainer: Color(0xFF7E2A27),
            onTertiaryContainer: Color(0xFFFFDAD6),
            error: Color(0xFFFFB4AB),
            errorContainer: Color(0xFF93000A),
            onError: Color(0xFF690005),
            onErrorContainer: Color(0xFFFFDAD6),
            background: Color(0xFF1E1A1D),
            onBackground: Color(0xFFE9E0E4),
            surface: Color(0xFF1E1A1D),
            onSurface: Color(0xFFE9E0E4),
            surfaceVariant: Color(0xFF4E444B),
            onSurfaceVariant: Color(0xFFD1C3CB),
            outline: Color(0xFF9A8D95),
            onInverseSurface: Color(0xFF1E1A1D),
            inverseSurface: Color(0xFFE9E0E4),
            inversePrimary: Color(0xFF894486),
            shadow: Color(0xFF000000),
            surfaceTint: Color(0xFFFEABF5),
          )),
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

  WeatherController weatherController = new WeatherController();
  LocationController locationController = new LocationController();
  late Position currentPosition;

  UserPreferences userPreferences = new UserPreferences();
  late Future _future;

  late BuildContext cxt;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
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
    cxt = context;
    return ScreenUtilInit(builder: (context, child) {
      return Scaffold(
        body: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.data == "done") {
                return TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Home(
                      weather: _weather,
                      address: address.toString(),
                      units: units.toString(),
                    ),
                    Map(
                      addressName: address.toString(),
                      weather: _weather,
                      units: units.toString(),
                      database: objectBox,
                    ),
                    FavoritePage(units: units.toString(), database: objectBox),
                    Settings(
                      units: units.toString(),
                    )
                  ],
                  controller: controller,
                );
              } else if (snapshot.data == "failed") {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Text
                      Text(
                        "You are currently offline",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
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
            labelColor: Theme.of(context).colorScheme.onBackground,
            indicatorColor: Theme.of(context).colorScheme.primary,
            indicatorPadding: EdgeInsets.zero,
            isScrollable: false,
            tabs: tabItems,
            controller: controller,
          ),
        ),
      );
    });
  }

  final tabItems = [
    Padding(
      padding: const EdgeInsets.all(10.0),
      child: Tab(
        icon: Icon(FluentIcons.home_48_regular),
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(10.0),
      child: Tab(
        icon: Icon(FluentIcons.map_24_regular),
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(10.0),
      child: Tab(
        icon: Icon(FluentIcons.heart_48_regular),
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(10.0),
      child: Tab(
        icon: Icon(FluentIcons.settings_48_regular),
      ),
    ),
  ];
  //Widgets

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
      units = await userPreferences.getUnits() ?? "metric";

      currentPosition = await LocationController().determinePosition();
      List<Placemark> _address = await placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);
      Placemark place = _address[0];
      address = place.locality;
      longAddress = "${place.locality}, ${place.country}";
      _weather = await weatherController.getOneCall(
          currentPosition.latitude, currentPosition.longitude, units);
      print("weather: $_weather");
      //get favourites

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
