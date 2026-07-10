import 'package:flutter/material.dart';

class CounterWidget extends StatelessWidget {
  final int value;
  final String lastUpdated;

  const CounterWidget({
    super.key,
    required this.value,
    required this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        children: [
          const Text(
            'Counter Value',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$value',
            key: const Key('counterValue'),
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          if (lastUpdated.isNotEmpty)
            Text(
              'Last Updated: $lastUpdated',
              key: const Key('lastUpdated'),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
        ],
      ),
    );
  }
}