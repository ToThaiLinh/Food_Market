import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../services/shopping_api_service.dart';

class SelectFoodDialog extends StatefulWidget {
  @override
  _SelectFoodDialogState createState() => _SelectFoodDialogState();
}

class _SelectFoodDialogState extends State<SelectFoodDialog> {
  final ShoppingApiService _shoppingApiService = ShoppingApiService();
  List<dynamic> _foods = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchFoods();
  }

  Future<void> _fetchFoods() async {
    final foods = await _shoppingApiService.getAllFoods();
    if (foods != null) {
      setState(() {
        _foods = foods;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredFoods = _foods.where((food) =>
        food['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    return Dialog(
      child: Container(
        width: 0.9.sw,
        height: 0.8.sh,
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Text(
              'Chọn thực phẩm',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Tìm kiếm thực phẩm...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: ListView.builder(
                itemCount: filteredFoods.length,
                itemBuilder: (context, index) {
                  final food = filteredFoods[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xFFBF4E19).withOpacity(0.1),
                      child: Icon(Icons.food_bank, color: Color(0xFFBF4E19)),
                    ),
                    title: Text(food['name'] ?? 'Không có tên'),
                    subtitle: Text(food['category'] ?? 'Không có danh mục'),
                    onTap: () {
                      Navigator.of(context).pop(food);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}