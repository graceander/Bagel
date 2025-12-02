import 'package:flutter/material.dart';
import 'Services/tool_service.dart';
import 'Services/emergency_service.dart';
import 'demo_page.dart';

class ToolPage extends StatefulWidget {
  const ToolPage({super.key});

  @override
  State<ToolPage> createState() => _ToolPageState();
}

class _ToolPageState extends State<ToolPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _emergencyContactController = TextEditingController();
  final TextEditingController _emergencyPhoneController = TextEditingController();
  String? _selectedSpeed = 'normal';
  String? _selectedLanguage = 'english';
  String? _selectedUnits = 'imperial';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await ToolService.loadSettings();
    setState(() {
      _nameController.text = settings['name'] ?? '';
      _heightController.text = settings['height'] ?? '';
      _emergencyContactController.text = settings['emergencyContact'] ?? '';
      _emergencyPhoneController.text = settings['emergencyPhone'] ?? '';
      _selectedSpeed = settings['talkBackSpeed'];
      _selectedLanguage = settings['language'];
      _selectedUnits = settings['units'] ?? 'imperial';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theia Setup & Settings'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  const Text(
                    'Personal Information',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Your Name',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) async {
                      await ToolService.saveSettings(name: value);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _heightController,
                    decoration: InputDecoration(
                      labelText: _selectedUnits == 'imperial' ? 'Height (feet and inches, e.g., 5\'8")' : 'Height (cm)',
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) async {
                      await ToolService.saveSettings(height: value);
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedUnits,
                    decoration: const InputDecoration(
                      labelText: 'Preferred Units',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'imperial', child: Text('Imperial (feet, inches)')),
                      DropdownMenuItem(value: 'metric', child: Text('Metric (centimeters)')),
                    ],
                    onChanged: (value) async {
                      setState(() {
                        _selectedUnits = value;
                      });
                      await ToolService.saveSettings(units: value);
                    },
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Emergency Contact',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emergencyContactController,
                    decoration: const InputDecoration(
                      labelText: 'Emergency Contact Name',
                      border: OutlineInputBorder(),
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
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    onChanged: (value) async {
                      await ToolService.saveSettings(emergencyPhone: value);
                    },
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Voice Settings',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedSpeed,
                    decoration: const InputDecoration(
                      labelText: 'Talk Back Speed',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'slow', child: Text('Slow')),
                      DropdownMenuItem(value: 'normal', child: Text('Normal')),
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
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'english', child: Text('English')),
                      DropdownMenuItem(value: 'spanish', child: Text('Español')),
                    ],
                    onChanged: (value) async {
                      setState(() {
                        _selectedLanguage = value;
                      });
                      await ToolService.saveSettings(language: value);
                    },
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Advanced Features',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DemoPage()),
                      );
                    },
                    icon: const Icon(Icons.play_circle),
                    label: const Text('Demo All Scenarios'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showMapUploadDialog();
                    },
                    icon: const Icon(Icons.map),
                    label: const Text('Upload Custom Map'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await EmergencyService.simulateFall();
                    },
                    icon: const Icon(Icons.warning),
                    label: const Text('Test Emergency Detection'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                    ),
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
                    name: _nameController.text,
                    height: _heightController.text,
                    emergencyContact: _emergencyContactController.text,
                    emergencyPhone: _emergencyPhoneController.text,
                    talkBackSpeed: _selectedSpeed ?? 'normal',
                    language: _selectedLanguage ?? 'english',
                    units: _selectedUnits ?? 'imperial',
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
                  'SAVE & RETURN TO HOME',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMapUploadDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Upload Custom Map'),
          content: const Text(
            'This feature allows you to upload a custom indoor map for more accurate navigation. '
            'In the full version, you would be able to select a map file from your device.'
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Map upload feature coming in future version'),
                  ),
                );
              },
              child: const Text('Upload'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _heightController.dispose();
    _emergencyContactController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }
}
