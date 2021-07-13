import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  MySharedPreferences._privateConstructor();

  static final MySharedPreferences instance =
      MySharedPreferences._privateConstructor();

  Future<bool> setStringValue(String key, String value) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.setString(key, value);
  }

  Future<String> getStringValue(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString(key) ?? "";
  }

  Future<bool> containsKey(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.containsKey(key);
  }

  removeValue(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.remove(key);
  }

  removeAll() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.clear();
  }
}

class Keys {
  static const String memberId = 'memberId';
  static const String displayPic = 'displayPic';
  static const String displayName = 'displayName';
  static const String userEmail = 'userEmail';
  static const String isPINAvailable = 'isPINAvailable';
  static const String dob = 'dob';
  static const String iD = 'iD';
  static const String dictationId = 'dictationId';
  static const String episodeId = 'episodeId';
  static const String episodeAppointmentRequestId ='episodeAppointmentRequestId';
  static const String memberRoleId = 'memberRoleId';
  static const String pin = 'pin';
  static const String isItFirstTime="isItFirstTime";
  static const String storedMemberPin="storedMemberPin";
  static const String roleName='roleName';
  static const String isPreferenceFinger = 'isPreferenceFinger';


}
