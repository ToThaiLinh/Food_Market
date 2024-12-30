import 'package:flutter/material.dart';
import '../../../models/user.dart';
import '../../../services/user_service.dart';

class UpdatePage extends StatefulWidget {
  final String title;
  final User user;

  UpdatePage({required this.user, required this.title});

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  late TextEditingController _controller;
  final UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    switch (widget.title) {
      case 'Name':
        _controller = TextEditingController(text: widget.user.name ?? '');
        break;
      case 'Country':
        _controller = TextEditingController(text: widget.user.countryCode ?? '');
        break;
      case 'Giới tính':
        _controller = TextEditingController(text: widget.user.gender ?? '');
        break;
      case 'Ngày sinh':
        _controller = TextEditingController(text: widget.user.birthDate ?? '');
        break;
      default:
        _controller = TextEditingController();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateUserInfo() async {
    try {
      // Cập nhật thông tin người dùng dựa trên `title`
      if (widget.title == 'Name') {
        widget.user.name = _controller.text;
      } else if (widget.title == 'Country') {
        widget.user.countryCode = _controller.text;
      } else if (widget.title == 'Giới tính') {
        widget.user.gender = _controller.text;
      } else if (widget.title == 'Ngày sinh') {
        widget.user.birthDate = _controller.text;
      }

      // Gọi API để cập nhật thông tin người dùng
      await userService.updateUserInfo(widget.user);

      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.title} đã được cập nhật thành công'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Quay lại màn hình trước đó và truyền user đã cập nhật
      Navigator.pop(context, widget.user);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cập nhật không thành công'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cập nhật ${widget.title}', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFFBF4E19),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Cập nhật ${widget.title}'),
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Cập nhật ${widget.title}',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: _updateUserInfo,
              child: Text('Tiếp tục', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
