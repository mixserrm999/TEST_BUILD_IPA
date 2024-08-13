import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'AddCardPage.dart'; 
import 'AddDetailPage.dart'; 
import 'WebViewPage.dart'; 

class UpdatePage extends StatelessWidget {
  final storage = FlutterSecureStorage();

  Future<bool> checkLoginStatus() async {
    String? token = await storage.read(key: 'loginToken');
    return token != null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData && snapshot.data == true) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Logged In Page'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Welcome! You are logged in.'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddCardPage()),
                      );
                    },
                    child: Text('Add Card'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddDetailPage()),
                      );
                    },
                    child: Text('Add Details'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WebViewPage()),
                      );
                    },
                    child: Text('Open Web Page'),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('Update Page'),
            ),
            body: Center(
              child: Text('Update Page Content'),
            ),
          );
        }
      },
    );
  }
}
