import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_hub/Screens/profile_screen.dart';
import 'package:habit_hub/Screens/add_habit.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Stream to listen to Firestore collection for the current user
  Stream<QuerySnapshot> _habitStream() {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return FirebaseFirestore.instance
          .collection(
              'habit') // Use 'habits' if this is what you used in Firestore
          //.where('userId', isEqualTo: currentUser.uid)
          // .orderBy('createdAt', descending: true) // Sort by createdAt timestamp
          .snapshots();
    } else {
      return const Stream.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Habits'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _habitStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong!'));
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            // If there is data, display the habits in a list
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(data['title']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Description: ${data['description']}'),
                        Text('Reminder Time: ${data['reminderTime']}'),
                        Text('Created At: ${data['createdAt'].toDate()}'),
                      ],
                    ),
                    trailing: Icon(Icons.check_circle_outline),
                  ),
                );
              }).toList(),
            );
          } else {
            // If no data is found
            return const Center(
                child: Text('No habits found. Start adding some!'));
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if (index == 0) {
            Navigator.popUntil(context, (route) => route.isFirst);
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
