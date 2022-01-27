import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  String unitsString = "units";

  Future<bool?> isFirstTime() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? ft = preferences.getBool("firstTime");
    if (ft != null) {
      return ft;
    } else {
      return true;
    }
  }

  Future<bool?> setFirstTime() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setBool("firstTime", false);
  }

  Future<String?> getUnits() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(unitsString);
  }

  Future setUnits(unit) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(unitsString, unit);
  }
}
