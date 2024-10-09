import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_hub/Screens/edit_habit.dart';
import 'package:habit_hub/Screens/profile_screen.dart';
import 'package:habit_hub/Screens/add_habit.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _username;

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  // Fetch the username from Firestore using the current user's uid
  Future<void> _fetchUsername() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      setState(() {
        _username = userDoc['username'];
      });
    }
  }

  // Stream to listen to Firestore collection for the current user's habits
  Stream<QuerySnapshot> _habitStream() {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return FirebaseFirestore.instance
          .collection('habit')
          .where('userId', isEqualTo: currentUser.uid)
          .snapshots();
    } else {
      return Stream.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Habit Hub',
          style: TextStyle(color: Colors.blue),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_username != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Hello, $_username!',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _habitStream(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong!'));
                }

                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text(
                            data['title'],
                            style: TextStyle(color: Colors.blue),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Description: ${data['description']}'),
                              Text('Reminder Time: ${data['reminderTime']}'),
                            ],
                          ),
                          trailing: Icon(Icons.edit),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditHabitScreen(
                                  habitId: document.id, // Pass the habit ID
                                  title: data['title'] ??
                                      '', // Fallback to an empty string if null
                                  description: data['description'] ?? '',
                                  reminderTime: data['reminderTime'] ?? '',
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                  );
                } else {
                  return Center(
                      child: Text('No habits found. Start adding some!'));
                }
              },
            ),
          ),
        ],
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
