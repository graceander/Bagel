import 'package:shared_preferences/shared_preferences.dart';

class ToolService {
  static const String _emergencyContactKey = 'emergency_contact';
  static const String _emergencyPhoneKey = 'emergency_phone';
  static const String _talkBackSpeedKey = 'talk_back_speed';
  static const String _languageKey = 'language';

  static Future<Map<String, String?>> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'emergencyContact': prefs.getString(_emergencyContactKey),
      'emergencyPhone': prefs.getString(_emergencyPhoneKey),
      'talkBackSpeed': prefs.getString(_talkBackSpeedKey) ?? 'normal',
      'language': prefs.getString(_languageKey) ?? 'english',
    };
  }

  static Future<void> saveSettings({
    String? emergencyContact,
    String? emergencyPhone,
    String? talkBackSpeed,
    String? language,
  }) async {
    final prefs = await SharedPreferences.getInstance();
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
    required String emergencyContact,
    required String emergencyPhone,
    required String talkBackSpeed,
    required String language,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emergencyContactKey, emergencyContact);
    await prefs.setString(_emergencyPhoneKey, emergencyPhone);
    await prefs.setString(_talkBackSpeedKey, talkBackSpeed);
    await prefs.setString(_languageKey, language);
  }
}
