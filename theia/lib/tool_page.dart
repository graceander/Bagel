import 'package:flutter/material.dart';
import 'Services/tool_service.dart';

class ToolPage extends StatefulWidget {
  const ToolPage({super.key});

  @override
  State<ToolPage> createState() => _ToolPageState();
}

class _ToolPageState extends State<ToolPage> {
  final TextEditingController _emergencyContactController = TextEditingController();
  final TextEditingController _emergencyPhoneController = TextEditingController();
  String? _selectedSpeed = 'normal';
  String? _selectedLanguage = 'english';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await ToolService.loadSettings();
    setState(() {
      _emergencyContactController.text = settings['emergencyContact'] ?? '';
      _emergencyPhoneController.text = settings['emergencyPhone'] ?? '';
      _selectedSpeed = settings['talkBackSpeed'];
      _selectedLanguage = settings['language'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tool Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  TextField(
                    controller: _emergencyContactController,
                    decoration: const InputDecoration(
                      labelText: 'Emergency Contact',
                    ),
                    onChanged: (value) async {
                      await ToolService.saveSettings(emergencyContact: value);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emergencyPhoneController,
                    decoration: const InputDecoration(
                      labelText: 'Emergency Contact Phone',
                    ),
                    onChanged: (value) async {
                      await ToolService.saveSettings(emergencyPhone: value);
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedSpeed,
                    decoration: const InputDecoration(
                      labelText: 'Talk Back Speed',
                    ),
                    items: const [
                      DropdownMenuItem(value: 'normal', child: Text('Normal')),
                      DropdownMenuItem(value: 'slow', child: Text('Slow')),
                      DropdownMenuItem(value: 'fast', child: Text('Fast')),
                    ],
                    onChanged: (value) async {
                      setState(() {
                        _selectedSpeed = value;
                      });
                      await ToolService.saveSettings(talkBackSpeed: value);
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedLanguage,
                    decoration: const InputDecoration(
                      labelText: 'Language',
                    ),
                    items: const [
                      DropdownMenuItem(value: 'english', child: Text('English')),
                    ],
                    onChanged: (value) async {
                      setState(() {
                        _selectedLanguage = value;
                      });
                      await ToolService.saveSettings(language: value);
                    },
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      // Upload custom map action
                    },
                    child: const Text('Upload Custom Map'),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.blue,
            child: Center(
              child: ElevatedButton(
                onPressed: () async {
                  await ToolService.saveAllSettings(
                    emergencyContact: _emergencyContactController.text,
                    emergencyPhone: _emergencyPhoneController.text,
                    talkBackSpeed: _selectedSpeed ?? 'normal',
                    language: _selectedLanguage ?? 'english',
                  );
                  if (mounted) {
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 80),
                  shape: const RoundedRectangleBorder(),
                ),
                child: const Text(
                  'Back to Home',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emergencyContactController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }
}
