import 'package:flutter/material.dart';
import 'tool_page.dart';

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
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Main portion: Green mic button
              Expanded(
                flex: 4,
                child: ElevatedButton(
                  onPressed: () {
                    // Mic button action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, double.infinity),
                    shape: const RoundedRectangleBorder(),
                  ),
                  child: const Icon(
                    Icons.mic,
                    size: 100,
                    color: Colors.white,
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
                      onPressed: () {
                        // Stop button action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size(double.infinity, double.infinity),
                        shape: const RoundedRectangleBorder(),
                      ),
                      child: const Icon(
                        Icons.stop,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Top left: Small button to tool page
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
              child: const Text('Tools'),
            ),
          ),
        ],
      ),
    );
  }
}
