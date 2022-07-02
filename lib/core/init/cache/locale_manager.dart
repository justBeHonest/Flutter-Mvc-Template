// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import '../../constants/enums/preferences_keys.dart';

abstract class ILocaleManager {
  String? getStringValue(PreferencesKeys keys);
  Future<bool>? setStringValue(PreferencesKeys keys, String value);
}

class LocaleManager implements ILocaleManager {
  static LocaleManager? _instance;
  SharedPreferences? _preferences;

  LocaleManager._();

  static Future<void> initSharedPrefences() async {
    if (LocaleManager.instance._preferences != null) return;
    LocaleManager.instance._preferences = await SharedPreferences.getInstance();
  }

  static LocaleManager get instance {
    if (_instance != null) {
      return _instance!;
    }
    _instance = LocaleManager._();
    return _instance!;
  }

  @override
  Future<bool>? setStringValue(PreferencesKeys keys, String value) async {
    return await _preferences?.setString(keys.toString(), value) ?? false;
  }

  String? getStringValue(PreferencesKeys key) =>
      _preferences?.getString(key.toString()) ?? "";

  Future get({required String cname}) async {
    return _preferences?.get(cname);
  }

  Future set({
    required String cname,
    required String cvalue,
  }) async {
    await _preferences?.setString(cname, cvalue);
  }

  remove({required String cname}) {
    _preferences?.remove(cname);
  }

  logOut() {
    LocaleManager.instance.remove(cname: "jwt");
  }
}
