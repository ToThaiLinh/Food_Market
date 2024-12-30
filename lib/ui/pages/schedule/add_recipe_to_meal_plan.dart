import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddFoodToFridgeDialog extends StatefulWidget {
  final Map<String, dynamic> selectedFood;

  const AddFoodToFridgeDialog({super.key, required this.selectedFood});

  @override
  _AddFoodToFridgeDialogState createState() => _AddFoodToFridgeDialogState();
}

class _AddFoodToFridgeDialogState extends State<AddFoodToFridgeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _useWithinController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Thêm vào tủ lạnh'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.selectedFood['name'] ?? 'Không có tên',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
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
                'food': widget.selectedFood,
                'quantity': int.parse(_quantityController.text),
                'useWithin': int.parse(_useWithinController.text),
                'note': _noteController.text,
              });
            }
          },
          child: Text('Thêm'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFBF4E19),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _useWithinController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}