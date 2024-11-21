import 'package:flutter/material.dart';
import 'package:healthapp/screens/device_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _deviceNameController = TextEditingController();
  String _connectionType = 'Bluetooth';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _deviceNameController,
              decoration: const InputDecoration(
                labelText: 'Device Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _connectionType,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Bluetooth', child: Text('Bluetooth')),
                DropdownMenuItem(value: 'Wi-Fi', child: Text('Wi-Fi')),
              ],
              onChanged: (value) {
                setState(() {
                  _connectionType = value!;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeviceListScreen(
                      connectionType: _connectionType,
                    ),
                  ),
                );
              },
              child: const Text('Search Devices'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _deviceNameController.dispose();
    super.dispose();
  }
}
