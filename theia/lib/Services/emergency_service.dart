import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'voice_service.dart';

class EmergencyService {
  static StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  static StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  static bool _isMonitoring = false;
  static Timer? _fallDetectionTimer;
  static DateTime? _lastSignificantMovement;
  
  // Thresholds for fall detection
  static const double fallThreshold = 20.0; // m/s² - significant impact
  static const double stillnessThreshold = 2.0; // m/s² - little movement after fall
  static const Duration stillnessDuration = Duration(seconds: 2);
  static const Duration responseWindow = Duration(seconds: 10);
  
  static bool _potentialFallDetected = false;
  static Timer? _responseTimer;

  // Start monitoring for falls
  static Future<void> startMonitoring() async {
    if (_isMonitoring) return;
    
    _isMonitoring = true;
    _lastSignificantMovement = DateTime.now();
    
    // Monitor accelerometer for sudden impacts
    _accelerometerSubscription = accelerometerEventStream(
      samplingPeriod: const Duration(milliseconds: 100)
    ).listen((AccelerometerEvent event) {
      _processAccelerometerData(event);
    });

    // Monitor gyroscope for orientation changes
    _gyroscopeSubscription = gyroscopeEventStream(
      samplingPeriod: const Duration(milliseconds: 100)
    ).listen((GyroscopeEvent event) {
      _processGyroscopeData(event);
    });
    
    print("Emergency monitoring started");
  }

  // Stop monitoring
  static Future<void> stopMonitoring() async {
    _isMonitoring = false;
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    _fallDetectionTimer?.cancel();
    _responseTimer?.cancel();
    _accelerometerSubscription = null;
    _gyroscopeSubscription = null;
    print("Emergency monitoring stopped");
  }

  // Process accelerometer data for fall detection
  static void _processAccelerometerData(AccelerometerEvent event) {
    double magnitude = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
    
    // Detect sudden impact (potential fall)
    if (magnitude > fallThreshold && !_potentialFallDetected) {
      _potentialFallDetected = true;
      print("Potential fall detected! Magnitude: $magnitude");
      
      // Start monitoring for stillness after impact
      _fallDetectionTimer = Timer(stillnessDuration, () {
        _checkForFall();
      });
    }
    
    // Reset if significant movement is detected
    if (magnitude > stillnessThreshold) {
      _lastSignificantMovement = DateTime.now();
    }
  }

  // Process gyroscope data for orientation changes
  static void _processGyroscopeData(GyroscopeEvent event) {
    double magnitude = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
    
    // Significant rotation detected
    if (magnitude > 5.0) {
      _lastSignificantMovement = DateTime.now();
    }
  }

  // Check if fall conditions are met
  static void _checkForFall() {
    if (_potentialFallDetected && _lastSignificantMovement != null) {
      Duration timeSinceMovement = DateTime.now().difference(_lastSignificantMovement!);
      
      // If user has been still for too long after impact, trigger fall protocol
      if (timeSinceMovement >= stillnessDuration) {
        _triggerFallProtocol();
      }
    }
    
    // Reset detection state
    _potentialFallDetected = false;
    _fallDetectionTimer?.cancel();
  }

  // Trigger fall emergency protocol
  static Future<void> _triggerFallProtocol() async {
    print("FALL DETECTED - Initiating emergency protocol");
    
    // Announce fall detection
    await VoiceService.speak(
      "It looks like you may have fallen. Are you ok? Say 'Yes' to cancel emergency assistance."
    );
    
    // Start countdown timer for response
    _responseTimer = Timer(responseWindow, () {
      _activateEmergencyContacts();
    });
    
    // Listen for user response
    try {
      String response = await VoiceService.listen();
      if (response.toLowerCase().contains('yes') || 
          response.toLowerCase().contains('okay') || 
          response.toLowerCase().contains('fine')) {
        _cancelEmergencyProtocol();
      }
    } catch (e) {
      print("Error listening for response: $e");
      // Continue with emergency protocol if can't hear response
    }
  }

  // Cancel emergency protocol
  static void _cancelEmergencyProtocol() {
    _responseTimer?.cancel();
    VoiceService.speak("Emergency assistance cancelled. Stay safe!");
    print("Emergency protocol cancelled by user");
  }

  // Activate emergency contacts
  static Future<void> _activateEmergencyContacts() async {
    final prefs = await SharedPreferences.getInstance();
    String? emergencyContact = prefs.getString('emergency_contact');
    String? emergencyPhone = prefs.getString('emergency_phone');
    
    if (emergencyPhone != null && emergencyPhone.isNotEmpty) {
      await VoiceService.speak("Contacting emergency contact now.");
      
      // Simulate calling emergency contact (in real app, would use actual calling)
      print("EMERGENCY: Calling $emergencyContact at $emergencyPhone");
      
      // For demo purposes, just show the intent to call
      try {
        final Uri phoneUri = Uri(scheme: 'tel', path: emergencyPhone);
        if (await canLaunchUrl(phoneUri)) {
          // In demo, just log the action
          print("Would call: $phoneUri");
          await VoiceService.speak("Emergency contact has been notified.");
        }
      } catch (e) {
        print("Error contacting emergency contact: $e");
        await VoiceService.speak("Unable to contact emergency contact. Please seek help immediately.");
      }
    } else {
      await VoiceService.speak("No emergency contact configured. Please seek help immediately.");
      print("EMERGENCY: No emergency contact configured!");
    }
  }

  // Simulate a fall for demo purposes
  static Future<void> simulateFall() async {
    print("DEMO: Simulating fall detection...");
    await _triggerFallProtocol();
  }

  static bool get isMonitoring => _isMonitoring;
}
