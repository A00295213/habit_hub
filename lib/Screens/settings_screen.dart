import 'package:flutter/material.dart';
import 'package:habit_hub/Screens/home_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Column(
          children: [
            ListTile(
              title: const Text(
                'Dark Mode',
                style: TextStyle(fontSize: 23, color: Colors.blue),
              ),
              trailing: const Icon(
                Icons.dark_mode,
                size: 23,
              ),
              onTap: () {},
            ),
            const Divider(
              color: Color.fromARGB(255, 248, 124, 165),
            ),
            ListTile(
              title: const Text(
                'Set password for the app',
                style: TextStyle(fontSize: 23, color: Colors.blue),
              ),
              trailing: const Icon(
                Icons.lock_outline,
                size: 23,
              ),
              onTap: () {},
            ),
            const Divider(
              color: Color.fromARGB(255, 248, 124, 165),
            ),
            ListTile(
              title: const Text(
                'Set Reminder ',
                style: TextStyle(fontSize: 23, color: Colors.blue),
              ),
              trailing: const Icon(
                Icons.lock_outline,
                size: 23,
              ),
              onTap: () {},
            ),
            const Divider(
              color: Color.fromARGB(255, 248, 124, 165),
            ),
            ListTile(
              title: const Text(
                'Check previous Habit',
                style: TextStyle(fontSize: 23, color: Colors.blue),
              ),
              trailing: const Icon(
                Icons.history,
                size: 23,
              ),
              onTap: () {},
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: '')
          ],
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
        ));
  }
}
