import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/models/device.dart';
import 'package:healthapp/models/health_data.dart';

class DataVisualizationScreen extends StatefulWidget {
  final Device device;

  const DataVisualizationScreen({
    super.key,
    required this.device,
  });

  @override
  State<DataVisualizationScreen> createState() =>
      _DataVisualizationScreenState();
}

class _DataVisualizationScreenState extends State<DataVisualizationScreen> {
  final List<HealthData> _healthData = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startDataSimulation();
  }

  void _startDataSimulation() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _healthData.add(HealthData(
          timestamp: DateTime.now(),
          heartRate: 60 + Random().nextInt(40),
          temperature: 36.0 + Random().nextDouble() * 2,
        ));

        if (_healthData.length > 20) {
          _healthData.removeAt(0);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data from ${widget.device.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHealthDataCard(),
            const SizedBox(height: 16),
            Expanded(child: _buildChart()),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthDataCard() {
    final latestData = _healthData.isNotEmpty ? _healthData.last : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Current Readings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDataItem(
                  'Heart Rate',
                  '${latestData?.heartRate ?? '--'} BPM',
                  Icons.favorite,
                  Colors.red,
                ),
                _buildDataItem(
                  'Temperature',
                  '${latestData?.temperature.toStringAsFixed(1) ?? '--'}°C',
                  Icons.thermostat,
                  Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }

  Widget _buildChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                ),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: _healthData.asMap().entries.map((entry) {
                  return FlSpot(
                    entry.key.toDouble(),
                    entry.value.heartRate.toDouble(),
                  );
                }).toList(),
                isCurved: true,
                color: Colors.red,
                dotData: FlDotData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
