import 'package:flutter/material.dart';
import '../../../services/user_api_service.dart';

class MePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tài khoản', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor, // Sử dụng màu chủ đạo từ theme
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Section
            Container(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Username',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Số điện thoại: ******012',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Divider(),
            // List Options
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: Icon(Icons.person, color: Theme.of(context).primaryColor),
                title: Text('Thông tin người dùng'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserInfoPage()),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: Icon(Icons.lock, color: Theme.of(context).primaryColor),
                title: Text('Đổi mật khẩu'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: Icon(Icons.history, color: Theme.of(context).primaryColor),
                title: Text('Lịch sử mua sắm'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                  // );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: Icon(Icons.group_add, color: Theme.of(context).primaryColor),
                title: Text('Mời bạn bè'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                  // );
                },
              ),
            ),

            // Logout Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
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
                child: Text(
                  'Đăng xuất',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _userApiService = UserApiService();
  bool _isLoading = false;

  Future<void> _changePassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mật khẩu mới không khớp')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _userApiService.changePassword(
        oldPassword: _oldPasswordController.text,
        newPassword: _newPasswordController.text,
      );

      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đổi mật khẩu thành công')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đổi mật khẩu thất bại: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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
              controller: _oldPasswordController,
              decoration: InputDecoration(
                labelText: 'Mật khẩu hiện tại',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(
                labelText: 'Mật khẩu mới',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
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
              onPressed: _isLoading ? null : _changePassword,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Lưu', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
