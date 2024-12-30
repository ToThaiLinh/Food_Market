import 'package:flutter/material.dart';
import 'group_detail_page.dart';

class FamilyPage extends StatefulWidget {
  const FamilyPage({super.key});

  @override
  _FamilyPageState createState() => _FamilyPageState();
}

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

class Group {
  final String id;
  final String name;
  final String lastUpdated;
  final List<FamilyMember> members;

  Group({
    required this.id,
    required this.name,
    required this.lastUpdated,
    required this.members,
  });
}

class _FamilyPageState extends State<FamilyPage> {
  List<Group> groups = [];

  @override
  void initState() {
    super.initState();
    _initializeGroups();
  }

  void _initializeGroups() {
    groups = [
      Group(
        id: '1',
        name: 'Gia đình',
        lastUpdated: 'Hôm nay',
        members: [
          FamilyMember(
            name: 'Nguyễn Văn A',
            role: 'Bố',
            avatar: 'assets/avatar1.png',
            email: 'nguyenvana@gmail.com',
          ),
          FamilyMember(
            name: 'Nguyễn Thị B',
            role: 'Mẹ',
            avatar: 'assets/avatar2.png',
            email: 'nguyenthib@gmail.com',
          ),
        ],
      ),
      Group(
        id: '2',
        name: 'Nhóm bạn thân',
        lastUpdated: 'Hôm qua',
        members: [
          FamilyMember(
            name: 'Trần Văn C',
            role: 'Thành viên',
            avatar: 'assets/avatar3.png',
            email: 'tranvanc@gmail.com',
          ),
          FamilyMember(
            name: 'Lê Thị D',
            role: 'Thành viên',
            avatar: 'assets/avatar4.png',
            email: 'lethid@gmail.com',
          ),
        ],
      ),
      Group(
        id: '3',
        name: 'Nhóm công việc',
        lastUpdated: '2 ngày trước',
        members: [
          FamilyMember(
            name: 'Phạm Văn E',
            role: 'Trưởng nhóm',
            avatar: 'assets/avatar5.png',
            email: 'phamvane@gmail.com',
          ),
          FamilyMember(
            name: 'Hoàng Thị F',
            role: 'Thành viên',
            avatar: 'assets/avatar6.png',
            email: 'hoangthif@gmail.com',
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý nhóm'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddGroupDialog(context),
          ),
        ],
      ),
      body: _buildSharedLists(),
    );
  }

  Widget _buildSharedLists() {
    return Container(
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
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupDetailPage(
                            members: group.members, groupName: group.name,
                          ),
                        ),
                      );
                    },
                    title: Text(
                      group.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Cập nhật lần cuối: ${group.lastUpdated}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.share),
                          onPressed: () {
                            // Xử lý chia sẻ
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _showEditGroupDialog(group.id, group.name),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _showDeleteConfirmDialog(group.id, group.name),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddGroupDialog(BuildContext context) {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Thêm nhóm mới'),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Tên nhóm',
            border: OutlineInputBorder(),
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
              if (nameController.text.isNotEmpty) {
                final newGroup = Group(
                  id: (groups.length + 1).toString(),
                  name: nameController.text,
                  lastUpdated: 'Vừa tạo',
                  members: [],
                );
                setState(() {
                  groups.add(newGroup);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đã thêm nhóm ${nameController.text}')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _showEditGroupDialog(String groupId, String currentName) {
    final nameController = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sửa tên nhóm'),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Tên nhóm',
            border: OutlineInputBorder(),
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
              if (nameController.text.isNotEmpty) {
                setState(() {
                  final index = groups.indexWhere((g) => g.id == groupId);
                  if (index != -1) {
                    groups[index] = Group(
                      id: groups[index].id,
                      name: nameController.text,
                      lastUpdated: 'Vừa cập nhật',
                      members: groups[index].members,
                    );
                  }
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đã cập nhật tên nhóm')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(String groupId, String groupName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa nhóm "$groupName"?'),
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
                groups.removeWhere((group) => group.id == groupId);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đã xóa nhóm $groupName')),
              );
            },
          ),
        ],
      ),
    );
  }
}