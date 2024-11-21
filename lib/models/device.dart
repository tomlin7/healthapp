class Device {
  final String id;
  final String name;
  final String type;
  final bool isConnected;

  Device({
    required this.id,
    required this.name,
    required this.type,
    this.isConnected = false,
  });
}