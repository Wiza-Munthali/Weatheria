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
  final List<FavouriteModel> favouriteModel;
  final String units;
  const Favourite({Key? key, required this.favouriteModel, required this.units})
      : super(key: key);

  @override
  _FavouriteState createState() => _FavouriteState(favouriteModel, units);
}

class _FavouriteState extends State<Favourite> {
  _FavouriteState(this.favouriteModel, this.units);
  WeatherController weatherController = new WeatherController();
  WeatherConditions weatherConditions = new WeatherConditions();
  late List<FavouriteModel> favouriteModel;
  late List<CurrentWeather> currentWeather;
  late String units;
  late Future getFavs;

  @override
  void initState() {
    super.initState();
    //getFavs(favouriteModel[0].city, units);
    getFavs = loadFavourites();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: () {
      return Scaffold(
        backgroundColor: Color.fromARGB(255, 228, 228, 228),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: FutureBuilder(
                  future: getFavs,
                  builder: (context, snapshot) {
                    if (snapshot.data == "done") {
                      return grid();
                    } else if (snapshot.hasError) {}

                    return loading();
                  }),
            ),
          ),
        ),
      );
    });
  }

  Widget loading() {
    return Center(
      child: Container(
        child: Lottie.asset("assets/images/weather_icons/splash.json",
            frameRate: FrameRate(60), height: 250.h, width: 250.w),
      ),
    );
  }

  Widget grid() {
    if (favouriteModel.isNotEmpty) {
      return Container(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: GridView.count(
              shrinkWrap: false,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              crossAxisCount: 2,
              children: List.generate(
                favouriteModel.length + 1,
                (index) {
                  if (index < favouriteModel.length) {
                    return FocusedMenuHolder(
                      menuItems: <FocusedMenuItem>[
                        FocusedMenuItem(
                            title: Text(
                              "Delete",
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 35, 102, 1),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.sp),
                            ),
                            trailingIcon: Icon(
                              CupertinoIcons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              int i = await DatabaseHelper.instance
                                  .delete(favouriteModel[index].id!);
                              print(i);
                              setState(() {});
                            })
                      ],
                      duration: Duration(milliseconds: 10),
                      blurSize: 5.0,
                      menuBoxDecoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      animateMenuItems: true,
                      blurBackgroundColor: Colors.black54,
                      menuOffset:
                          10.0, // Offset value to show menuItem from the selected item
                      bottomOffsetHeight: 80.0,
                      onPressed: () {},
                      child: Container(
                        height: 40.h,
                        width: 40.w,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //Degree & Icon
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${currentWeather[index].main.temp.toString()}°",
                                    style: TextStyle(
                                        fontSize: 30.sp,
                                        color: Color.fromRGBO(0, 35, 102, 1),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: Container(
                                      child: Icon(
                                        WeatherIcons.day_cloudy,
                                        color: Color.fromRGBO(0, 35, 102, 1),
                                        size: 60,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          favouriteModel[index].city.toString(),
                                          style: TextStyle(
                                              color:
                                                  Color.fromRGBO(0, 35, 102, 1),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18.sp),
                                        ),
                                        Text(
                                          favouriteModel[index]
                                              .country
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.grey,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Icon(
                                          WeatherIcons.raindrop,
                                          color: Color.fromRGBO(0, 35, 102, 1),
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Text(
                                          "${currentWeather[index].main.humidity.toString()}%",
                                          style: TextStyle(
                                              color:
                                                  Color.fromRGBO(0, 35, 102, 1),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Icon(
                                          WeatherIcons.windy,
                                          color: Color.fromRGBO(0, 35, 102, 1),
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Text(
                                          "${currentWeather[index].wind.speed.toString()} ${weatherConditions.returnMeasurement(units)}",
                                          style: TextStyle(
                                              color:
                                                  Color.fromRGBO(0, 35, 102, 1),
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
                  return GestureDetector(
                    onTap: () async {
                      final sessionToken = Uuid().v4();
                      final Suggestion? result = await showSearch(
                        context: context,
                        delegate: AddressSearch(sessionToken),
                      );

                      if (result != null) {
                        PlaceApiProvider apiClient =
                            PlaceApiProvider(sessionToken);
                        Place d = await apiClient
                            .getPlaceDetailFromId((result.placeId));
                        print(d);

                        //save to db;
                        int i = await DatabaseHelper.instance.insert(
                            FavouriteModel(
                                city: d.city,
                                country: d.country,
                                latitude: d.latitude,
                                longitude: d.longitude));

                        print(i);
                        setState(() {});
                      }
                    },
                    child: Container(
                      height: 40.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                            child: Icon(
                              CupertinoIcons.add,
                              size: 60.sp,
                              color: Color.fromRGBO(0, 35, 102, 1),
                            ),
                          )),
                    ),
                  );
                },
              )),
        ),
      );
    }
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: GridView.count(
            shrinkWrap: false,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            crossAxisCount: 2,
            children: List.generate(1, (index) {
              return GestureDetector(
                onTap: () async {
                  final sessionToken = Uuid().v4();
                  final Suggestion? result = await showSearch(
                    context: context,
                    delegate: AddressSearch(sessionToken),
                  );

                  if (result != null) {
                    PlaceApiProvider apiClient = PlaceApiProvider(sessionToken);
                    Place d =
                        await apiClient.getPlaceDetailFromId((result.placeId));
                    print(d);

                    //save to db;
                    int i = await DatabaseHelper.instance.insert(FavouriteModel(
                        city: d.city,
                        country: d.country,
                        latitude: d.latitude,
                        longitude: d.longitude));

                    print(i);
                    setState(() {});
                  }
                },
                child: Container(
                  height: 40.h,
                  width: 40.w,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Icon(
                          CupertinoIcons.add,
                          size: 60.sp,
                          color: Color.fromRGBO(0, 35, 102, 1),
                        ),
                      )),
                ),
              );
            })),
      ),
    );
  }

  loadFavourites() async {
    if (favouriteModel.isNotEmpty) {
      for (int i = 0; i < favouriteModel.length; i++) {
        await weatherController
            .currentWeather(favouriteModel[i].city, units)
            .then((value) {
          currentWeather = [];
          currentWeather.add(value);
        }).onError((error, stackTrace) {
          print("error:$error");
        });
      }
    }

    return "done";
  }
}
