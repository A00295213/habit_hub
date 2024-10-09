import 'package:flutter/material.dart';
import 'package:habit_hub/Screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habit_hub/Screens/reset_password.dart';
import 'package:habit_hub/Screens/settings_screen.dart';
import 'package:habit_hub/Screens/welcome_screen.dart';
import 'package:habit_hub/authentication.dart';
import 'package:habit_hub/Screens/add_habit.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _username;
  bool _isLoading = true; // To track loading state

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  // Fetch the username from Firestore using the current user's uid
  Future<void> _fetchUsername() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        setState(() {
          _username = userDoc['username']; // Fetch the 'username' field
          _isLoading = false; // Once fetched, set loading to false
        });
      } catch (e) {
        print('Error fetching username: $e');
        setState(() {
          _isLoading = false; // Even on error, set loading to false
        });
      }
    }
  }

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 50,
                  child: Icon(
                    Icons.person,
                    size: 60,
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                // Display a loading indicator or the username
                _isLoading
                    ? const CircularProgressIndicator()
                    : Text(
                        _username != null
                            ? 'Hello, $_username!'
                            : 'Username not found',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            const Row(
              children: [
                Text(
                  'Change Profile photo',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Spacer(),
                Icon(Icons.camera_alt_outlined)
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            const Row(
              children: [
                Text(
                  'Change User Name',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Spacer(),
                Icon(Icons.edit_outlined)
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                const Text(
                  'Reset Password',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResetPassword()));
                    },
                    icon: const Icon(Icons.lock_outline))
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () async {
                      await _authService.logout();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WelcomeScreen()));
                    },
                    icon: const Icon(Icons.logout_outlined))
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
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
      ),
    );
  }
}
