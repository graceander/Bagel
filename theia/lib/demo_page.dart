import 'package:flutter/material.dart';
import 'Services/voice_service.dart';
import 'Services/emergency_service.dart';
import 'Services/navigation_service.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  String _demoStatus = "Demo ready - choose a scenario to test";
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theia Demo Scenarios'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _demoStatus,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            
            // Scenario 1: Real-Time Obstacle Detection (Modified to Setup)
            _buildScenarioCard(
              title: 'Scenario 1: Navigation & Setup',
              description: 'Jaeger opens Theia and says "Find nearest restroom". The app identifies his location and provides voice guidance.',
              buttonText: 'Demo Navigation',
              onPressed: _demoNavigationScenario,
              color: Colors.green,
            ),
            
            const SizedBox(height: 16),
            
            // Scenario 2: Emergency Assistance
            _buildScenarioCard(
              title: 'Scenario 2: Emergency Assistance',
              description: 'Theia detects a fall and automatically activates safety protocol, asking if Josh is okay.',
              buttonText: 'Demo Fall Detection',
              onPressed: _demoEmergencyScenario,
              color: Colors.orange,
            ),
            
            const SizedBox(height: 16),
            
            // Scenario 3: GPS Speech Navigation
            _buildScenarioCard(
              title: 'Scenario 3: Voice Navigation',
              description: 'Grace uses voice recognition to navigate to her class with turn-by-turn voice guidance.',
              buttonText: 'Demo Voice Navigation',
              onPressed: _demoVoiceNavigationScenario,
              color: Colors.blue,
            ),
            
            const SizedBox(height: 20),
            
            // Combined demo
            ElevatedButton(
              onPressed: _runFullDemo,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
              child: const Text(
                'RUN FULL DEMO (All Scenarios)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildScenarioCard({
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
              ),
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _demoNavigationScenario() async {
    setState(() {
      _demoStatus = "Running Scenario 1: Navigation Demo...";
    });
    
    await VoiceService.speak("Scenario 1 Demo: Jaeger opens Theia and requests navigation to the nearest restroom.");
    await Future.delayed(const Duration(seconds: 2));
    
    await VoiceService.speak("Jaeger: Find nearest restroom");
    await Future.delayed(const Duration(seconds: 1));
    
    await NavigationService.handleNavigationRequest('restroom');
    
    setState(() {
      _demoStatus = "Scenario 1 completed - Jaeger successfully navigated to the restroom in under 2 minutes!";
    });
  }
  
  Future<void> _demoEmergencyScenario() async {
    setState(() {
      _demoStatus = "Running Scenario 2: Emergency Detection Demo...";
    });
    
    await VoiceService.speak("Scenario 2 Demo: Simulating Josh experiencing a fall while using Theia.");
    await Future.delayed(const Duration(seconds: 2));
    
    await VoiceService.speak("Theia is monitoring movement patterns using accelerometer and gyroscope.");
    await Future.delayed(const Duration(seconds: 1));
    
    await VoiceService.speak("Simulating sudden impact detection...");
    await Future.delayed(const Duration(seconds: 1));
    
    await EmergencyService.simulateFall();
    
    setState(() {
      _demoStatus = "Scenario 2 completed - Emergency protocol activated successfully!";
    });
  }
  
  Future<void> _demoVoiceNavigationScenario() async {
    setState(() {
      _demoStatus = "Running Scenario 3: Voice Navigation Demo...";
    });
    
    await VoiceService.speak("Scenario 3 Demo: Grace arrives on campus and needs to navigate to her class.");
    await Future.delayed(const Duration(seconds: 2));
    
    await VoiceService.speak("Grace: Navigate to classroom 205");
    await Future.delayed(const Duration(seconds: 1));
    
    await NavigationService.handleNavigationRequest('room_205');
    
    setState(() {
      _demoStatus = "Scenario 3 completed - Grace arrived to class on time!";
    });
  }
  
  Future<void> _runFullDemo() async {
    setState(() {
      _demoStatus = "Running complete demo of all three scenarios...";
    });
    
    await VoiceService.speak("Welcome to the complete Theia demonstration. I will now show you all three scenarios in sequence.");
    
    // Run all scenarios in sequence
    await _demoNavigationScenario();
    await Future.delayed(const Duration(seconds: 3));
    
    await _demoEmergencyScenario();
    await Future.delayed(const Duration(seconds: 3));
    
    await _demoVoiceNavigationScenario();
    
    await VoiceService.speak("Demonstration complete. Theia successfully handled real-time navigation, emergency detection, and voice-guided navigation scenarios.");
    
    setState(() {
      _demoStatus = "Full demonstration completed successfully! All scenarios working properly.";
    });
  }
}
