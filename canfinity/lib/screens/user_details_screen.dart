import 'package:flutter/material.dart';
import 'chemo_tracking_screen.dart';
import 'medicine_reminders_tab.dart';
import '../config/theme.dart';

class UserDetailsScreen extends StatelessWidget {
  final String name;
  final int age;
  final String cancerType;
  final String dietPreference;
  final String cancerStage;
  final String location;
  final String phoneNumber;
  final String email;
  final List<ChemoSession> chemoSessions;
  final List<MedicineReminder> medicineReminders;

  const UserDetailsScreen({
    super.key,
    required this.name,
    required this.age,
    required this.cancerType,
    required this.dietPreference,
    required this.cancerStage,
    required this.location,
    required this.phoneNumber,
    required this.email,
    required this.chemoSessions,
    required this.medicineReminders,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.primary.withOpacity(0.3), Colors.white],
            stops: const [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 180.0,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    name,
                    style: const TextStyle(
                      color: AppTheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppTheme.primary.withOpacity(0.6),
                          AppTheme.primary.withOpacity(0.3),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.secondary.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: AppTheme.secondary.withOpacity(0.2),
                            child: Text(
                              name.isNotEmpty ? name[0].toUpperCase() : "U",
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.secondary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppTheme.secondary),
                    onPressed: () {
                      // Edit profile action
                    },
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoCard(),
                      const SizedBox(height: 24),
                      _buildSectionHeader('Your Chemo Journey', Icons.monitor_heart),
                      _buildChemoProgress(context),
                      const SizedBox(height: 8),
                      if (chemoSessions.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildChemoSessionsList(),
                      ],
                      const SizedBox(height: 24),
                      _buildSectionHeader('Medicine Reminders', Icons.medication),
                      _buildMedicineList(context),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 4,
      shadowColor: AppTheme.primary.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Personal Information', Icons.person),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.calendar_today, 'Age', age.toString()),
            const Divider(height: 24, thickness: 0.5),
            _buildDetailRow(Icons.medical_information, 'Cancer Type', cancerType),
            const Divider(height: 24, thickness: 0.5),
            _buildDetailRow(Icons.bar_chart, 'Cancer Stage', cancerStage.isEmpty ? 'Not specified' : cancerStage),
            const Divider(height: 24, thickness: 0.5),
            _buildDetailRow(Icons.restaurant_menu, 'Diet', dietPreference.isEmpty ? 'Not specified' : dietPreference),
            const Divider(height: 24, thickness: 0.5),
            _buildDetailRow(Icons.location_on, 'Location', location.isEmpty ? 'Not specified' : location),
            const Divider(height: 24, thickness: 0.5),
            _buildDetailRow(Icons.phone, 'Phone', phoneNumber.isEmpty ? 'Not specified' : phoneNumber),
            const Divider(height: 24, thickness: 0.5),
            _buildDetailRow(Icons.email, 'Email', email.isEmpty ? 'Not specified' : email),
          ],
        ),
      ),
    );
  }

  Widget _buildChemoProgress(BuildContext context) {
    final completedPercentage = chemoSessions.isEmpty ? 0.0 : chemoSessions.length / 12;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              chemoSessions.isEmpty
                  ? 'No sessions yet'
                  : '${chemoSessions.length} of 12 sessions completed',
              style: const TextStyle(
                color: AppTheme.subtext,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(completedPercentage * 100).toStringAsFixed(0)}%',
              style: const TextStyle(
                color: AppTheme.secondary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          height: 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[200],
          ),
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.8 * completedPercentage,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    colors: [AppTheme.primary, AppTheme.secondary],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChemoSessionsList() {
    return Column(
      children: chemoSessions.map((session) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.event_note, color: AppTheme.secondary),
          ),
          title: Text(
            'Session on ${session.date}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(session.notes ?? 'No notes'),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildMedicineList(BuildContext context) {
    final activeReminders = medicineReminders.where((r) => r.isActive).toList();

    if (activeReminders.isEmpty) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Text(
              'No active medicine reminders',
              style: TextStyle(color: AppTheme.subtext),
            ),
          ),
        ),
      );
    }

    return Column(
      children: activeReminders.map((reminder) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.medication, color: AppTheme.secondary),
          ),
          title: Text(
            reminder.medicineName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              // Fixed the time formatting by using string representation instead
              '${reminder.dosage} at ${_formatTimeOfDay(reminder.time)}',
            ),
          ),
          trailing: Switch(
            value: reminder.isActive,
            activeColor: AppTheme.secondary,
            onChanged: (value) {
              // Toggle reminder active status
            },
          ),
        ),
      )).toList(),
    );
  }

  // Helper method to format TimeOfDay without needing context
  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.secondary),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppTheme.primary),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.subtext,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.text,
              ),
            ),
          ],
        ),
      ],
    );
  }
}