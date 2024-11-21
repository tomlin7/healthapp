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
      appBar: AppBar(
        title: Text('Available $connectionType Devices'),
      ),
      body: Consumer<DeviceProvider>(
        builder: (context, deviceProvider, child) {
          return ListView.builder(
            itemCount: deviceProvider.devices.length,
            itemBuilder: (context, index) {
              final device = deviceProvider.devices[index];
              return DeviceListItem(device: device);
            },
          );
        },
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
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(device.name),
        subtitle: Text(device.id),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DataVisualizationScreen(device: device),
              ),
            );
          },
          child: const Text('Connect'),
        ),
      ),
    );
  }
}
