import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import 'add_pet_screen.dart';
import 'PetDetailsScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Pet> pets = [
    Pet(name: 'Buddy', type: 'Dog'),
    Pet(name: 'Mittens', type: 'Cat'),
    Pet(name: 'Tweety', type: 'Bird'),
  ];

  Future<void> _navigateToAddPet({Pet? pet, int? index}) async {
    final returnedPet = await Navigator.push<Pet>(
      context,
      MaterialPageRoute(
        builder: (_) => AddPetScreen(pet: pet, index: index),
      ),
    );
    if (returnedPet != null) {
      setState(() {
        if (index != null) {
          pets[index] = returnedPet;
        } else {
          pets.add(returnedPet);
        }
      });
    }
  }

  void _deletePet(int index) {
    setState(() => pets.removeAt(index));
  }

  void _navigateToPetDetails(Pet pet, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PetDetailsScreen(pet: pet),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Care Dashboard'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Pets',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: pets.isEmpty
                  ? Center(
                child: Text(
                  'No pets added yet.',
                  style: TextStyle(fontSize: 16),
                ),
              )
                  : ListView.separated(
                itemCount: pets.length,
                separatorBuilder: (_, __) => SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final pet = pets[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      leading: Icon(Icons.pets, size: 32),
                      title: Text(
                        pet.name,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(pet.type),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _navigateToAddPet(
                                pet: pet, index: index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deletePet(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.notifications_active, color: Colors.teal),
                            tooltip: 'View Reminders',
                            onPressed: () => _navigateToPetDetails(pet, index),
                          ),

                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddPet(),
        label: Text('Add Pet'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
