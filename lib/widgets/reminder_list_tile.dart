import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../models/reminder_model.dart';
import 'package:intl/intl.dart';

class ReminderListTile extends StatelessWidget {
  final Reminder reminder;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ReminderListTile({
    required this.reminder,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(reminder.text),
      subtitle: Text(DateFormat.jm().format(reminder.time)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(icon: Icon(Icons.edit), onPressed: onEdit),
          IconButton(icon: Icon(Icons.delete), onPressed: onDelete),
        ],
      ),
    );
  }
}
