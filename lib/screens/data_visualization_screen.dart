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
  List<Color> gradientColors = [
    const Color(0xFF00BCD4),
    const Color(0xFF2196F3),
    const Color(0xFFFFFFFF),
  ];

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

        if (_healthData.length > 10) {
          _healthData.removeAt(0);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          '${widget.device.name}',
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
        //       Colors.purple.shade50,
        //     ],
        //   ),
        // ),
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              _buildHealthDataCard(),
              const SizedBox(height: 1),
              Expanded(child: _buildChart()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthDataCard() {
    final latestData = _healthData.isNotEmpty ? _healthData.last : null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        // borderRadius: BorderRadius.circular(24),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     blurRadius: 20,
        //     offset: const Offset(0, 10),
        //   ),
        // ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'Current Readings',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3748),
                ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDataItem(
                'Heart Rate',
                '${latestData?.heartRate ?? '--'} BPM',
                Icons.favorite,
                Colors.red.shade400,
              ),
              Container(
                width: 1,
                height: 50,
                color: Colors.grey.shade300,
              ),
              _buildDataItem(
                'Temperature',
                '${latestData?.temperature.toStringAsFixed(1) ?? '--'}°C',
                Icons.thermostat,
                Colors.orange.shade400,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 40),
        const SizedBox(height: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF4A5568),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildChart() {
    return Container(
      // decoration: BoxDecoration(
      //   color: Colors.white.withOpacity(0.9),
      //   borderRadius: BorderRadius.circular(24),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black.withOpacity(0.1),
      //       blurRadius: 20,
      //       offset: const Offset(0, 10),
      //     ),
      //   ],
      // ),
      padding: const EdgeInsets.all(15),
      child: LineChart(
        LineChartData(
          minY: 50,
          maxY: 120,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 10,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.shade200,
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            bottomTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 10,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      color: Color.fromARGB(255, 176, 186, 204),
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: _healthData.asMap().entries.map((entry) {
                return FlSpot(
                  entry.key.toDouble(),
                  entry.value.heartRate.toDouble(),
                );
              }).toList(),
              isCurved: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: gradientColors,
              ),
              // color: Colors.red.shade400,
              barWidth: 3,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Colors.white,
                    strokeWidth: 3,
                    strokeColor: Colors.blue.shade400,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                // color: Colors.red.shade400.withOpacity(0.1),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: gradientColors
                      .map((color) => color.withOpacity(0.5))
                      .toList(),
                ),
              ),
            ),
          ],
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
