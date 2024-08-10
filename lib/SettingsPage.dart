import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _message = '';
  String _username = '';

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? '';
    });
  }

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('https://api.tbmods.xyz/login.php'),
      body: {
        'username': username,
        'password': password,
      },
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['success']) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);
        setState(() {
          _username = username;
          _message = 'Login successful!';
        });
      } else {
        setState(() {
          _message = 'Invalid username or password';
        });
      }
    } else {
      setState(() {
        _message = 'Failed to connect to the server';
      });
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    setState(() {
      _username = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings Page'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_username.isEmpty) ...[
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _login,
                        child: Text('Login'),
                      ),
              ] else ...[
                Text('Welcome, $_username!'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _logout,
                  child: Text('Logout'),
                ),
              ],
              SizedBox(height: 20),
              Text(_message),
            ],
          ),
        ),
      ),
    );
  }
}
