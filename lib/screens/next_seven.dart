import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:weatheria/models/weather.dart';
import 'package:weatheria/models/weatherConditions.dart';

class NextSeven extends StatefulWidget {
  final String location;
  final Weather weather;
  const NextSeven({super.key, required this.location, required this.weather});

  @override
  State<NextSeven> createState() => _NextSevenState(location, weather);
}

class _NextSevenState extends State<NextSeven> {
  final String location;
  final Weather weather;
  WeatherConditions weatherConditions = new WeatherConditions();
  DateTime now = DateTime.now();
  DateFormat todayDate = DateFormat("d-MM-yyyy");

  _NextSevenState(this.location, this.weather);
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return ScreenUtilInit(
        designSize: Size(_width, _height),
        builder: ((context, child) => Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(FluentIcons.arrow_left_48_regular),
                  onPressed: (() => Navigator.pop(context)),
                ),
                centerTitle: true,
                title: Text(
                  location,
                  style:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 30.sp),
                ),
              ),
              body: Container(
                child: Column(
                  children: [
                    Expanded(flex: 1, child: moreInfo()),
                    Expanded(flex: 3, child: restOfTheWeek(_width)),
                  ],
                ),
              ),
            )));
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
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.bold),
                ),
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
                itemCount: weather.hourly.length,
                itemBuilder: (BuildContext context, int index) {
                  var time =
                      weatherConditions.returndate(weather.hourly[index].dt);
                  var degree =
                      "${weather.hourly[index].temp.toStringAsFixed(0)}°";

                  var icon = weatherConditions
                      .returnIcon(weather.hourly[index].weatherElement[0].icon);
                  if (index == 0) {
                    return Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            borderRadius: BorderRadius.circular(10)),
                        child: customMore(time, icon, degree));
                  } else {
                    var today = todayDate.format(now);
                    var y = DateTime.fromMillisecondsSinceEpoch(
                        weather.hourly[index].dt * 1000);
                    var x = todayDate.format(y);
                    if (x == today) {
                      return customMore(time, icon, degree);
                    } else {
                      return SizedBox.shrink();
                    }
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
      padding: const EdgeInsets.only(top: 20.0, right: 20, left: 20),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Time
            Text(
              "$time",
              style: TextStyle(
                  fontSize: 20.sp,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
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
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.normal),
            )
          ],
        ),
      ),
    );
  }

  //Rest of the Days
  Widget restOfTheWeek(double width) {
    return Container(
      width: width,
      child: ListView.builder(
          itemCount: weather.daily.length,
          itemBuilder: ((context, index) {
            if (index == 0) {
              return SizedBox.shrink();
            } else if (index == 1) {
              return restOfTheWeekWidget(width, weather.daily[index], true);
            }

            return restOfTheWeekWidget(width, weather.daily[index], false);
          })),
    );
  }

  Widget restOfTheWeekWidget(double width, Daily daily, bool tomorrow) {
    DateTime newDate = DateTime.fromMillisecondsSinceEpoch(daily.dt * 1000);
    DateFormat dateFormat = DateFormat("d MMM");
    DateFormat dayFormat = DateFormat.EEEE();
    String dayOfTheWeek = tomorrow ? "Tomorrow" : dayFormat.format(newDate);
    var icon = weatherConditions.returnIcon(daily.weatherElement[0].icon);
    return Container(
      padding: const EdgeInsets.all(20),
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Day and Date
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dayOfTheWeek,
                  style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onBackground),
                ),
                Text(dateFormat.format(newDate),
                    style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.onBackground)),
              ],
            ),
          ),
          //Temp
          Expanded(
            child: Text("${daily.temp.max.toStringAsFixed(0)}°",
                style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onBackground)),
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
                    height: 100.h,
                    width: 100.h,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
