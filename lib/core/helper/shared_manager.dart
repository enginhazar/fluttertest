import 'package:shared_preferences/shared_preferences.dart';

class SharedManager {
  SharedPreferences _preferences;

  static SharedManager instance = SharedManager._privateConstructer();

  SharedManager._privateConstructer() {
    init();
  }

  static Future<void> init() async {
    instance._preferences = await SharedPreferences.getInstance();
  }

  String getString(SharedEnum key) => _preferences.get(key.toString()) ?? "";

  Future<void> setString(SharedEnum key, String value) async =>
      await _preferences.setString(key.toString(), value);
}

enum SharedEnum { TOKEN }
