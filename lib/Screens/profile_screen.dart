import 'package:flutter/material.dart';
import 'package:habit_hub/Screens/home_screen.dart';
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
  final AuthService _authService = AuthService();
  @override
  int _currenetIndex = 0;
  final List<Widget> _pages = [HomeScreen(), ProfileScreen()];

  void _onTabTapped(int index) {
    setState(() {
      _currenetIndex = index;
    });
  }

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
            const Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  child: Icon(
                    Icons.person,
                    size: 60,
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Text(
                  'Jacky',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                )
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
      ),
    );
  }
}
