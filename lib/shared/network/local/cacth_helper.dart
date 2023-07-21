import 'package:shared_preferences/shared_preferences.dart';

class CacthHelper {
  static SharedPreferences? sharedPreferences;

  static inti() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<bool> putData({required String key, required bool value}) async {
    return await sharedPreferences!.setBool(key, value);
  }

  static Future<bool?> saveData(String key, dynamic value) async {
    if (value is String) {
      return await sharedPreferences!.setString(key, value);
    }
    if (value is int) {
      return await sharedPreferences!.setInt(key, value);
    }
    if (value is bool) {
      return await sharedPreferences!.setBool(key, value);
    }
    return await sharedPreferences!.setDouble(key, value);
  }

  static dynamic get_Data({required String key}) {
    return sharedPreferences!.get(key);
  }

  static Future<bool> Clear(String key) async {
    return await sharedPreferences!.remove(key);
  }
}