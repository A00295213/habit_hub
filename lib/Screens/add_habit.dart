import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habit_hub/Screens/home_screen.dart';
import 'package:habit_hub/Screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddScreen extends StatefulWidget {
  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveHabit() async {
    if (_formkey.currentState!.validate()) {
      String habitTitle = _titleController.text;
      String description = _descriptionController.text;
      String reminderTime = _selectedTime.format(context);

      await FirebaseFirestore.instance.collection('habit').add({
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'title': habitTitle,
        'description': description,
        'reminder': reminderTime,
        'createdAt': Timestamp.now(),
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Habit "$habitTitle" added!'),
      ));
      _titleController.clear();
      _descriptionController.clear();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to save habit: User not logged in.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text('Add Habit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
            key: _formkey,
            child: ListView(
              children: [
                //Title field

                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Habit Title',
                    hintText: 'Add Habit',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please enter a habit title';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),

                // Descripiton field

                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Add description',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Please enter your habit')));
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Reminder Time: ${_selectedTime.format(context)}',
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () => _selectTime(context),
                      child: Text('Select Time'),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _saveHabit,
                  child: const Text('Save habit'),
                ),
              ],
            )),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddScreen(),
              ),
            );
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '')
        ],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
