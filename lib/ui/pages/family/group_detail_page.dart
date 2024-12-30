import 'package:flutter/material.dart';
import 'family_page.dart';

class GroupDetailPage extends StatefulWidget {
  final List<FamilyMember> members;
  final String groupName;

  const GroupDetailPage({
    super.key,
    required this.members,
    required this.groupName,
  });

  @override
  _GroupDetailPageState createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<GroupDetailPage> {
  late List<FamilyMember> members;

  @override
  void initState() {
    super.initState();
    members = widget.members;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết nhóm'),
        actions: [
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () => _showAddMemberDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildGroupHeader(),
          Expanded(
            child: _buildMembersList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            widget.groupName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '${members.length} thành viên',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];
        return Card(
          margin: EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(member.avatar),
              backgroundColor: Colors.grey[200],
              child: member.avatar.isEmpty
                  ? Icon(Icons.person, color: Colors.grey[400])
                  : null,
            ),
            title: Text(
              member.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member.role),
                Text(
                  member.email,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Chỉnh sửa'),
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text('Xóa', style: TextStyle(color: Colors.red)),
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'edit') {
                  _showEditMemberDialog(context, member);
                } else if (value == 'delete') {
                  _showDeleteMemberDialog(context, member);
                }
              },
            ),
          ),
        );
      },
    );
  }

  void _showAddMemberDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final roleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Thêm thành viên mới'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Tên thành viên',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: roleController,
                decoration: InputDecoration(
                  labelText: 'Vai trò',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Hủy'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text('Thêm'),
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  emailController.text.isNotEmpty &&
                  roleController.text.isNotEmpty) {
                setState(() {
                  members.add(FamilyMember(
                    name: nameController.text,
                    email: emailController.text,
                    role: roleController.text,
                    avatar: 'assets/default_avatar.png',
                  ));
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đã thêm thành viên ${nameController.text}')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _showEditMemberDialog(BuildContext context, FamilyMember member) {
    final nameController = TextEditingController(text: member.name);
    final emailController = TextEditingController(text: member.email);
    final roleController = TextEditingController(text: member.role);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Chỉnh sửa thành viên'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Tên thành viên',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: roleController,
                decoration: InputDecoration(
                  labelText: 'Vai trò',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
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
              if (nameController.text.isNotEmpty &&
                  emailController.text.isNotEmpty &&
                  roleController.text.isNotEmpty) {
                setState(() {
                  final index = members.indexOf(member);
                  if (index != -1) {
                    members[index] = FamilyMember(
                      name: nameController.text,
                      email: emailController.text,
                      role: roleController.text,
                      avatar: member.avatar,
                    );
                  }
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đã cập nhật thông tin thành viên')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteMemberDialog(BuildContext context, FamilyMember member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa thành viên "${member.name}"?'),
        actions: [
          TextButton(
            child: Text('Hủy'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Xóa'),
            onPressed: () {
              setState(() {
                members.remove(member);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đã xóa thành viên ${member.name}')),
              );
            },
          ),
        ],
      ),
    );
  }
}