import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
// import 'package:alarm/model/notification_settings.dart';
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
  TimeOfDay _selectedTime = TimeOfDay.now();
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

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

  // void ringAlarm() {
  //   FlutterRingtonePlayer.playAlarm(volume: 0.9, looping: true);
  // }

  // void _setAlarm() {
  //   final now = DateTime.now();
  //   final alarmTime = DateTime(
  //       now.year, now.month, now.day, _selectedTime.hour, _selectedTime.minute);

  //   AndroidAlarmManager.oneShotAt(alarmTime, 0, ringAlarm);

  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     content: Text('Reminder set for ${_selectedTime.format(context)}'),
  //   ));
  // }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveHabit() async {
    if (_formkey.currentState!.validate()) {
      String habitTitle = _titleController.text;
      String description = _descriptionController.text;
      String reminderTime = _selectedTime.format(context);

      DocumentReference docRef =
          await FirebaseFirestore.instance.collection('habit').add({
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'title': habitTitle,
        'description': description,
        'reminder': reminderTime,
        'createdAt': Timestamp.now(),
        'alarmId': FieldValue.increment(1),
      });

      print('test ---- ${docRef.id}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Habit "$habitTitle" added!'),
      ));

      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('habit')
          .doc(docRef.id)
          .get();

      int alarmId = documentSnapshot['alarmId'];

      print('test $alarmId');
      DateTime now = DateTime.now();

      // Specific time of day

      // Combine date and time
      DateTime fullDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final alarmSettings = AlarmSettings(
        notificationTitle: habitTitle,
        notificationBody: description,
        id: alarmId,
        dateTime: fullDateTime,
        assetAudioPath: 'assets/loudest-alarm-ever-36964.mp3',
        loopAudio: false,
        vibrate: true,
        volume: 0.8,
        fadeDuration: 3.0,
        enableNotificationOnKill: true,
        // warningNotificationOnKill: Platform.isIOS,
        // notificationSettings: NotificationSettings(
        //   title: habitTitle,
        //   body: description,
        //   stopButton: 'Stop',
        //   icon: 'notification_icon',
        // ),
      );

      await Alarm.set(alarmSettings: alarmSettings);

      _titleController.clear();
      _descriptionController.clear();

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
      //
      // print('test ----- ${querySnapshot.size}');
      // if (querySnapshot.size == 5) {
      //   DocumentReference userDoc = FirebaseFirestore.instance
      //       .collection('users')
      //       .doc(FirebaseAuth.instance.currentUser?.uid ?? '');
      //
      //   await userDoc.update({
      //     'rewards': FieldValue.increment(10),
      //   }).then((_) {
      //     print("Rewards updated successfully!");
      //   }).catchError((error) {
      //     print("Failed to update rewards: $error");
      //   });
      // }

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
                  onPressed: () => _selectTime(context),
                  child: Text('Pick Reminder Time'),
                ),
                SizedBox(height: 10),
                Text('Selected Time: ${_selectedTime.format(context)}'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveHabit,
                  child: Text('Save Habit'),
                )
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
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
