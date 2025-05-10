import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../models/reminder_model.dart';
import '../widgets/reminder_list_tile.dart';

class ReminderScreen extends StatefulWidget {
  final Pet pet;
  final int index;

  const ReminderScreen({required this.pet, required this.index});

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  String reminderText = '';
  TimeOfDay selectedTime = TimeOfDay.now();

  void _addOrEditReminder({Reminder? reminder, int? i}) {
    if (reminder != null && i != null) {
      reminderText = reminder.text;
      selectedTime = TimeOfDay.fromDateTime(reminder.time);
    } else {
      reminderText = '';
      selectedTime = TimeOfDay.now();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(reminder != null ? 'Edit Reminder' : 'Add Reminder'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: reminderText,
                decoration: InputDecoration(
                  labelText: 'Reminder',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Enter reminder' : null,
                onSaved: (value) => reminderText = value!,
              ),
              SizedBox(height: 12),
              TextButton.icon(
                onPressed: () async {
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (picked != null) {
                    setState(() => selectedTime = picked);
                  }
                },
                icon: Icon(Icons.access_time),
                label: Text('Pick Time: ${selectedTime.format(context)}'),
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
            child: Text('Save'),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                final reminderTime = DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  selectedTime.hour,
                  selectedTime.minute,
                );

                final newReminder = Reminder(text: reminderText, time: reminderTime);

                setState(() {
                  if (reminder != null && i != null) {
                    widget.pet.reminders[i] = newReminder;
                  } else {
                    widget.pet.reminders.add(newReminder);
                  }
                });

                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  void _deleteReminder(int i) {
    setState(() {
      widget.pet.reminders.removeAt(i);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.pet.name} Reminders')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: widget.pet.reminders.isEmpty
            ? Center(child: Text('No reminders added yet.'))
            : ListView.builder(
          itemCount: widget.pet.reminders.length,
          itemBuilder: (context, i) {
            final reminder = widget.pet.reminders[i];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: ListTile(
                title: Text(reminder.text),
                subtitle: Text(
                  TimeOfDay.fromDateTime(reminder.time).format(context),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () =>
                          _addOrEditReminder(reminder: reminder, i: i),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteReminder(i),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addOrEditReminder(),
        icon: Icon(Icons.add_alert),
        label: Text('Add Reminder'),
        backgroundColor: Colors.teal,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
