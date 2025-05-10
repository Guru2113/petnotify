import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../models/reminder_model.dart';
import '../widgets/reminder_list_tile.dart';
import 'package:petnotify/notify.dart';

class PetDetailsScreen extends StatefulWidget {
  final Pet pet;

  const PetDetailsScreen({required this.pet});

  @override
  _PetDetailsScreenState createState() => _PetDetailsScreenState();
}

class _PetDetailsScreenState extends State<PetDetailsScreen> {
  final _reminderController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.teal, // Changed to teal
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedTime != null) {
      setState(() => selectedTime = pickedTime);
    }
  }

  void _addReminder() {
    final reminderText = _reminderController.text.trim();
    if (reminderText.isEmpty) return;

    final now = DateTime.now();
    DateTime reminderTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    if (reminderTime.isBefore(now)) {
      reminderTime = reminderTime.add(const Duration(days: 1));
    }

    setState(() {
      widget.pet.reminders.add(
        Reminder(text: reminderText, time: reminderTime),
      );
      _reminderController.clear();
    });

    // Schedule notification
    NotiService().scheduleNotification(
      widget.pet.reminders.length - 1,
      "${widget.pet.name}'s reminder",
      reminderText,
      reminderTime,
    );
  }

  Future<void> _deleteReminder(int index) async {
    await NotiService().cancelNotification(index);
    setState(() => widget.pet.reminders.removeAt(index));
  }

  void _editReminder(int index) {
    final reminder = widget.pet.reminders[index];
    _reminderController.text = reminder.text;
    selectedTime = TimeOfDay.fromDateTime(reminder.time);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Edit Reminder',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _reminderController,
                decoration: InputDecoration(
                  labelText: 'Reminder',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              _TimePickerButton(
                selectedTime: selectedTime,
                onPressed: _pickTime,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal, // Changed to teal
            ),
            onPressed: () async {
              final reminderText = _reminderController.text.trim();
              if (reminderText.isEmpty) return;

              final now = DateTime.now();
              DateTime newTime = DateTime(
                now.year,
                now.month,
                now.day,
                selectedTime.hour,
                selectedTime.minute,
              );

              if (newTime.isBefore(now)) {
                newTime = newTime.add(const Duration(days: 1));
              }

              await NotiService().cancelNotification(index);
              setState(() {
                widget.pet.reminders[index] = Reminder(
                  text: reminderText,
                  time: newTime,
                );
              });
              await NotiService().scheduleNotification(
                index,
                "${widget.pet.name}'s reminder",
                reminderText,
                newTime,
              );
              _reminderController.clear();
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.pet.name}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.teal, // Changed app bar to teal
        foregroundColor: Colors.white, // White text for app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Removed the pet type chip widget

            const SizedBox(height: 16), // Reduced spacing

            // Add reminder section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Add New Reminder',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _reminderController,
                      decoration: InputDecoration(
                        labelText: 'Reminder details',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _TimePickerButton(
                            selectedTime: selectedTime,
                            onPressed: _pickTime,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _addReminder,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal, // Changed to teal
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'ADD',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Reminders list
            Expanded(
              child: widget.pet.reminders.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_off,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No reminders yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.separated(
                itemCount: widget.pet.reminders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  return ReminderListTile(
                    reminder: widget.pet.reminders[index],
                    onDelete: () => _deleteReminder(index),
                    onEdit: () => _editReminder(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimePickerButton extends StatelessWidget {
  final TimeOfDay selectedTime;
  final VoidCallback onPressed;

  const _TimePickerButton({
    required this.selectedTime,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black87,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.access_time, size: 20),
          const SizedBox(width: 8),
          Text(
            selectedTime.format(context),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}