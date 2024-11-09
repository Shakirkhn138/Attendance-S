import 'package:attendance/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedRole;

  final _formKey = GlobalKey<FormState>();

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate() ?? false) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', _emailController.text);
      await prefs.setString('password', _passwordController.text);
      await prefs.setString('role', _selectedRole!);
      Navigator.pushNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      label: Text('Enter you email'),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16))),
                  validator: (value) =>
                  value!.contains('@') ? null : 'Enter a valid email'),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                      label: Text('Enter your password'),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)
                      )
                  ),
                  validator: (value) => value!.length >= 6
                      ? null
                      : 'Password must be at least 6 characters'),
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButtonFormField<String>(
                  hint: const Text('Select Role'),
                  value: _selectedRole,
                  items: ['student', 'teacher'].map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(
                          () {
                        _selectedRole = value;
                      },
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: _registerUser,
                child: const Text('Register'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
