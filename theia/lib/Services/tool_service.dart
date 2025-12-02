import 'package:shared_preferences/shared_preferences.dart';

class ToolService {
  static const String _nameKey = 'user_name';
  static const String _heightKey = 'user_height';
  static const String _unitsKey = 'preferred_units';
  static const String _emergencyContactKey = 'emergency_contact';
  static const String _emergencyPhoneKey = 'emergency_phone';
  static const String _talkBackSpeedKey = 'talk_back_speed';
  static const String _languageKey = 'language';

  static Future<Map<String, String?>> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_nameKey),
      'height': prefs.getString(_heightKey),
      'units': prefs.getString(_unitsKey) ?? 'imperial',
      'emergencyContact': prefs.getString(_emergencyContactKey),
      'emergencyPhone': prefs.getString(_emergencyPhoneKey),
      'talkBackSpeed': prefs.getString(_talkBackSpeedKey) ?? 'normal',
      'language': prefs.getString(_languageKey) ?? 'english',
    };
  }

  static Future<void> saveSettings({
    String? name,
    String? height,
    String? units,
    String? emergencyContact,
    String? emergencyPhone,
    String? talkBackSpeed,
    String? language,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (name != null) {
      await prefs.setString(_nameKey, name);
    }
    if (height != null) {
      await prefs.setString(_heightKey, height);
    }
    if (units != null) {
      await prefs.setString(_unitsKey, units);
    }
    if (emergencyContact != null) {
      await prefs.setString(_emergencyContactKey, emergencyContact);
    }
    if (emergencyPhone != null) {
      await prefs.setString(_emergencyPhoneKey, emergencyPhone);
    }
    if (talkBackSpeed != null) {
      await prefs.setString(_talkBackSpeedKey, talkBackSpeed);
    }
    if (language != null) {
      await prefs.setString(_languageKey, language);
    }
  }

  static Future<void> saveAllSettings({
    required String name,
    required String height,
    required String units,
    required String emergencyContact,
    required String emergencyPhone,
    required String talkBackSpeed,
    required String language,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
    await prefs.setString(_heightKey, height);
    await prefs.setString(_unitsKey, units);
    await prefs.setString(_emergencyContactKey, emergencyContact);
    await prefs.setString(_emergencyPhoneKey, emergencyPhone);
    await prefs.setString(_talkBackSpeedKey, talkBackSpeed);
    await prefs.setString(_languageKey, language);
  }
}
