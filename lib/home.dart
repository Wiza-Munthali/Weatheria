import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:weatheria/models/weather.dart';
import 'package:weatheria/models/weatherConditions.dart';
import 'package:weatheria/reusable/temp_chart.dart';
import 'package:weatheria/screens/next_seven.dart';

class Home extends StatefulWidget {
  final Weather weather;
  final String address;
  final String units;
  const Home(
      {Key? key,
      required this.weather,
      required this.address,
      required this.units})
      : super(key: key);

  @override
  _HomeState createState() => _HomeState(weather, address, units);
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  WeatherConditions weatherConditions = new WeatherConditions();
  late Weather _weather;
  late String? units;
  DateTime now = DateTime.now();
  DateFormat formattedDate = DateFormat("HH:mm a");
  String today = "";
  late Timer _timer;
  //Fields
  late String? address = "";

  _HomeState(this._weather, this.address, this.units);
  @override
  void initState() {
    today = formattedDate.format(now);
    super.initState();
    _timer =
        Timer.periodic(const Duration(milliseconds: 500), (timer) => _update());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _update() {
    setState(() {
      today = formattedDate.format(now);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return ScreenUtilInit(
        designSize: Size(_width, _height),
        builder: (context, child) {
          return Scaffold(
              body: Container(
            height: _height,
            width: _width,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(flex: 1, child: header()),
                          Expanded(flex: 4, child: infoForCurrentWeather()),
                          Expanded(flex: 3, child: riseAndSet()),
                        ],
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Container(
                      child: moreInfo(),
                    )),
              ],
            ),
          ));
        });
  }

  //Header
  Widget header() {
    return Container(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        //Location
        Container(
          child: Row(children: [
            Icon(
              FluentIcons.location_48_regular,
              size: 30.sp,
            ),
            SizedBox(
              width: 10.w,
            ),
            Text(
              address!.toString(),
              style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w600),
            )
          ]),
        ),

        //Current Time
        Container(
          child: Row(children: [
            Text(
              "Today ",
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w300),
            ),
            Text(
              today,
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w300),
            ),
          ]),
        ),
      ]),
    );
  }

  Widget infoForCurrentWeather() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Temp & Feeling
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${_weather.current.temp.toStringAsFixed(0)}°",
                  style:
                      TextStyle(fontSize: 120.sp, fontWeight: FontWeight.w700),
                ),
                Text(
                  capitalizeAllWord(
                      _weather.current.weatherElement[0].description),
                  style:
                      TextStyle(fontSize: 50.sp, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          //Wind Pressure & Humid
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //pressure
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        WeatherIcons.barometer,
                        size: 26.sp,
                      ),
                      Text(
                        _weather.current.pressure.toStringAsFixed(0),
                        style: TextStyle(
                            fontSize: 26.sp, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),

                //Humid
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        WeatherIcons.raindrop,
                        size: 26.sp,
                      ),
                      Text(
                        _weather.current.humidity.toStringAsFixed(0),
                        style: TextStyle(
                            fontSize: 26.sp, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),

                //wind speed

                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        WeatherIcons.windy,
                        size: 26.sp,
                      ),
                      Text(
                        _weather.current.windSpeed.toStringAsFixed(0),
                        style: TextStyle(
                            fontSize: 26.sp, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget riseAndSet() {
    return Container(
      padding: const EdgeInsets.only(left: 35, right: 25, top: 20),
      decoration: BoxDecoration(
          color: Colors.black45, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Temperature",
            style: TextStyle(fontSize: 34.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 30.h,
          ),
          Expanded(
            child: TempChart(
              dailyTemp: _weather.daily[0].temp,
            ),
          ),
        ],
      ),
    );
  }

  Widget moreInfo() {
    return Padding(
      padding: EdgeInsets.only(top: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Heading
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today",
                  style: TextStyle(
                      fontSize: 30.sp,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
                TextButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => NextSeven(
                                  location: address!.toString(),
                                  weather: _weather,
                                )))),
                    child: Text(
                      "Next 7 Days",
                      style: TextStyle(
                          fontSize: 30.sp,
                          color: Colors.grey,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          //Info
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                padding: EdgeInsets.only(left: 20, right: 20),
                scrollDirection: Axis.horizontal,
                shrinkWrap: false,
                itemCount: _weather.hourly.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Container();
                  } else {
                    var time =
                        weatherConditions.returndate(_weather.hourly[index].dt);
                    var degree =
                        "${_weather.hourly[index].temp.toStringAsFixed(0)}°";

                    var icon = weatherConditions.returnIcon(
                        _weather.hourly[index].weatherElement[0].icon);
                    return customMore(time, icon, degree);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  //More info custom widget
  Widget customMore(time, icon, degrees) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Time
            Text(
              "$time",
              style: TextStyle(
                  fontSize: 20.sp,
                  color: Color.fromRGBO(0, 35, 102, 1),
                  fontWeight: FontWeight.w600),
            ),

            SizedBox(
              height: 15.h,
            ),
            //Icon
            FittedBox(
              fit: BoxFit.fill,
              child: ClipRect(
                child: Container(
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
              ),
            ),

            SizedBox(
              height: 15.h,
            ),
            //Degree
            Text(
              degrees,
              style: TextStyle(
                  fontSize: 24.sp,
                  color: Color.fromRGBO(0, 35, 102, 1),
                  fontWeight: FontWeight.normal),
            )
          ],
        ),
      ),
    );
  }

  //Other Day forecast
  Widget weekForecast() {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20, top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
            ),
            child: Text(
              "Rest of the week",
              style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 200.h,
            child: ListView.builder(
              shrinkWrap: false,
              itemCount: _weather.daily.length,
              itemBuilder: (BuildContext context, int index) {
                var date = weatherConditions
                    .returnStringDate(_weather.daily[index].dt);
                var icon = weatherConditions
                    .returnIcon(_weather.daily[index].weatherElement[0].icon);
                var degreeHigh = _weather.daily[index].temp.max;
                var degreeLow = _weather.daily[index].temp.min;

                if (index != 0) {
                  return weekForecastCustom(date, icon, degreeHigh, degreeLow);
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  //Custom Weekly Forecast widget

  Widget weekForecastCustom(date, icon, degreeHigh, degreeLow) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //day
            Container(
              width: 110.w,
              child: Text(
                date,
                style: TextStyle(
                    fontSize: 20.sp,
                    color: Color.fromRGBO(0, 35, 102, 1),
                    fontWeight: FontWeight.normal),
              ),
            ),

            //icon
            Container(
              child: FittedBox(
                fit: BoxFit.fill,
                child: ClipRect(
                  child: Container(
                    child: Align(
                      alignment: Alignment(0, 0),
                      widthFactor: 0.6,
                      heightFactor: 0.5,
                      child: Image.network(
                        icon,
                        height: 40.h,
                        width: 40.h,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            //degress
            Container(
              width: 110.w,
              child: Row(
                children: [
                  //High
                  Text(
                    "$degreeLow°",
                    style: TextStyle(
                        fontSize: 24.sp,
                        color: Color.fromRGBO(2, 35, 102, 1),
                        fontWeight: FontWeight.normal),
                  ),

                  SizedBox(
                    width: 10.0,
                  ),
                  //Low
                  Text(
                    "$degreeHigh°",
                    style: TextStyle(
                        fontSize: 24.sp,
                        color: Color.fromRGBO(0, 35, 102, 1),
                        fontWeight: FontWeight.normal),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String capitalizeAllWord(String value) {
  var result = value[0].toUpperCase();
  for (int i = 1; i < value.length; i++) {
    if (value[i - 1] == " ") {
      result = result + value[i].toUpperCase();
    } else {
      result = result + value[i];
    }
  }
  return result;
}
