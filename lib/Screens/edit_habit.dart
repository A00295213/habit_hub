import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditHabitScreen extends StatefulWidget {
  final String habitId;
  final String title;
  final String description;
  final String reminderTime;

  EditHabitScreen(
      {required this.habitId,
      required this.title,
      required this.description,
      required this.reminderTime});

  @override
  State<EditHabitScreen> createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends State<EditHabitScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _reminderTimeController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _descriptionController = TextEditingController(text: widget.description);
    _reminderTimeController = TextEditingController(text: widget.reminderTime);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _reminderTimeController.dispose();
    super.dispose();
  }

  Future<void> _saveHabit() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        await FirebaseFirestore.instance
            .collection('habit')
            .doc(widget.habitId)
            .update({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'reminderTime': _reminderTimeController.text,
          'userId': currentUser.uid,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Habit updated successfully')),
        );
        Navigator.pop(context);
      } catch (e) {
        print(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update habit')),
        );
      }
    }
  }

  Future<void> _deleteHabit() async {
    await FirebaseFirestore.instance
        .collection('habit')
        .doc(widget.habitId)
        .delete();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit HAbit'),
        actions: [
          IconButton(
              onPressed: _deleteHabit,
              icon: const Icon(Icons.delete_forever_rounded))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a title')));
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Please enter a description')));
                }
                return null;
              },
            ),
            TextFormField(
              controller: _reminderTimeController,
              decoration: const InputDecoration(labelText: 'Reminder Time'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Please enter a Reminder Time')));
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: _saveHabit,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
