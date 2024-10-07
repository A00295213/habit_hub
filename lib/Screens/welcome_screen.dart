import 'package:flutter/material.dart';
import 'package:habit_hub/Screens/login_screen.dart';
import 'package:habit_hub/Screens/register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Welcome to ',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 70,
                color: Colors.blue,
              ),
            ),
            const Text(
              'Habit Hub',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 70,
                color: Colors.blue,
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            SizedBox(
              child: Image.asset(
                'assets/HabitHub.png',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterSceeen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                )),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account ?'),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginSceeen(),
                        ));
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
