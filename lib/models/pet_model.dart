import 'reminder_model.dart';
class Pet {
  String name;
  String type;
  List<Reminder> reminders;

  Pet({required this.name, required this.type, List<Reminder>? reminders})
      : reminders = reminders ?? [];
}
