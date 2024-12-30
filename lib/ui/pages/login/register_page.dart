import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../gen/assets.gen.dart';
import '../../../services/register_api_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng Ký', style: TextStyle(fontSize: 18.sp)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.images.imgLogin.path),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Họ và Tên',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Tên Đăng Nhập',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      prefixIcon: Icon(Icons.account_circle_outlined),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: 'Mật Khẩu',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Container(
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: Color(0xFFBF4E19),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: TextButton(
                      onPressed: () {
                        print('Button Pressed');
                        _performRegistration();
                        // _showVerificationDialog();
                      },
                      child: Text(
                        'Đăng Ký',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _performRegistration() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Validate inputs
    if (name.isEmpty || email.isEmpty || username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
      );
      return;
    }

    try {
      RegisterApiService apiService = RegisterApiService();

      // Gửi yêu cầu đăng ký và nhận response
      Map<String, dynamic> response = await apiService.registerUser(
        name: name,
        email: email,
        username: username,
        password: password,
      );

      // Debug log
      print('Full register response: $response');
      // print('Response status code: ${response['statusCode']}');

      // Kiểm tra response
      if (response['statusCode'] == 200 || response['statusCode'] == 201) {
        // Hiển thị dialog nhập mã xác thực
        final verificationCode = await _showVerificationDialog();
        print('Verification code: $verificationCode');

        if (verificationCode != null && verificationCode.isNotEmpty) {
          // Lấy id từ response
          if (response['data'] != null && response['data']['id'] != null) {
            String userId = response['data']['id'];

            // Gửi mã xác thực lên server
            final verificationResponse = await apiService.verifyEmail(
              id: userId,
              code: verificationCode,
            );

            if (verificationResponse['statusCode'] == 200 || verificationResponse['statusCode'] == 201) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đăng ký thành công')),
              );
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Mã xác thực không đúng')),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Lỗi: Không tìm thấy ID người dùng')),
            );
          }
        }
      } else {
        throw Exception(response['message'] ?? 'Đăng ký thất bại');
      }
    } catch (e) {
      print('Error during registration: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng ký thất bại: ${e.toString()}')),
      );
    }
  }

  Future<String?> _showVerificationDialog() {
    final codeController = TextEditingController();

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác thực email'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Vui lòng nhập mã xác thực đã được gửi đến email của bạn'),
              SizedBox(height: 16),
              TextField(
                controller: codeController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  labelText: 'Mã xác thực',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Hủy'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Xác nhận'),
              onPressed: () => Navigator.of(context).pop(codeController.text),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}