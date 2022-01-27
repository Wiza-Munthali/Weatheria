import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:weatheria/models/preferences.dart';
import 'package:weatheria/models/weather.dart';
import 'package:weatheria/models/weatherConditions.dart';

import 'controllers/locationCotroller.dart';

class Settings extends StatefulWidget {
  final String address;
  final String units;
  final Weather weather;
  const Settings(
      {Key? key,
      required this.address,
      required this.units,
      required this.weather})
      : super(key: key);

  @override
  _SettingsState createState() => _SettingsState(address, units, weather);
}

class _SettingsState extends State<Settings> {
  late String address = "";
  late String? units;
  late Weather _weather;
  late String? version = "";
  late Position currentPosition;
  LocationController locationController = new LocationController();
  WeatherConditions weatherConditions = new WeatherConditions();
  UserPreferences userPreferences = new UserPreferences();

  _SettingsState(this.address, this.units, this._weather);
  @override
  void initState() {
    super.initState();
    getVersion();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: () {
      return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [header(), currentWeather(), options()],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget header() {
    return Container(
      child: Column(
        children: [
          //text
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.location_circle,
                color: Colors.grey,
              ),
              SizedBox(
                width: 5.w,
              ),
              Text("Your location now",
                  style: TextStyle(color: Colors.grey, fontSize: 20.sp)),
            ],
          ),

          //Location
          Text(
            address.toString(),
            style: TextStyle(
                color: Color.fromRGBO(0, 35, 102, 1),
                fontSize: 30.sp,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget currentWeather() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Container(
        child: Column(
          children: [
            //Lottie
            Container(
              child: Lottie.asset(
                  weatherConditions.returnImage(
                      _weather.current.weatherElement[0].description),
                  frameRate: FrameRate(60),
                  height: 200.h,
                  width: 200.w),
            ),
            SizedBox(
              height: 10.h,
            ),
            //desc
            Text(_weather.current.weatherElement[0].description,
                style: TextStyle(
                    color: Color.fromRGBO(0, 35, 102, 1),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600)),

            Tooltip(
              message: "Degrees",
              child: Text("${_weather.current.temp}°",
                  style: TextStyle(
                      color: Color.fromRGBO(0, 35, 102, 1),
                      fontSize: 100.sp,
                      fontWeight: FontWeight.bold)),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Humidity
                Tooltip(
                  message: "Humidity",
                  child: Container(
                    child: Row(
                      children: [
                        //Icon
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Container(
                            child: Icon(
                              WeatherIcons.raindrop,
                              color: Color.fromRGBO(0, 35, 102, 1),
                              size: 18.sp,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        //Words
                        Text(
                          "${_weather.current.humidity}%",
                          style: TextStyle(
                              fontSize: 18.sp,
                              color: Color.fromRGBO(0, 35, 102, 1),
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),

                //mBar
                Tooltip(
                  message: "Pressure",
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        //Icon
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Icon(
                            WeatherIcons.barometer,
                            color: Color.fromRGBO(0, 35, 102, 1),
                            size: 18.sp,
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        //Words
                        Text(
                          "${_weather.current.pressure} hPa",
                          style: TextStyle(
                              fontSize: 18.sp,
                              color: Color.fromRGBO(0, 35, 102, 1),
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),

                //wind
                Tooltip(
                  message: "Wind Speed",
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        //Icon
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Icon(
                            WeatherIcons.windy,
                            color: Color.fromRGBO(0, 35, 102, 1),
                            size: 18.sp,
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        //Words
                        Text(
                          "${_weather.current.windSpeed} ${weatherConditions.returnMeasurement(units)}",
                          style: TextStyle(
                              fontSize: 18.sp,
                              color: Color.fromRGBO(0, 35, 102, 1),
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget options() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Column(
          children: [
            //Measurements
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Title
                Text("Measurements",
                    style: TextStyle(
                        color: Color.fromRGBO(0, 35, 102, 1),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600)),

                GestureDetector(
                  onTap: () => showOptionForUnits(context),
                  child: Container(
                    child: Row(
                      children: [
                        Text(units!,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.sp,
                            )),
                        SizedBox(
                          width: 5.w,
                        ),
                        Icon(
                          CupertinoIcons.right_chevron,
                          size: 20,
                          color: Colors.grey,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 30.h,
            ),
            //Credit
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Title
                Text("Credits",
                    style: TextStyle(
                        color: Color.fromRGBO(0, 35, 102, 1),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600)),

                GestureDetector(
                  onTap: () => showCredits(context),
                  child: Container(
                    child: Row(
                      children: [
                        Text("See",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.sp,
                            )),
                        SizedBox(
                          width: 5.w,
                        ),
                        Icon(
                          CupertinoIcons.right_chevron,
                          size: 20,
                          color: Colors.grey,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 30.h,
            ),
            //Licenses
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Title
                Text("Licenses",
                    style: TextStyle(
                        color: Color.fromRGBO(0, 35, 102, 1),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600)),

                GestureDetector(
                  onTap: () => showAboutDialog(context: context),
                  child: Container(
                    child: Row(
                      children: [
                        Text("See",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.sp,
                            )),
                        SizedBox(
                          width: 5.w,
                        ),
                        Icon(
                          CupertinoIcons.right_chevron,
                          size: 20,
                          color: Colors.grey,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 30.h,
            ),
            //App Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Title
                Text("App info.",
                    style: TextStyle(
                        color: Color.fromRGBO(0, 35, 102, 1),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600)),

                GestureDetector(
                  onTap: () => showAppInfo(context),
                  child: Container(
                    child: Row(
                      children: [
                        Text("See",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.sp,
                            )),
                        SizedBox(
                          width: 5.w,
                        ),
                        Icon(
                          CupertinoIcons.right_chevron,
                          size: 20,
                          color: Colors.grey,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  getStuff() async {
    try {
      units = await userPreferences.getUnits();

      currentPosition = await LocationController().determinePosition();
      List<Placemark> _address = await placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);
      Placemark place = _address[0];
      setState(() {
        address = "${place.locality}, ${place.country}";
      });
      print(place);
    } catch (e) {
      print(e.toString());
    }
  }

  void showOptionForUnits(BuildContext context) {
    showDialog<Null>(
        context: context,
        builder: (context) {
          return Container(
            child: SimpleDialog(
              title: Text("Choose the measurements you prefer"),
              titleTextStyle: TextStyle(
                  color: Color.fromRGBO(0, 35, 102, 1),
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700),
              contentPadding: EdgeInsets.all(20.0),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SimpleDialogOption(
                      onPressed: () {
                        var value = "imperial";
                        updatePreferences(value);
                      },
                      padding: EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Imperial",
                            style: TextStyle(
                                color: Color.fromRGBO(0, 35, 102, 1),
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "(Fahrenheit, miles/hour)",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        var value = "metric";
                        updatePreferences(value);
                      },
                      padding: EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Metric",
                            style: TextStyle(
                                color: Color.fromRGBO(0, 35, 102, 1),
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "(Celsius, metre/sec)",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  void showCredits(BuildContext context) {
    showDialog<Null>(
        context: context,
        builder: (context) {
          return Container(
            child: SimpleDialog(
              title: Text("Credits"),
              titleTextStyle: TextStyle(
                  color: Color.fromRGBO(0, 35, 102, 1),
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700),
              contentPadding: EdgeInsets.all(20.0),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Opening statement
                    Text(
                        "Here is a list of the resources used and their owners.",
                        style: TextStyle(
                            color: Color.fromRGBO(0, 35, 102, 1),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500)),

                    //first resource
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Heading
                          Text("Icons",
                              style: TextStyle(
                                color: Color.fromRGBO(0, 35, 102, 1),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                              )),

                          SizedBox(
                            height: 10.h,
                          ),

                          Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () =>
                                      launchBrowser("https://icons8.com/"),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Fluent Icons by Icons8",
                                          style: TextStyle(
                                              color:
                                                  Color.fromRGBO(0, 35, 102, 1),
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600)),
                                      Icon(
                                        CupertinoIcons.link,
                                        size: 14.sp,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                GestureDetector(
                                  onTap: () => launchBrowser(
                                      "https://openweathermap.org/"),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Weather Icons by OpenWeatherMap",
                                          style: TextStyle(
                                              color:
                                                  Color.fromRGBO(0, 35, 102, 1),
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600)),
                                      Icon(
                                        CupertinoIcons.link,
                                        size: 14.sp,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    //second
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Heading
                          Text("Animations",
                              style: TextStyle(
                                color: Color.fromRGBO(0, 35, 102, 1),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                              )),

                          SizedBox(
                            height: 10.h,
                          ),

                          Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () => launchBrowser(
                                      "https://lottiefiles.com/rkyy33389gmail.com"),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "Lottie Files - Weather pack by Tilfe (@Tilfe)",
                                          style: TextStyle(
                                              color:
                                                  Color.fromRGBO(0, 35, 102, 1),
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600)),
                                      Icon(
                                        CupertinoIcons.link,
                                        size: 14.sp,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                GestureDetector(
                                  onTap: () => launchBrowser(
                                      "https://lottiefiles.com/user/743360"),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "Lottie Files - Weather by Luis Pena (@Yosif)",
                                          style: TextStyle(
                                              color:
                                                  Color.fromRGBO(0, 35, 102, 1),
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600)),
                                      Icon(
                                        CupertinoIcons.link,
                                        size: 14.sp,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    //Third
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Heading
                          Text("Data Source",
                              style: TextStyle(
                                color: Color.fromRGBO(0, 35, 102, 1),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                              )),

                          SizedBox(
                            height: 10.h,
                          ),

                          Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () => launchBrowser(
                                      "https://openweathermap.org/"),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Weather data by OpenWeatherMap",
                                          style: TextStyle(
                                              color:
                                                  Color.fromRGBO(0, 35, 102, 1),
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600)),
                                      Icon(
                                        CupertinoIcons.link,
                                        size: 14.sp,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  void showAppInfo(BuildContext context) {
    showDialog<Null>(
        context: context,
        builder: (context) {
          return Container(
            child: SimpleDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("App Info"),
                  Icon(
                    CupertinoIcons.info_circle,
                    color: Color.fromRGBO(0, 35, 102, 1),
                    size: 24.sp,
                  )
                ],
              ),
              titleTextStyle: TextStyle(
                  color: Color.fromRGBO(0, 35, 102, 1),
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700),
              contentPadding: EdgeInsets.all(20.0),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //first resource
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Heading
                          Text("App Version",
                              style: TextStyle(
                                color: Color.fromRGBO(0, 35, 102, 1),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                              )),

                          SizedBox(
                            height: 5.h,
                          ),

                          Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(version.toString(),
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(0, 35, 102, 1),
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    //second
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Heading
                          Text("Creator",
                              style: TextStyle(
                                color: Color.fromRGBO(0, 35, 102, 1),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                              )),

                          SizedBox(
                            height: 5.h,
                          ),

                          Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () => launchBrowser(
                                      "https://www.linkedin.com/in/wiza-munthali-121919184/"),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Wiza Munthali",
                                          style: TextStyle(
                                              color:
                                                  Color.fromRGBO(0, 35, 102, 1),
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600)),
                                      Icon(
                                        CupertinoIcons.link,
                                        size: 14.sp,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Future<void> launchBrowser(link) async {
    try {
      launch(link);
    } catch (e) {}
  }

  updatePreferences(value) async {
    units = value;
    bool done = await userPreferences.setUnits(value);
    if (done) {
      setState(() {
        Navigator.pop(context);
        final snackBar = SnackBar(
          content: Text("successfully updated measurements"),
          duration: Duration(seconds: 3),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    } else {
      setState(() {
        Navigator.pop(context);
        final snackBar = SnackBar(
          content: Text("Something went wrong, please try again"),
          duration: Duration(seconds: 3),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }

  getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String ver = packageInfo.version;
    print(ver);
    version = ver;
  }
}
