// family_group_screen.dart
import 'package:flutter/material.dart';

import 'group_detail_page.dart';

class FamilyMember {
  final String name;
  final String role;
  final String avatar;
  final String email;

  FamilyMember({
    required this.name,
    required this.role,
    required this.avatar,
    required this.email,
  });
}

class FamilyPage extends StatefulWidget {
  @override
  _FamilyPageState createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  List<String> shoppingLists = [];
  String newListName = '';
  String groupName = 'Nhóm Gia Đình';
  final List<FamilyMember> members = [
    // FamilyMember(
    //   name: 'Nguyễn Văn A',
    //   role: 'Trưởng nhóm',
    //   avatar: 'assets/avatar1.png',
    // ),
    // FamilyMember(
    //   name: 'Nguyễn Thị B',
    //   role: 'Thành viên',
    //   avatar: 'assets/avatar2.png',
    // ),
    // Add more members as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nhóm Gia Đình'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          _buildSharedLists(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showCreateGroupDialog();
        },
      ),
    );
  }

  Widget _buildSharedLists() {
    return Expanded(
      flex: 2,
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Danh sách nhóm chia sẻ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: shoppingLists.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Chuyển hướng đến GroupDetailPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupDetailPage(
                            members: members,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(shoppingLists[index]),
                        subtitle: Text('Cập nhật lần cuối: 2 giờ trước'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.share),
                              onPressed: () {
                                // Handle share
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _showEditGroupDialog(shoppingLists[index]);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditGroupDialog(String currentGroupName) {
    TextEditingController controller = TextEditingController(text: currentGroupName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Chỉnh sửa tên nhóm'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Tên nhóm',
          ),
        ),
        actions: [
          TextButton(
            child: Text('Hủy'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text('Lưu'),
            onPressed: () {
              setState(() {
                // Cập nhật tên nhóm trong shoppingLists
                int index = shoppingLists.indexOf(currentGroupName);
                if (index != -1) {
                  shoppingLists[index] = controller.text; // Cập nhật tên nhóm
                }
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showAddMemberDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Thêm thành viên mới'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Tên thành viên',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Hủy'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text('Thêm'),
            onPressed: () {
              // Handle add member
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showEditMemberDialog(FamilyMember member) {
    // Implementation for editing member
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Chỉnh sửa thành viên'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Tên thành viên',
                hintText: member.name,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Email của ${member.name}',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Hủy'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text('Lưu'),
            onPressed: () {
              // Handle save changes
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(FamilyMember member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa ${member.name}?'),
        actions: [
          TextButton(
            child: Text('Hủy'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text('Xóa'),
            onPressed: () {
              // Handle delete member
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showCreateGroupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tạo nhóm mua sắm mới'),
        content: TextField(
          decoration: InputDecoration(
            labelText: 'Tên nhóm',
          ),
          onChanged: (value) {
            // Lưu tên danh sách vào biến
            newListName = value; // newListName là biến để lưu tên danh sách
          },
        ),
        actions: [
          TextButton(
            child: Text('Hủy'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text('Tạo'),
            onPressed: () {
              // Thêm danh sách mới vào danh sách shoppingLists
              if (newListName.isNotEmpty) {
                setState(() {
                  shoppingLists.add(newListName);
                });
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}