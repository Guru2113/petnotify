import 'package:flutter/material.dart';
import '../models/pet_model.dart';

class PetListTile extends StatelessWidget {
  final Pet pet;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const PetListTile({
    required this.pet,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${pet.name} (${pet.type})'),
      onTap: onTap,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(onPressed: onEdit, icon: Icon(Icons.edit)),
          IconButton(onPressed: onDelete, icon: Icon(Icons.delete)),
        ],
      ),
    );
  }
}
