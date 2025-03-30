import 'package:flutter/material.dart';
import 'package:shopngo/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (val) => val!.isEmpty ? 'Enter an email' : null,
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
              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      child: Text('Login'),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => isLoading = true);
                          dynamic result = await _auth.login(
                            email: email,
                            password: password,
                          );
                          if (result == null) {
                            setState(() {
                              error = 'Could not sign in with those credentials';
                              isLoading = false;
                            });
                          } else {
                            // Navigate based on role
                            if (result.role == 'seller') {
                              Navigator.pushReplacementNamed(context, '/sellerhome');
                            } else {
                              Navigator.pushReplacementNamed(context, '/home');
                            }
                          }
                        }
                      },
                    ),
              SizedBox(height: 12),
              Text(error, style: TextStyle(color: Colors.red)),
              TextButton(
                child: Text('Need an account? Sign up'),
                onPressed: () => Navigator.pushNamed(context, '/signup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}