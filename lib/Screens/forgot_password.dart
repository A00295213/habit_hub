import 'package:flutter/material.dart';
import 'package:habit_hub/Screens/login_screen.dart';

class ForgotPassword extends StatelessWidget {
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
                  builder: (context) => LoginSceeen(),
                ),
              );
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            const Text(
              'Password Reset',
              style: TextStyle(fontSize: 40),
            ),
            const SizedBox(
              height: 10,
            ),
            const Center(
              child: Text(
                'You will receive an email for reseting your password',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Enter Your Email Address',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginSceeen(),
                    ),
                  );
                },
                child: const Text('Reset Password'))
          ],
        ),
      ),
    );
  }
}
