import 'package:flutter/material.dart';
import 'package:healthapp/providers/device_provider.dart';
import 'package:healthapp/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => DeviceProvider(),
        child: MaterialApp(
            title: "Health App",
            theme: ThemeData(
              primarySwatch: Colors.indigo,
              useMaterial3: true,
            ),
            home: const HomeScreen()));
  }
}
