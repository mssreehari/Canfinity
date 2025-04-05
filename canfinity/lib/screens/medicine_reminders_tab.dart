// medicine_reminders_tab.dart
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../config/theme.dart';




class MedicineReminder {
  final int? id;
  final String medicineName;
  final TimeOfDay time;
  final String dosage;
  final String notes;
  final bool isActive;

  MedicineReminder({
    this.id,
    required this.medicineName,
    required this.time,
    required this.dosage,
    required this.notes,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'medicineName': medicineName,
    'time': '${time.hour}:${time.minute}',
      'dosage': dosage,
      'notes': notes,
      'isActive': isActive ? 1 : 0,
    };
    if (id != null) {
      map['id'] = id!;
    }
    return map;
  }

  factory MedicineReminder.fromMap(Map<String, dynamic> map) {
    final parts = map['time'].split(':');
    return MedicineReminder(
      id: map['id'],
      medicineName: map['medicineName'],
      time: TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      ),
      dosage: map['dosage'],
      notes: map['notes'],
      isActive: map['isActive'] == 1,
    );
  }
}

class MedicineRemindersTab extends StatefulWidget {
  const MedicineRemindersTab({super.key});

  @override
  State<MedicineRemindersTab> createState() => _MedicineRemindersTabState();
}

class _MedicineRemindersTabState extends State<MedicineRemindersTab> {
  List<MedicineReminder> reminders = [];

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    print('Loading reminders from database...'); // Debug print
    final data = await DatabaseHelper.instance.getMedicineReminders();
    setState(() {
      reminders = data;
    });
    print('Loaded \${reminders.length} reminders'); // Debug print
  }

  void _saveReminder(MedicineReminder reminder) async {
    print('Saving reminder: \${reminder.toMap()}'); // Debug print
    await DatabaseHelper.instance.insertMedicineReminder(reminder);
    _loadReminders();
;
  }

  void _deleteReminder(int index) async {
    final reminder = reminders[index];
    await DatabaseHelper.instance.deleteMedicineReminder(reminder.id!);
    _loadReminders();
  }

  void _showAddReminderDialog() {
    showDialog(
      context: context,
      builder: (context) => AddReminderDialog(
        onAdd: (reminder) {
          _saveReminder(reminder);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: _showAddReminderDialog,
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Add Medicine Reminder'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: reminders.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.medication_outlined,
                    size: 64,
                    color: AppTheme.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No medicine reminders set',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the button above to add a reminder',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.subtext,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: reminders.length,
              itemBuilder: (context, index) {
                final reminder = reminders[index];
                return ReminderCard(
                  reminder: reminder,
                  onDelete: () => _deleteReminder(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ReminderCard extends StatelessWidget {
  final MedicineReminder reminder;
  final VoidCallback onDelete;

  const ReminderCard({
    super.key,
    required this.reminder,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppTheme.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    reminder.medicineName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.text,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: onDelete,
                  color: Colors.redAccent,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Time: ${reminder.time.format(context)}'),
            Text('Dosage: ${reminder.dosage}'),
            if (reminder.notes.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Notes: ${reminder.notes}'),
            ],
          ],
        ),
      ),
    );
  }
}

class AddReminderDialog extends StatefulWidget {
  final Function(MedicineReminder) onAdd;

  const AddReminderDialog({super.key, required this.onAdd});

  @override
  State<AddReminderDialog> createState() => _AddReminderDialogState();
}

class _AddReminderDialogState extends State<AddReminderDialog> {
  late TimeOfDay selectedTime;
  String medicineName = '';
  String dosage = '';
  String notes = '';

  @override
  void initState() {
    super.initState();
    selectedTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Medicine Reminder'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Medicine Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => medicineName = value,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Time'),
              subtitle: Text(selectedTime.format(context)),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                );
                if (picked != null) {
                  setState(() => selectedTime = picked);
                }
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Dosage',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => dosage = value,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (value) => notes = value,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (medicineName.isEmpty || dosage.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please fill in all required fields'),
                ),
              );
              return;
            }
            final reminder = MedicineReminder(
              medicineName: medicineName,
              time: selectedTime,
              dosage: dosage,
              notes: notes,
            );
            widget.onAdd(reminder);
            Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

}
