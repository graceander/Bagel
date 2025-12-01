import 'package:flutter/material.dart';

class ToolPage extends StatelessWidget {
  const ToolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tool Page'),
      ),
      body: const Center(
        child: Text('Tool Page'),
      ),
    );
  }
}
