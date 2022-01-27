import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_icons/weather_icons.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: () {
      return Scaffold(
        backgroundColor: Color.fromARGB(255, 228, 228, 228),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  //search
                  searchBar(),
                  grid(),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget searchBar() {
    return Padding(
      padding: EdgeInsets.only(top: 100.0, left: 20.0, right: 20.0),
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              size: 30,
              color: Color.fromRGBO(0, 35, 102, 1),
            ),
            border: InputBorder.none,
            hintText: "Search",
            hintStyle: TextStyle(fontSize: 24.sp),
            contentPadding: EdgeInsets.all(10.0),
          ),
          cursorColor: Color.fromRGBO(0, 35, 102, 1),
          style:
              TextStyle(fontSize: 24.sp, color: Color.fromRGBO(0, 35, 102, 1)),
        ),
      ),
    );
  }

  Widget grid() {
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
              5,
              (index) {
                return Container(
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "18°",
                              style: TextStyle(
                                  fontSize: 46.sp,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Lilongwe",
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 35, 102, 1),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18.sp),
                                  ),
                                  Text(
                                    "Malawi",
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
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
                                    "18%",
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 35, 102, 1),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
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
                                    "7km/h",
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 35, 102, 1),
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
                );
              },
            )),
      ),
    );
  }
}
