import 'package:flutter/material.dart';
import 'tool_page.dart';
import 'Services/voice_service.dart';
import 'Services/emergency_service.dart';
import 'Services/navigation_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Theia',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // Improve accessibility for blind-friendly interface
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isInitialized = false;
  bool _isListening = false;
  String _statusMessage = "Initializing Theia...";

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  @override
  void dispose() {
    EmergencyService.stopMonitoring();
    super.dispose();
  }

  Future<void> _initializeServices() async {
    try {
      // Initialize voice services
      bool voiceEnabled = await VoiceService.initialize();
      
      // Initialize navigation services
      bool navigationEnabled = await NavigationService.initialize();
      
      // Start emergency monitoring
      await EmergencyService.startMonitoring();
      
      setState(() {
        _isInitialized = true;
        _statusMessage = voiceEnabled && navigationEnabled 
          ? "Theia ready. Tap microphone to speak."
          : "Theia ready with limited functionality.";
      });
      
      // Welcome message
      await VoiceService.speak("Theia accessibility assistant is ready. Tap the microphone to give voice commands.");
      
    } catch (e) {
      setState(() {
        _statusMessage = "Initialization failed: ${e.toString()}";
      });
    }
  }

  Future<void> _handleMicrophonePress() async {
    if (!_isInitialized) {
      await VoiceService.speak("Please wait, Theia is still initializing.");
      return;
    }

    setState(() {
      _isListening = true;
      _statusMessage = "Listening... speak now";
    });

    try {
      await VoiceService.speak("Listening");
      String command = await VoiceService.listen();
      
      setState(() {
        _isListening = false;
        _statusMessage = "Processing: $command";
      });
      
      await _processVoiceCommand(command);
      
    } catch (e) {
      setState(() {
        _isListening = false;
        _statusMessage = "Error: ${e.toString()}";
      });
    }
  }

  Future<void> _processVoiceCommand(String command) async {
    if (command.isEmpty) {
      await VoiceService.speak("I didn't hear anything. Please try again.");
      setState(() {
        _statusMessage = "No command detected";
      });
      return;
    }

    String lowerCommand = command.toLowerCase();
    
    // Emergency simulation command
    if (lowerCommand.contains('simulate fall') || lowerCommand.contains('test emergency')) {
      setState(() {
        _statusMessage = "Simulating emergency...";
      });
      await EmergencyService.simulateFall();
      return;
    }
    
    // Navigation commands (Scenarios 1 & 3)
    if (lowerCommand.contains('find') || lowerCommand.contains('navigate') || 
        lowerCommand.contains('go to') || lowerCommand.contains('where is')) {
      
      String destination = VoiceService.processNavigationCommand(command);
      
      setState(() {
        _statusMessage = "Navigating to $destination";
      });
      
      await NavigationService.handleNavigationRequest(destination);
      return;
    }
    
    // Status commands
    if (lowerCommand.contains('status') || lowerCommand.contains('how are you')) {
      String locationStatus = await NavigationService.getCurrentLocationStatus();
      await VoiceService.speak("Theia is active. Emergency monitoring is running. $locationStatus");
      setState(() {
        _statusMessage = "Status reported";
      });
      return;
    }
    
    // Help command
    if (lowerCommand.contains('help')) {
      await VoiceService.speak(
        "I can help you navigate to restrooms, classrooms, library, cafeteria, or exits. "
        "I also monitor for falls and can contact emergency contacts. "
        "You can also access settings through the tools button."
      );
      setState(() {
        _statusMessage = "Help provided";
      });
      return;
    }
    
    // Default response
    await VoiceService.speak(
      "I can help you find locations like restrooms, library, cafeteria, or specific classrooms. "
      "What would you like to find?"
    );
    setState(() {
      _statusMessage = "Awaiting navigation request";
    });
  }

  Future<void> _handleStopPress() async {
    await VoiceService.stop();
    if (NavigationService.isNavigating) {
      await VoiceService.speak("Navigation stopped.");
    }
    setState(() {
      _isListening = false;
      _statusMessage = "Stopped";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Status bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue.withOpacity(0.1),
            child: SafeArea(
              child: Text(
                _statusMessage,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Main content
          Expanded(
            child: Stack(
              children: [
                Column(
                  children: [
                    // Main portion: Green mic button
                    Expanded(
                      flex: 4,
                      child: ElevatedButton(
                        onPressed: _isListening ? null : _handleMicrophonePress,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isListening ? Colors.orange : Colors.green,
                          minimumSize: const Size(double.infinity, double.infinity),
                          shape: const RoundedRectangleBorder(),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _isListening ? Icons.mic : Icons.mic,
                              size: 100,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _isListening ? 'LISTENING...' : 'TAP TO SPEAK',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Bottom 1/5: Red stop button
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.red,
                        child: Center(
                          child: ElevatedButton(
                            onPressed: _handleStopPress,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              minimumSize: const Size(double.infinity, double.infinity),
                              shape: const RoundedRectangleBorder(),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.stop,
                                  size: 50,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'STOP',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Top left: Tools button
                Positioned(
                  top: 20,
                  left: 20,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ToolPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                    child: const Text(
                      'TOOLS',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // Emergency indicators
                if (EmergencyService.isMonitoring)
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.health_and_safety, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'MONITORING',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
