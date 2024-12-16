// User Info Page
import 'package:flutter/material.dart';
import 'package:food/ui/pages/me/update_phone_page.dart';

import '../../../models/user.dart';

class UserInfoPage extends StatelessWidget {
  final User user;

  const UserInfoPage({Key? key, required this.user}) : super(key: key);

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
              subtitle: Text("${user.username}"),
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
              subtitle: Text('${user.name}'),
            ),
            ListTile(
              title: Text('Email'),
              subtitle: Text(user.email.isNotEmpty ? user.email : 'Cập nhật ngay'),
              trailing: Icon(Icons.edit),
            ),
            ListTile(
              title: Text('Giới tính'),
              subtitle: Text(user.gender!.isNotEmpty ? user.gender! : 'Cập nhật ngay'),
              trailing: Icon(Icons.edit),
            ),
            ListTile(
              title: Text('Ngày sinh'),
              subtitle: Text(user.birthDate!.isNotEmpty ? user.birthDate! : 'Cập nhật ngay'),
              trailing: Icon(Icons.edit),
            ),
          ],
        ),
      ),
    );
  }
}
