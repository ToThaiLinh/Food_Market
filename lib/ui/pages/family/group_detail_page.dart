// import 'package:flutter/material.dart';
// import '../../../models/user.dart';
//
// class GroupDetailPage extends StatefulWidget {
//   final List<User> members;
//
//   const GroupDetailPage({super.key, required this.members});
//   @override
//   _GroupDetailPageState createState() => _GroupDetailPageState();
// }
//
// class _GroupDetailPageState extends State<GroupDetailPage> {
//   List<User> members = []; // Danh sách thành viên
//
//   @override
//   void initState() {
//     super.initState();
//     // Khởi tạo danh sách thành viên nếu cần
//     members = [
//
//     ];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chi tiết nhóm'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.person_add),
//             onPressed: () {
//               _showAddMemberDialog(context);
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           _buildGroupHeader(),
//           _buildMembersList(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildGroupHeader() {
//     return Container(
//       padding: EdgeInsets.all(16),
//       color: Colors.blue.withOpacity(0.1),
//       child: Column(
//         children: [
//           Text(
//             'Gia đình của tôi',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             '${members.length} thành viên',
//             style: TextStyle(
//               color: Colors.grey[600],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMembersList() {
//     return Expanded(
//       child: ListView.builder(
//         itemCount: members.length,
//         itemBuilder: (context, index) {
//           final member = members[index];
//           return ListTile(
//             leading: CircleAvatar(
//               backgroundImage: AssetImage(member.photoUrl!),
//             ),
//             title: Text(member.name!),
//             subtitle: Text(member.username!),
//             trailing: IconButton(
//               icon: Icon(Icons.edit),
//               onPressed: () {
//                 _showEditMemberDialog(context, member); // Gọi hàm chỉnh sửa
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   void _showAddMemberDialog(BuildContext context) {
//     TextEditingController nameController = TextEditingController();
//     TextEditingController emailController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Thêm thành viên mới'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: InputDecoration(
//                 labelText: 'Tên thành viên',
//               ),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(
//                 labelText: 'Email',
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             child: Text('Hủy'),
//             onPressed: () => Navigator.pop(context),
//           ),
//           ElevatedButton(
//             child: Text('Thêm'),
//             onPressed: () {
//               // Thêm thành viên mới vào danh sách
//               setState(() {
//                 members.add(FamilyMember(
//                   name: nameController.text,
//                   role: 'Thành viên', // Có thể thay đổi nếu cần
//                   avatar: 'assets/default_avatar.png', // Đặt avatar mặc định
//                   email: emailController.text,
//                 ));
//               });
//               Navigator.pop(context);
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showEditMemberDialog(BuildContext context, FamilyMember member) {
//     TextEditingController nameController = TextEditingController(text: member.name);
//     TextEditingController emailController = TextEditingController(text: member.email); // Cập nhật email
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Chỉnh sửa thành viên'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: InputDecoration(
//                 labelText: 'Tên thành viên',
//               ),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(
//                 labelText: 'Email',
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             child: Text('Hủy'),
//             onPressed: () => Navigator.pop(context),
//           ),
//           ElevatedButton(
//             child: Text('Lưu'),
//             onPressed: () {
//               // Cập nhật thông tin thành viên
//               setState(() {
//                 int index = members.indexOf(member);
//                 if (index != -1) {
//                   members[index] = User(
//                     name: nameController.text,
//                     role: member.role, // Giữ nguyên vai trò
//                     avatar: member.avatar, // Giữ nguyên avatar
//                     email: emailController.text,
//                   );
//                 }
//               });
//               Navigator.pop(context);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }