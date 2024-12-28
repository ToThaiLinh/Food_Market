import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpdateFoodInFridgeDialog extends StatefulWidget {
  final Map<String, dynamic> food;

  UpdateFoodInFridgeDialog({required this.food});

  @override
  _UpdateFoodInFridgeDialogState createState() => _UpdateFoodInFridgeDialogState();
}

class _UpdateFoodInFridgeDialogState extends State<UpdateFoodInFridgeDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _useWithinController;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.food['name']);
    _quantityController = TextEditingController(text: widget.food['quantity'].toString());
    _useWithinController = TextEditingController(text: widget.food['useWithin'].toString());
    _noteController = TextEditingController(text: widget.food['note'] ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cập nhật thực phẩm'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Tên thực phẩm',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Vui lòng nhập tên thực phẩm';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: 'Số lượng',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Vui lòng nhập số lượng';
                  }
                  if (int.tryParse(value!) == null) {
                    return 'Vui lòng nhập số hợp lệ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              TextFormField(
                controller: _useWithinController,
                decoration: InputDecoration(
                  labelText: 'Hạn sử dụng (số ngày)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Vui lòng nhập hạn sử dụng';
                  }
                  if (int.tryParse(value!) == null) {
                    return 'Vui lòng nhập số hợp lệ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: 'Ghi chú',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              Navigator.of(context).pop({
                'name': _nameController.text,
                'quantity': int.parse(_quantityController.text),
                'useWithin': int.parse(_useWithinController.text),
                'note': _noteController.text,
              });
            }
          },
          child: Text('Cập nhật'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFBF4E19),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _useWithinController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}