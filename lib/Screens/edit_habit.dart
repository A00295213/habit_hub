import 'package:alarm/alarm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditHabitScreen extends StatefulWidget {
  final String habitId;
  final String title;
  final String description;
  final String reminderTime;
  final int alarmId;
  final bool isCompleted;

  EditHabitScreen(
      {required this.habitId,
      required this.title,
      required this.description,
      required this.reminderTime,
      required this.alarmId,
      required this.isCompleted});

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
        if (widget.alarmId != 0) {
          await Alarm.stop(widget.alarmId);
        }

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
    // DateTime now = DateTime.now();
    // DateTime startOfDay = DateTime(now.year, now.month, now.day);
    // DateTime endOfDay = DateTime(now.year, now.month, now.day + 1);
    //
    // Timestamp startTimestamp = Timestamp.fromDate(startOfDay);
    // Timestamp endTimestamp = Timestamp.fromDate(endOfDay);
    //
    // QuerySnapshot befpreQuerySnapshot = await FirebaseFirestore.instance
    //     .collection('habit')
    //     .where('userId',
    //         isEqualTo: FirebaseAuth.instance.currentUser?.uid ?? '')
    //     .where('createdAt', isGreaterThan: startTimestamp)
    //     .where('createdAt', isLessThan: endTimestamp).where('isCompleted', isEqualTo: true)
    //     .get();

    await FirebaseFirestore.instance
        .collection('habit')
        .doc(widget.habitId)
        .delete();

    if (widget.alarmId != 0) {
      await Alarm.stop(widget.alarmId);
    }

    // QuerySnapshot querySnapshot = await FirebaseFirestore.instance
    //     .collection('habit')
    //     .where('userId',
    //         isEqualTo: FirebaseAuth.instance.currentUser?.uid ?? '')
    //     .where('createdAt', isGreaterThan: startTimestamp)
    //     .where('createdAt', isLessThan: endTimestamp).where('isCompleted', isEqualTo: true)
    //     .get();
    //
    // print('test ----- ${querySnapshot.size}');
    // if (befpreQuerySnapshot.size == 5 && querySnapshot.size < 5) {
    if (widget.isCompleted) {
      DocumentReference userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid ?? '');

      await userDoc.update({
        'rewards': FieldValue.increment(-10),
      }).then((_) {
        print("Rewards updated successfully!");
      }).catchError((error) {
        print("Failed to update rewards: $error");
      });
    }
    // }

    Navigator.pop(context);
  }

  Future<void> _completeHabit() async {
    await FirebaseFirestore.instance
        .collection('habit')
        .doc(widget.habitId)
        .update({
      'isCompleted': true,
    });

    // DateTime now = DateTime.now();
    // DateTime startOfDay = DateTime(now.year, now.month, now.day);
    // DateTime endOfDay = DateTime(now.year, now.month, now.day + 1);
    //
    // Timestamp startTimestamp = Timestamp.fromDate(startOfDay);
    // Timestamp endTimestamp = Timestamp.fromDate(endOfDay);
    //
    // QuerySnapshot querySnapshot = await FirebaseFirestore.instance
    //     .collection('habit')
    //     .where('userId',
    //         isEqualTo: FirebaseAuth.instance.currentUser?.uid ?? '')
    //     .where('createdAt', isGreaterThan: startTimestamp)
    //     .where('createdAt', isLessThan: endTimestamp)
    //     .get();

    // print('test ----- ${querySnapshot.size}');
    // if (querySnapshot.size == 5) {
    DocumentReference userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid ?? '');

    await userDoc.update({
      'rewards': FieldValue.increment(10),
    }).then((_) {
      print("Rewards updated successfully!");
    }).catchError((error) {
      print("Failed to update rewards: $error");
    });
    // }
  }

  @override
  Widget build(BuildContext) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Edit Habit',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: _deleteHabit,
              icon: const Icon(Icons.delete_forever_rounded))
        ],
        backgroundColor: Colors.blueAccent,
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
              enabled: false,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _saveHabit,
                  child: const Text('Save Changes'),
                ),
                Visibility(
                  visible: !widget.isCompleted,
                  child: ElevatedButton(
                    onPressed: _completeHabit,
                    child: const Text('Complete Habit'),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
