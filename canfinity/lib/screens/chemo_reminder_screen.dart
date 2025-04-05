import 'package:flutter/material.dart';

class ChemoReminderScreen extends StatefulWidget {
  const ChemoReminderScreen({super.key});

  @override
  State<ChemoReminderScreen> createState() => _ChemoReminderScreenState();
}

class _ChemoReminderScreenState extends State<ChemoReminderScreen> {
  final List<ChemoReminder> reminders = [];
  final TextEditingController _medicationController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  void _addReminder() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Reminder'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _medicationController,
              decoration: const InputDecoration(
                labelText: 'Medication Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _timeController,
              decoration: const InputDecoration(
                labelText: 'Time',
                border: OutlineInputBorder(),
              ),
              onTap: () async {
                TimeOfDay? time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  _timeController.text = time.format(context);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_medicationController.text.isNotEmpty &&
                  _timeController.text.isNotEmpty) {
                setState(() {
                  reminders.add(ChemoReminder(
                    medicationName: _medicationController.text,
                    time: _timeController.text,
                  ));
                });
                _medicationController.clear();
                _timeController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chemo Reminders'),
      ),
      body: reminders.isEmpty
          ? const Center(
        child: Text('No reminders yet. Add your first reminder!'),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          final reminder = reminders[index];
          return Card(
            child: ListTile(
              title: Text(reminder.medicationName),
              subtitle: Text('Time: ${reminder.time}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    reminders.removeAt(index);
                  });
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addReminder,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _medicationController.dispose();
    _timeController.dispose();
    super.dispose();
  }
}

class ChemoReminder {
  final String medicationName;
  final String time;

  ChemoReminder({
    required this.medicationName,
    required this.time,
  });
} 