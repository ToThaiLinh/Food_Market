import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/group/group_bloc.dart';
import '../../../bloc/group/group_event.dart';
import '../../../bloc/group/group_state.dart';
import '../../../models/group.dart';
import '../../../services/group_service.dart';

class FamilyPage extends StatefulWidget {
  @override
  _FamilyPageState createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  String newListName = '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupBloc(groupService: GroupService())..add(LoadGroups()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Nhóm Gia Đình'),
          automaticallyImplyLeading: false,
        ),
        body: BlocConsumer<GroupBloc, GroupState>(
          listener: (context, state) {
            if (state is GroupError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is GroupLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is GroupLoaded) {
              return Column(
                children: [_buildSharedLists(context, state.groups)],
              );
            }
            return Center(child: Text('No groups available'));
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _showCreateGroupDialog(context),
        ),
      ),
    );
  }

  Widget _buildSharedLists(BuildContext context, List<Group> groups) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Danh sách nhóm chia sẻ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  final group = groups[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => GroupDetailPage(groupId: group.id ?? ''),
                      //   ),
                      // );
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(group.name ?? ''),
                        subtitle: Text('Admin: ${group.admin?.username}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.share),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => _showEditGroupDialog(context, group),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _showDeleteConfirmDialog(context, group),
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

  void _showCreateGroupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tạo nhóm mua sắm mới'),
        content: TextField(
          decoration: InputDecoration(labelText: 'Tên nhóm'),
          onChanged: (value) => newListName = value,
        ),
        actions: [
          TextButton(
            child: Text('Hủy'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text('Tạo'),
            onPressed: () {
              if (newListName.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Vui lòng nhập tên nhóm')),
                );
                return;
              }
              context.read<GroupBloc>().add(CreateGroup(newListName));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // Thêm hàm mới này
  void _showDeleteConfirmDialog(BuildContext context, Group group) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa nhóm "${group.name}" không?'),
        actions: [
          TextButton(
            child: Text('Hủy'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('Xóa'),
            onPressed: () {
              context.read<GroupBloc>().add(DeleteGroup(group.id ?? ''));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showEditGroupDialog(BuildContext context, Group group) {
    final controller = TextEditingController(text: group.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Chỉnh sửa nhóm'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: 'Tên nhóm'),
        ),
        actions: [
          TextButton(
            child: Text('Hủy'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text('Lưu'),
            onPressed: () {
              // Add edit group functionality
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}