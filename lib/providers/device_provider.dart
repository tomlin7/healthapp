import 'package:flutter/foundation.dart';
import 'package:healthapp/models/device.dart';
import 'package:uuid/uuid.dart';

class DeviceProvider with ChangeNotifier {
  final List<Device> _devices = [
    Device(
      id: const Uuid().v4(),
      name: 'Health Monitor Pro',
      type: 'Bluetooth',
    ),
    Device(
      id: const Uuid().v4(),
      name: 'Smart Health Band',
      type: 'Bluetooth',
    ),
    Device(
      id: const Uuid().v4(),
      name: 'WiFi Health Hub',
      type: 'Wi-Fi',
    ),
    Device(
      id: const Uuid().v4(),
      name: 'Connected Scale',
      type: 'Wi-Fi',
    ),
  ];

  List<Device> get devices => List.unmodifiable(_devices);

  void addDevice(Device device) {
    _devices.add(device);
    notifyListeners();
  }

  void removeDevice(String id) {
    _devices.removeWhere((device) => device.id == id);
    notifyListeners();
  }
}
