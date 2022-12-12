import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:weatheria/models/preferences.dart';

class Settings extends StatefulWidget {
  final String units;

  const Settings({
    Key? key,
    required this.units,
  }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState(units);
}

class _SettingsState extends State<Settings> {
  late String? units;

  late String? version = "";

  UserPreferences userPreferences = new UserPreferences();

  _SettingsState(this.units);
  @override
  void initState() {
    super.initState();
    getVersion();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: (context, child) {
      return SafeArea(
        child: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  brand(),
                  options(),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget brand() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2,
      child: Center(
        child: Image.asset(
          'assets/images/logo.png',
          height: MediaQuery.of(context).size.height / 3,
        ),
      ),
    );
  }

  Widget options() {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 56.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Measurements
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Title
                  Text("Measurements",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600)),

                  GestureDetector(
                    onTap: () => showOptionForUnits(context),
                    child: Container(
                      child: Row(
                        children: [
                          Text(units!,
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontSize: 16.sp,
                              )),
                          SizedBox(
                            width: 5.w,
                          ),
                          Icon(
                            CupertinoIcons.right_chevron,
                            size: 20,
                            color: Theme.of(context).colorScheme.onBackground,
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
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600)),

                  GestureDetector(
                    onTap: () => showCredits(context),
                    child: Container(
                      child: Row(
                        children: [
                          Text("See",
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontSize: 16.sp,
                              )),
                          SizedBox(
                            width: 5.w,
                          ),
                          Icon(
                            CupertinoIcons.right_chevron,
                            size: 20,
                            color: Theme.of(context).colorScheme.onBackground,
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
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600)),

                  GestureDetector(
                    onTap: () => showAboutDialog(context: context),
                    child: Container(
                      child: Row(
                        children: [
                          Text("See",
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontSize: 16.sp,
                              )),
                          SizedBox(
                            width: 5.w,
                          ),
                          Icon(
                            CupertinoIcons.right_chevron,
                            size: 20,
                            color: Theme.of(context).colorScheme.onBackground,
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
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600)),

                  GestureDetector(
                    onTap: () => showAppInfo(context),
                    child: Container(
                      child: Row(
                        children: [
                          Text("See",
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontSize: 16.sp,
                              )),
                          SizedBox(
                            width: 5.w,
                          ),
                          Icon(
                            CupertinoIcons.right_chevron,
                            size: 20,
                            color: Theme.of(context).colorScheme.onBackground,
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
      ),
    );
  }

  void showOptionForUnits(BuildContext context) {
    showDialog<Null>(
        context: context,
        builder: (context) {
          return Container(
            child: SimpleDialog(
              title: Text("Choose the measurements you prefer"),
              titleTextStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
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
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "(Fahrenheit, miles/hour)",
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
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
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "(Celsius, metre/sec)",
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
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
                  color: Theme.of(context).colorScheme.onBackground,
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
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500)),

                    //Third
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Heading
                          Text("Data Source",
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
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
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600)),
                                      Icon(
                                        CupertinoIcons.link,
                                        size: 14.sp,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
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
                    color: Theme.of(context).colorScheme.onBackground,
                    size: 24.sp,
                  )
                ],
              ),
              titleTextStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
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
                                color:
                                    Theme.of(context).colorScheme.onBackground,
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
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
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
                                color:
                                    Theme.of(context).colorScheme.onBackground,
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
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600)),
                                      Icon(
                                        CupertinoIcons.link,
                                        size: 14.sp,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
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
      launchUrl(link);
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
