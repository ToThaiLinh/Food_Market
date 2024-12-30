import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food/bloc/user/user_bloc.dart';
import 'package:food/ui/pages/me/change_password_page.dart';
import 'package:food/ui/pages/me/user_info.dart';

import '../../../bloc/user/user_event.dart';
import '../../../bloc/user/user_state.dart';
import '../../../models/user.dart';
import '../../../services/user_service.dart';

class MePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => UserBloc(userService: UserService())..add(LoadUserInfoEvent()),
      child: MeView()
    );
  }
}

class MeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tài khoản', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor, // Sử dụng màu chủ đạo từ theme
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is UserLoadedState) {
            return _buildUserInfo(context, state.user!);
          } else if (state is UserErrorState) {
            return Center(
              child: Text(
                'Đã xảy ra lỗi: ${state.message}',
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          return Center(child: Text('Không có dữ liệu người dùng.'));
        },
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, User user) {
    return SingleChildScrollView(
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
                  backgroundImage: NetworkImage(
                      'https://chiemtaimobile.vn/images/companies/1/%E1%BA%A2nh%20Blog/avatar-facebook-dep/Anh-avatar-hoat-hinh-de-thuong-xinh-xan.jpg?1704788263223 // Use NetworkImage here'
                  ),
                  onBackgroundImageError: (exception, stackTrace) {
                    print('Failed to load image: $exception');
                  },
                  child: null, // Optional child widget if no image
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.username!,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Email : ${user.email!}",
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
                  MaterialPageRoute(builder: (context) => UserInfoPage(user: user)),
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
                              Navigator.pushReplacementNamed(context, '/login_page');
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
      );
  }
}
