import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:weatheria/models/weather.dart';
import 'package:weatheria/models/weatherConditions.dart';

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

  //Fields
  late String? address = "";

  _HomeState(this._weather, this.address, this.units);
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: () {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //Header
                  header(),

                  //2nd Line
                  infoForCurrentWeather(),

                  SizedBox(
                    height: 20.h,
                  ),
                  //3rd line
                  riseAndSet(),
                  SizedBox(
                    height: 20.h,
                  ),

                  moreInfo(),

                  //forecast

                  weekForecast(),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  //Header
  Widget header() {
    return Padding(
      padding: const EdgeInsets.only(top: 100.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Area
                Text(
                  address.toString(),
                  style: TextStyle(
                      fontSize: 26.sp,
                      color: Color.fromRGBO(0, 35, 102, 1),
                      fontWeight: FontWeight.bold),
                ),

                //Degrees
                Text(
                  "${_weather.current.temp.toString()}°",
                  style: TextStyle(
                      fontSize: 45.sp, color: Color.fromRGBO(0, 35, 102, 1)),
                ),

                //Condition Pill
                Chip(
                  label: Text(
                    _weather.current.weatherElement[0].description,
                    style: TextStyle(
                        fontSize: 20.sp, color: Color.fromRGBO(0, 35, 102, 1)),
                  ),
                  labelPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 40.0),
            child: Container(
              child: Lottie.asset(
                  weatherConditions.returnImage(
                    _weather.current.weatherElement[0].description,
                  ),
                  frameRate: FrameRate(60),
                  height: 150.h,
                  width: 150.w),
            ),
          ),
        ],
      ),
    );
  }

  Widget infoForCurrentWeather() {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Humidity
          Tooltip(
            message: "Humidity",
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //Icon
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Icon(
                      WeatherIcons.raindrop,
                      color: Color.fromRGBO(0, 35, 102, 1),
                      size: 18.sp,
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
    );
  }

  Widget riseAndSet() {
    return Padding(
      padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Rise
            Tooltip(
              message: "Sunrise",
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Icon(
                      WeatherIcons.sunrise,
                      color: Color.fromRGBO(0, 35, 102, 1),
                      size: 18.sp,
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Text(
                    "${weatherConditions.returndate(_weather.current.sunrise)}",
                    style: TextStyle(
                        fontSize: 18.sp,
                        color: Color.fromRGBO(0, 35, 102, 1),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            //Set
            Tooltip(
              message: "Sunset",
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Icon(
                      WeatherIcons.sunset,
                      color: Color.fromRGBO(0, 35, 102, 1),
                      size: 18.sp,
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Text(
                    "${weatherConditions.returndate(_weather.current.sunset)}",
                    style: TextStyle(
                        fontSize: 18.sp,
                        color: Color.fromRGBO(0, 35, 102, 1),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
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
          Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
            ),
            child: Text(
              "Next 48 Hours",
              style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
            ),
          ),
          //Info
          Container(
            width: MediaQuery.of(context).size.width,
            height: 120.h,
            child: ListView.builder(
              padding: EdgeInsets.all(20),
              scrollDirection: Axis.horizontal,
              shrinkWrap: false,
              itemCount: _weather.hourly.length,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Container();
                } else {
                  var time =
                      weatherConditions.returndate(_weather.hourly[index].dt);
                  var degree = "${_weather.hourly[index].temp}°";

                  var icon = weatherConditions.returnIcon(
                      _weather.hourly[index].weatherElement[0].icon);
                  return customMore(time, icon, degree);
                }
              },
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
        height: 70.h,
        width: 70.w,
        child: Column(
          children: [
            //Time
            Text(
              "$time",
              style: TextStyle(
                  fontSize: 18.sp,
                  color: Color.fromRGBO(0, 35, 102, 1),
                  fontWeight: FontWeight.w600),
            ),

            SizedBox(
              height: 15,
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
                      height: 40.h,
                      width: 40.h,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 15,
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
