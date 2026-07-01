import 'package:flutter/material.dart';
import 'debug_logger.dart';

class DebugPanel extends StatefulWidget {
  const DebugPanel({super.key});

  @override
  State<DebugPanel> createState() => _DebugPanelState();
}

class _DebugPanelState extends State<DebugPanel> {
  // === Task List ===
  final List<String> _taskNames = List.generate(13, (i) => 'Task ${i + 1}');
  String? _currentlyActive;

  // === Lifecycle ===
  @override
  void initState() {
    super.initState();
    _currentlyActive = DebugLogger().activeTask;
  }

  // === Build UI ===
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'DEBUG LOGGER',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Divider(),
            Text('Active: ${_currentlyActive ?? "none"}',
                style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 12),
            // === Task Buttons ===
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: _taskNames.map((task) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Expanded(child: Text(task)),
                            if (_currentlyActive == task)
                              ElevatedButton.icon(
                                onPressed: () {
                                  DebugLogger().endTask(task);
                                  setState(() => _currentlyActive = null);
                                },
                                icon: const Icon(Icons.stop, size: 16),
                                label: const Text('Stop'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  visualDensity: VisualDensity.compact,
                                ),
                              )
                            else
                              ElevatedButton.icon(
                                onPressed: () {
                                  DebugLogger().startTask(task);
                                  setState(() => _currentlyActive = task);
                                },
                                icon: const Icon(Icons.play_arrow, size: 16),
                                label: const Text('Start'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  visualDensity: VisualDensity.compact,
                                ),
                              ),
                          ],
                        ),
                      )).toList(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // === Close Button ===
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}