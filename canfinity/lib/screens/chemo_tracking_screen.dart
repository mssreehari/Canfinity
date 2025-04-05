import '../database/database_helper.dart';
import 'package:flutter/material.dart';
import '../config/theme.dart';
import './medicine_reminders_tab.dart';

class ChemoTrackingScreen extends StatelessWidget {
  const ChemoTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          title: Text(
            'Treatment Tracking',
            style: TextStyle(
              color: AppTheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          bottom: TabBar(
            indicatorColor: AppTheme.primary,
            indicatorWeight: 2,
            labelColor: AppTheme.primary,
            unselectedLabelColor: AppTheme.subtext,
            tabs: const [
              Tab(
                icon: Icon(Icons.track_changes_outlined),
                text: 'Chemo Sessions',
              ),
              Tab(
                icon: Icon(Icons.medication_outlined),
                text: 'Medicine',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ChemoProgressTab(),
            MedicineRemindersTab(),
          ],
        ),
      ),
    );
  }
}

class ChemoSession {
  final int? id;
  final int sessionNumber;
  final DateTime date;
  final String duration;
  final String notes;

  ChemoSession({
    this.id,
    required this.sessionNumber,
    required this.date,
    required this.duration,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sessionNumber': sessionNumber,
      'date': date.toIso8601String(),
      'duration': duration,
      'notes': notes,
    };
  }

  factory ChemoSession.fromMap(Map<String, dynamic> map) {
    return ChemoSession(
      id: map['id'],
      sessionNumber: map['sessionNumber'],
      date: DateTime.parse(map['date']),
      duration: map['duration'],
      notes: map['notes'],
    );
  }
}

class ChemoProgressTab extends StatefulWidget {
  const ChemoProgressTab({super.key});

  @override
  State<ChemoProgressTab> createState() => _ChemoProgressTabState();
}

class _ChemoProgressTabState extends State<ChemoProgressTab> {
  List<ChemoSession> sessions = [];

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final data = await DatabaseHelper.instance.getChemoSessions();
    setState(() {
      sessions = data;
    });
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Progress',
                    style: TextStyle(
                      color: AppTheme.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: sessions.isEmpty ? 0 : sessions.length / 12,
                    backgroundColor: AppTheme.surface,
                    color: AppTheme.primary,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${sessions.length} of 12 Sessions',
                        style: TextStyle(color: AppTheme.text),
                      ),
                      Text(
                        '${((sessions.length / 12) * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _showAddSessionDialog,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Session'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: sessions.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.note_add_rounded,
                    size: 64,
                    color: AppTheme.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No sessions recorded yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the button above to add your first session',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.subtext,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                return SessionCard(
                  session: session,
                  onDelete: () => _deleteSession(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddSessionDialog() {
    showDialog(
      context: context,
      builder: (context) => AddSessionDialog(
        onAdd: (session) {
          _saveSession(session);
        },
      ),
    );
  }

  Future<void> _saveSession(ChemoSession session) async {
    await DatabaseHelper.instance.insertChemoSession(session);
    _loadSessions();
  }

  void _deleteSession(int index) async {
    final session = sessions[index];
    await DatabaseHelper.instance.deleteChemoSession(session.id!);
    _loadSessions();
  }
}

class SessionCard extends StatelessWidget {
  final ChemoSession session;
  final VoidCallback onDelete;

  const SessionCard({
    super.key,
    required this.session,
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
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppTheme.surface,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Session ${session.sessionNumber}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
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
            Row(
              children: [
                Icon(Icons.calendar_today, size: 20, color: AppTheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Date: ${session.date.toString().split(' ')[0]}',
                  style: TextStyle(fontSize: 16, color: AppTheme.text),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.timer, size: 20, color: AppTheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Duration: ${session.duration} hours',
                  style: TextStyle(fontSize: 16, color: AppTheme.text),
                ),
              ],
            ),
            if (session.notes.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.secondary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.note, size: 20, color: AppTheme.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        session.notes,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.text,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

}
class AddSessionDialog extends StatefulWidget {
  final Function(ChemoSession) onAdd;

  const AddSessionDialog({super.key, required this.onAdd});

  @override
  State<AddSessionDialog> createState() => _AddSessionDialogState();
}

class _AddSessionDialogState extends State<AddSessionDialog> {
  late DateTime selectedDate;
  String duration = '';
  String notes = '';
  int sessionNumber = 1;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Chemo Session'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Session Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  sessionNumber = int.tryParse(value) ?? 1;
                });
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Date'),
              subtitle: Text(selectedDate.toString().split(' ')[0]),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Duration (hours)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  duration = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (value) {
                setState(() {
                  notes = value;
                });
              },
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
            final session = ChemoSession(
              sessionNumber: sessionNumber,
              date: selectedDate,
              duration: duration,
              notes: notes,
            );
            widget.onAdd(session);
            Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
