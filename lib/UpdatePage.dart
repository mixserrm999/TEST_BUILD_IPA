import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'AddCardPage.dart'; // Import the AddCardPage
import 'AddDetailPage.dart'; // Import the DetailPage

class UpdatePage extends StatelessWidget {
  final storage = FlutterSecureStorage();

  Future<bool> checkLoginStatus() async {
    String? token = await storage.read(key: 'loginToken');
    return token != null; // ถ้ามี token แสดงว่าล็อกอินสำเร็จ
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()), // แสดงการโหลดก่อนตรวจสอบสถานะ
          );
        } else if (snapshot.hasData && snapshot.data == true) {
          // ถ้าล็อกอินสำเร็จ แสดงหน้าใหม่แทน
          return Scaffold(
            appBar: AppBar(
              title: Text('Logged In Page'), // ชื่อหน้าหลังจากล็อกอินสำเร็จ
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Welcome! You are logged in.'), // เนื้อหาหน้าหลังจากล็อกอินสำเร็จ
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddCardPage()), // Navigate to AddCardPage
                      );
                    },
                    child: Text('Add Card'), // Button to add card
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddDetailPage()), // Navigate to DetailPage
                      );
                    },
                    child: Text('Add Details'), // Button to add details
                  ),
                ],
              ),
            ),
          );
        } else {
          // ถ้ายังไม่ได้ล็อกอิน แสดงหน้าเดิม
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
