import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food/bloc/user/user_event.dart';
import 'package:food/bloc/user/user_state.dart';
import 'package:food/ui/pages/me/user_info_page.dart';

import '../../../bloc/user/user_bloc.dart';
import '../../../models/user.dart';
import '../../../services/user_services.dart';
import 'change_password_page.dart';

class MePage extends StatelessWidget {
  final Widget child;
  MePage({required this.child});
  @override
  Widget build(BuildContext context) {
    return BlocProvider (
      create: (BuildContext context) => UserBloc (
        userService:  UserService()
      )..add(LoadUserInfoEvent()),
      child: this.child
    );
  }

}

class MeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MePage(
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoadingState) {
            return Center(child: CircularProgressIndicator());
          // } else if (state is UserErrorState) {
          //   return Center(child: Text(state.error));
          } else if (state is UserLoadedState) {
            // final user = state.user;
            return OverViewMePage();
          } else {
            // return Center(child: Text('Trạng thái không xác định')
            return OverViewMePage();
          }
        },
      ),
    );
  }
}


class OverViewMePage extends StatelessWidget {
  OverViewMePage();
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
                      Text("user.username",
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





