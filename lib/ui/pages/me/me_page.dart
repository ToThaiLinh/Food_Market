import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Username',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('Số điện thoại: ******012',
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  )
                ],
              ),
            ),
            Divider(),

            // List Options
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Thông tin người dùng'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserInfoPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Đổi mật khẩu'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Lịch sử mua sắm'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.group_add),
              title: Text('Mời bạn bè'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),

            // Logout Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Xác nhận'),
                        content: Text('Bạn có chắc chắn muốn thoát không?'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Không'),
                            onPressed: () {
                              Navigator.of(context).pop(); // Đóng dialog
                            },
                          ),
                          TextButton(
                            child: Text('Có'),
                            onPressed: () {
                              Navigator.of(context).pop(); // Đóng dialog
                              Navigator.pop(context); // Thực hiện pop để thoát
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Đăng xuất', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// User Info Page
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

// Update Phone Page
class UpdatePhonePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Số điện thoại', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFFBF4E19),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Số điện thoại hiện tại'),
              subtitle: Text('******012'),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Cập nhật số điện thoại',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {},
              child: Text('Tiếp tục', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// Change Password Page
class ChangePasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đổi mật khẩu', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFFBF4E19),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Mật khẩu hiện tại',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Mật khẩu mới',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Nhập lại mật khẩu mới',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {},
              child: Text('Lưu', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
