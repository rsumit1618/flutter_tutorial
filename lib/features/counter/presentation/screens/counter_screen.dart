import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/counter_provider.dart';
import '../widgets/counter_widget.dart';

class CounterScreen extends ConsumerWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counterState = ref.watch(counterProvider);
    final counterNotifier = ref.read(counterProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter Demo'),
        centerTitle: true,
        actions: [
          IconButton(
            key: const Key('resetButton'),
            icon: const Icon(Icons.refresh),
            onPressed: counterNotifier.resetCounter,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (counterState.error != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Error: ${counterState.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            // Counter Widget with its own logic or display
            CounterWidget(
              value: counterState.value,
              lastUpdated: counterState.lastUpdated,
            ),

            const SizedBox(height: 20),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  key: const Key('decrementButton'),
                  onPressed: counterNotifier.decrement,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                  ),
                  child: const Icon(Icons.remove, color: Colors.white),
                ),
                const SizedBox(width: 30),
                ElevatedButton(
                  key: const Key('incrementButton'),
                  onPressed: counterNotifier.increment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}