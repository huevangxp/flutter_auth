import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'home_page.dart';
import 'auth_provider.dart';
import 'register_page.dart'; // Import the RegisterPage

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  Future<void> _login() async {
    final response = await http.post(
      Uri.parse('http://localhost:7000/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': _username,
        'password': _password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final token = responseData['token'];
      Provider.of<AuthProvider>(context, listen: false).login(token);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid credentials')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//       appBar: AppBar(
//         title: Text('Login Page'),
//       ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
//                 decoration: InputDecoration(labelText: 'Username'),
 decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(), // Add border
                ),
                onSaved: (value) => _username = value!,
              ),
              SizedBox(
              height: 10),
              TextFormField(
                decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                ),
                obscureText: true,
//                 border: OutlineInputBorder(),
                onSaved: (value) => _password = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _formKey.currentState!.save();
                  _login();
                },
                child: Text('Login'),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Text("If you are not a member, please register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
