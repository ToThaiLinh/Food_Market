// User Info Page
import 'package:flutter/material.dart';
import 'package:food/ui/pages/me/update_phone_page.dart';

class UserInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin người dùng', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFFBF4E19),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Tên đăng nhập'),
              subtitle: Text('foodfamily_012'),
            ),
            ListTile(
              title: Text('Số điện thoại'),
              subtitle: Text('******012'),
              trailing: Icon(Icons.edit),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdatePhonePage()),
                );
              },
            ),
            ListTile(
              title: Text('Tên'),
              subtitle: Text('Nguyen Van A'),
            ),
            ListTile(
              title: Text('Email'),
              subtitle: Text('Cập nhật ngay'),
              trailing: Icon(Icons.edit),
            ),
            ListTile(
              title: Text('Giới tính'),
              subtitle: Text('Cập nhật ngay'),
              trailing: Icon(Icons.edit),
            ),
            ListTile(
              title: Text('Ngày sinh'),
              subtitle: Text('Cập nhật ngay'),
              trailing: Icon(Icons.edit),
            ),
          ],
        ),
      ),
    );
  }
}
