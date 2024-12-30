// User Info Page
import 'package:flutter/material.dart';
import 'package:food/ui/pages/me/update_page.dart';

import '../../../models/user.dart';

class UserInfoPage extends StatelessWidget {
  User user;
  UserInfoPage({required this.user});
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
              subtitle: Text(user.username ?? "Cập nhật ngay"),
            ),
            ListTile(
              title: Text('Email'),
              subtitle: Text(user.email ?? "Cập nhật ngay"),
              //trailing: Icon(Icons.edit),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdatePage(user: user, title: "Email")),
                );
              },
            ),
            ListTile(
              title: Text('Tên'),
              subtitle: Text(user.name ?? "Cập nhật ngay"),
              trailing: Icon(Icons.edit),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdatePage(user: user, title: "Name",)),
                );
              },
            ),
            ListTile(
              title: Text('Country'),
              subtitle: Text(user.countryCode ?? "Cập nhật ngay"),
              trailing: Icon(Icons.edit),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdatePage(user: user, title: "Country",)),
                );
              },
            ),
            ListTile(
              title: Text('Giới tính'),
              subtitle: Text(user.gender ?? 'Cập nhật ngay'),
              trailing: Icon(Icons.edit),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdatePage(user: user, title: "Giới tính",)),
                );
              },
            ),
            ListTile(
              title: Text('Ngày sinh'),
              subtitle: Text(user.birthDate ?? 'Cập nhật ngay'),
              trailing: Icon(Icons.edit),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdatePage(user: user, title: "Ngày sinh",)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}