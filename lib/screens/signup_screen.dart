import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add this import
import '../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String name = '';
  String role = 'buyer';
  String error = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (val) => val!.isEmpty ? 'Enter your name' : null,
                onChanged: (val) => setState(() => name = val),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (val) {
                  if (val!.isEmpty) return 'Enter an email';
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
                onChanged: (val) => setState(() => email = val),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                onChanged: (val) => setState(() => password = val),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: role,
                items: ['buyer', 'seller']
                    .map((role) => DropdownMenuItem(
                          value: role,
                          child: Text(role),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => role = val!),
                decoration: InputDecoration(labelText: 'Role'),
              ),
              SizedBox(height: 20),
              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      child: Text('Sign Up'),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => isLoading = true);
                          try {
                            dynamic result = await _auth.signUp(
                              email: email.trim(),
                              password: password,
                              name: name,
                              role: role,
                            );
                            if (result != null) {
                              if (result.role == 'seller') {
                                Navigator.pushReplacementNamed(context, '/sellerhome');
                              } else {
                                Navigator.pushReplacementNamed(context, '/home');
                              }
                            }
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              switch (e.code) {
                                case 'email-already-in-use':
                                  error = 'This email is already registered';
                                  break;
                                case 'invalid-email':
                                  error = 'Please enter a valid email address';
                                  break;
                                case 'weak-password':
                                  error = 'Password is too weak';
                                  break;
                                default:
                                  error = 'An error occurred: ${e.message}';
                              }
                            });
                          } catch (e) {
                            setState(() {
                              error = 'An unexpected error occurred';
                            });
                          } finally {
                            setState(() => isLoading = false);
                          }
                        }
                      },
                    ),
              SizedBox(height: 12),
              Text(
                error,
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}