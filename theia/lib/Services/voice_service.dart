import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceService {
  static final FlutterTts _flutterTts = FlutterTts();
  static final stt.SpeechToText _speech = stt.SpeechToText();
  static bool _isListening = false;
  static bool _speechEnabled = false;

  // Initialize speech services
  static Future<bool> initialize() async {
    _speechEnabled = await _speech.initialize();
    
    // Configure TTS
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
    
    return _speechEnabled;
  }

  // Text to speech function
  static Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }

  // Speech to text function
  static Future<String> listen() async {
    if (!_speechEnabled) return '';
    
    String lastWords = '';
    
    await _speech.listen(
      onResult: (result) {
        lastWords = result.recognizedWords;
      },
    );
    
    // Wait for speech to complete (simplified for demo)
    await Future.delayed(const Duration(seconds: 3));
    await _speech.stop();
    
    return lastWords;
  }

  static bool get isListening => _isListening;
  static bool get isEnabled => _speechEnabled;

  // Stop current speech
  static Future<void> stop() async {
    await _flutterTts.stop();
    if (_isListening) {
      await _speech.stop();
      _isListening = false;
    }
  }

  // Process voice commands for navigation
  static String processNavigationCommand(String command) {
    command = command.toLowerCase();
    
    if (command.contains('restroom') || command.contains('bathroom')) {
      return 'restroom';
    } else if (command.contains('library')) {
      return 'library';
    } else if (command.contains('cafeteria') || command.contains('food')) {
      return 'cafeteria';
    } else if (command.contains('exit') || command.contains('door')) {
      return 'exit';
    } else if (command.contains('class') || command.contains('room')) {
      // Extract room number if mentioned
      RegExp regExp = RegExp(r'\b\d{3,4}\b');
      Match? match = regExp.firstMatch(command);
      if (match != null) {
        return 'room_${match.group(0)}';
      }
      return 'classroom';
    }
    
    return 'unknown';
  }
}
