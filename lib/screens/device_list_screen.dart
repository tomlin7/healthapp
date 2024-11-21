import 'package:flutter/material.dart';
import 'package:healthapp/models/device.dart';
import 'package:healthapp/providers/device_provider.dart';
import 'package:healthapp/screens/data_visualization_screen.dart';
import 'package:provider/provider.dart';

class DeviceListScreen extends StatelessWidget {
  final String connectionType;

  const DeviceListScreen({
    super.key,
    required this.connectionType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          '$connectionType Devices',
          style: const TextStyle(
            color: Color(0xFF2D3748),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF2D3748)),
      ),
      body: Container(
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topLeft,
        //     end: Alignment.bottomRight,
        //     colors: [
        //       Colors.blue.shade50,
        //       Colors.blue.shade50,
        //     ],
        //   ),
        // ),
        child: Consumer<DeviceProvider>(
          builder: (context, deviceProvider, child) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: deviceProvider.devices.length,
              itemBuilder: (context, index) {
                final device = deviceProvider.devices[index];
                return DeviceListItem(device: device);
              },
            );
          },
        ),
      ),
    );
  }
}

class DeviceListItem extends StatelessWidget {
  final Device device;

  const DeviceListItem({
    super.key,
    required this.device,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      decoration: const BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(16),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     blurRadius: 20,
        //     offset: const Offset(0, 10),
        //   ),
        // ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          device.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            'ID: ${device.id}',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DataVisualizationScreen(device: device),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Connect',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
