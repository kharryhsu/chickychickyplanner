import 'package:flutter/material.dart';

class TimeFormatHintsPage extends StatelessWidget {
  TimeFormatHintsPage({super.key});

  final Map<String, String> dayMap = {
    'M': 'Monday',
    'T': 'Tuesday',
    'W': 'Wednesday',
    'R': 'Thursday',
    'F': 'Friday',
    'S': 'Saturday',
    'U': 'Sunday',
  };

  final Map<String, String> timeMap = {
    '1': '08:00 - 08:50',
    '2': '09:00 - 09:50',
    '3': '10:10 - 11:00',
    '4': '11:10 - 12:00',
    'n': '12:10 - 13:00',
    '5': '13:20 - 14:10',
    '6': '14:20 - 15:10',
    '7': '15:30 - 16:20',
    '8': '16:30 - 17:20',
    '9': '17:30 - 18:20',
    'a': '18:30 - 19:20',
    'b': '19:30 - 20:20',
    'c': '20:30 - 21:20',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Format Hints'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Day Codes:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: dayMap.entries
                    .map((entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Row(
                            children: [
                              Text(
                                entry.key,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(entry.value),
                            ],
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
              const Text(
                'Time Codes:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: timeMap.entries
                    .map((entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Row(
                            children: [
                              Text(
                                entry.key,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(entry.value),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
