import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_hub/Screens/welcome_screen.dart';
import 'package:habit_hub/authentication.dart';

class RegisterSceeen extends StatefulWidget {
  @override
  State<RegisterSceeen> createState() => _RegisterSceeenState();
}

class _RegisterSceeenState extends State<RegisterSceeen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          style: IconButton.styleFrom(backgroundColor: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Create',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 60,
                  color: Colors.blue,
                ),
              ),
              const Text(
                'Account',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 60,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(
                height: 200,
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Email Addrss',
                  border: UnderlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: _userNameController,
                decoration: const InputDecoration(
                  hintText: 'User name',
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  border: UnderlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  hintText: 'Confirm Password',
                  border: UnderlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                  onPressed: () async {
                    User? user =
                        await _authService.registerInWithEmailAndPassword(
                            _emailController.text,
                            _passwordController.text,
                            _userNameController.text);
                    if (user != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Registered Successfully'),
                        ),
                      );
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WelcomeScreen()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Registration failed'),
                        ),
                      );
                    }
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
            ],
          ),
        ),
      ),
    );
  }
}
