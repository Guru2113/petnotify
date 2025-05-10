import 'package:flutter/material.dart';
import '../models/pet_model.dart';

class AddPetScreen extends StatefulWidget {
  final Pet? pet;
  final int? index;

  AddPetScreen({this.pet, this.index});

  @override
  _AddPetScreenState createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();
  String petName = '';
  String petType = 'Dog';

  @override
  void initState() {
    super.initState();
    if (widget.pet != null) {
      petName = widget.pet!.name;
      petType = widget.pet!.type;
    }
  }

  void _savePet() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newPet = Pet(
        name: petName,
        type: petType,
        reminders: widget.pet?.reminders ?? [],
      );
      Navigator.pop(context, newPet);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pet != null ? 'Edit Pet' : 'Add Pet'),
        backgroundColor: Colors.teal,
        toolbarHeight: 48, // Reduced height
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        initialValue: petName,
                        decoration: InputDecoration(
                          labelText: 'Pet Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v!.isEmpty ? 'Enter pet name' : null,
                        onSaved: (v) => petName = v!,
                      ),
                      SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: petType,
                        decoration: InputDecoration(
                          labelText: 'Pet Type',
                          border: OutlineInputBorder(),
                        ),
                        items: ['Dog', 'Cat', 'Bird', 'Other']
                            .map((type) => DropdownMenuItem(child: Text(type), value: type))
                            .toList(),
                        onChanged: (v) => setState(() => petType = v!),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton.icon(
                        onPressed: _savePet,
                        icon: Icon(Icons.save, color: Colors.white),
                        label: Text(
                          widget.pet != null ? 'Update Pet' : 'Save Pet',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          minimumSize: Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
