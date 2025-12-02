import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'voice_service.dart';

class NavigationService {
  static Position? _currentPosition;
  static bool _isNavigating = false;
  static String? _currentDestination;

  // Simulated indoor locations (for demo purposes)
  static final Map<String, Map<String, dynamic>> _locations = {
    'restroom': {
      'name': 'Nearest Restroom',
      'steps': 30,
      'direction': 'right',
      'description': 'Main floor restroom near the entrance',
    },
    'restroom_2': {
      'name': 'Second Restroom',
      'steps': 45,
      'direction': 'left',
      'description': 'Second floor restroom by the elevator',
    },
    'restroom_3': {
      'name': 'Third Restroom',
      'steps': 60,
      'direction': 'straight',
      'description': 'Lower level restroom near the cafeteria',
    },
    'library': {
      'name': 'Library',
      'steps': 120,
      'direction': 'straight then left',
      'description': 'Main library on the second floor',
    },
    'cafeteria': {
      'name': 'Cafeteria',
      'steps': 80,
      'direction': 'straight then right',
      'description': 'Student cafeteria on the main floor',
    },
    'exit': {
      'name': 'Main Exit',
      'steps': 25,
      'direction': 'behind you',
      'description': 'Main building entrance',
    },
    'room_101': {
      'name': 'Classroom 101',
      'steps': 40,
      'direction': 'left then straight',
      'description': 'Lecture hall 101 on the main floor',
    },
    'room_205': {
      'name': 'Classroom 205',
      'steps': 75,
      'direction': 'upstairs then right',
      'description': 'Classroom 205 on the second floor',
    },
    'classroom': {
      'name': 'General Classroom Area',
      'steps': 55,
      'direction': 'upstairs',
      'description': 'Main classroom corridor',
    },
  };

  // Initialize location services
  static Future<bool> initialize() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied');
      return false;
    }

    // Get current position
    try {
      _currentPosition = await Geolocator.getCurrentPosition();
      print('Location initialized: ${_currentPosition?.latitude}, ${_currentPosition?.longitude}');
      return true;
    } catch (e) {
      print('Error getting location: $e');
      return false;
    }
  }

  // Process navigation request
  static Future<void> handleNavigationRequest(String destination) async {
    _currentDestination = destination;
    
    if (_locations.containsKey(destination)) {
      await _navigateToLocation(destination);
    } else if (destination.startsWith('room_')) {
      await _navigateToRoom(destination);
    } else {
      await _findNearestOptions(destination);
    }
  }

  // Navigate to specific location
  static Future<void> _navigateToLocation(String locationKey) async {
    final location = _locations[locationKey];
    if (location == null) return;

    _isNavigating = true;
    
    // For restrooms, find the nearest one
    if (locationKey == 'restroom') {
      await _findNearestRestroom();
      return;
    }

    await VoiceService.speak(
      "${location['name']} is ${location['steps']} steps ahead on your ${location['direction']}."
    );

    // Start turn-by-turn guidance simulation
    await _startGuidance(location);
  }

  // Find nearest restroom (Scenario 1)
  static Future<void> _findNearestRestroom() async {
    await VoiceService.speak("Finding nearest restrooms...");
    
    // Announce the three nearest
    await VoiceService.speak(
      "I found three restrooms nearby. "
      "The nearest restroom is 30 steps ahead on your right. "
      "There's also one 45 steps to your left on the second floor, "
      "and another 60 steps straight ahead near the cafeteria."
    );
    
    // Navigate to the nearest one
    final nearestRestroom = _locations['restroom']!;
    await VoiceService.speak(
      "Navigating to the nearest restroom: ${nearestRestroom['steps']} steps ahead on your ${nearestRestroom['direction']}."
    );
    
    await _startGuidance(nearestRestroom);
  }

  // Navigate to specific room
  static Future<void> _navigateToRoom(String roomKey) async {
    if (_locations.containsKey(roomKey)) {
      await _navigateToLocation(roomKey);
    } else {
      // Extract room number and provide general guidance
      String roomNumber = roomKey.replaceFirst('room_', '');
      await VoiceService.speak(
        "Looking for room $roomNumber. Based on the room number, "
        "it should be on the ${_getRoomFloor(roomNumber)} floor. "
        "Head to the ${_getRoomDirection(roomNumber)} wing."
      );
    }
  }

  // Start turn-by-turn guidance
  static Future<void> _startGuidance(Map<String, dynamic> destination) async {
    _isNavigating = true;
    int remainingSteps = destination['steps'] as int;
    
    // Simulate walking guidance
    await VoiceService.speak("Starting navigation. Walk forward.");
    
    // Provide progress updates
    List<int> checkpoints = [
      (remainingSteps * 0.75).round(),
      (remainingSteps * 0.5).round(),
      (remainingSteps * 0.25).round(),
      5
    ];
    
    for (int checkpoint in checkpoints) {
      await Future.delayed(const Duration(seconds: 2));
      
      if (checkpoint > 10) {
        await VoiceService.speak("$checkpoint steps remaining to ${destination['name']}.");
      } else if (checkpoint <= 10 && checkpoint > 0) {
        await VoiceService.speak("Almost there. $checkpoint steps ahead.");
      }
    }
    
    // Arrival announcement
    await Future.delayed(const Duration(seconds: 2));
    await VoiceService.speak(
      "You have arrived at ${destination['name']}. ${destination['description']}."
    );
    
    _isNavigating = false;
  }

  // Find nearest options for unknown destinations
  static Future<void> _findNearestOptions(String query) async {
    await VoiceService.speak(
      "I couldn't find a specific location for '$query'. "
      "Here are some nearby options: restroom, library, cafeteria, or main exit. "
      "Please say which one you'd like to go to."
    );
  }

  // Helper function to determine floor based on room number
  static String _getRoomFloor(String roomNumber) {
    int number = int.tryParse(roomNumber) ?? 100;
    if (number < 200) return "first";
    if (number < 300) return "second";
    if (number < 400) return "third";
    return "upper";
  }

  // Helper function to determine wing based on room number
  static String _getRoomDirection(String roomNumber) {
    int number = int.tryParse(roomNumber) ?? 100;
    int lastDigit = number % 10;
    if (lastDigit <= 5) return "left";
    return "right";
  }

  // Get current location status
  static Future<String> getCurrentLocationStatus() async {
    if (_currentPosition != null) {
      return "Location services active. Ready for navigation.";
    } else {
      bool initialized = await initialize();
      return initialized 
        ? "Location services initialized successfully."
        : "Location services unavailable.";
    }
  }

  // Emergency location sharing
  static Future<String> getEmergencyLocationInfo() async {
    if (_currentPosition != null) {
      return "Current location: ${_currentPosition!.latitude.toStringAsFixed(6)}, "
             "${_currentPosition!.longitude.toStringAsFixed(6)}. "
             "Accuracy: ${_currentPosition!.accuracy.toStringAsFixed(1)} meters.";
    }
    return "Location unavailable.";
  }

  // Getters
  static bool get isNavigating => _isNavigating;
  static String? get currentDestination => _currentDestination;
  static Position? get currentPosition => _currentPosition;
}
