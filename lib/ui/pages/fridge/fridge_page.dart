import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food/ui/pages/fridge/select_food_dialog.dart';
import 'package:food/ui/pages/fridge/update_food_in_fridge_dialog.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/fridge_api_service.dart';
import '../../../services/shopping_api_service.dart';
import 'add_food_to_fridge_dialog.dart';

class FridgePage extends StatefulWidget {
  const FridgePage({super.key});

  @override
  _FridgePageState createState() => _FridgePageState();
}

class _FridgePageState extends State<FridgePage> {
  late ShoppingApiService _shoppingApiService;
  late FridgeApiService _fridgeApiService;
  List<Map<String, dynamic>> _fridgeFoods = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _shoppingApiService = ShoppingApiService();
    _fridgeApiService = FridgeApiService();
    loadFoodsFromStorage();
  }

  Future<void> loadFoodsFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? fridgeFoodsJson = prefs.getString('fridge_foods');

      if (fridgeFoodsJson != null) {
        final List<dynamic> decodedItems = jsonDecode(fridgeFoodsJson);
        if (mounted) {
          setState(() {
            _fridgeFoods = decodedItems.cast<Map<String, dynamic>>();
          });
        }
      }
    } catch (e) {
      print('Error loading fridge foods: $e');
    }
  }

  Future<void> _saveFridgeFoods() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String fridgeFoodsJson = jsonEncode(_fridgeFoods);
      await prefs.setString('fridge_foods', fridgeFoodsJson);
    } catch (e) {
      print('Error saving fridge foods: $e');
    }
  }

  Future<void> _fetchFridgeFoods() async {
    try {
      final foods = await _shoppingApiService.getAllFoods();
      if (foods != null) {
        setState(() {
          _fridgeFoods = foods;
        });
      }
    } catch (e) {
      print('Error fetching fridge foods: $e');
    }
  }

  bool _isExpiringSoon(DateTime expiryDate) {
    final daysUntilExpiry = expiryDate.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 3 && daysUntilExpiry >= 0;
  }

  bool _isExpired(DateTime expiryDate) {
    return expiryDate.isBefore(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          _buildCategoryTabs(),
          Expanded(
            child: _buildFoodList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFBF4E19),
        child: Icon(Icons.add),
        onPressed: () => _showAddFoodDialog(),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16.w),
      color: Color(0xFFBF4E19),
      child: SafeArea(
        child: Row(
          children: [
            Icon(Icons.kitchen, color: Colors.white, size: 24.w),
            SizedBox(width: 8.w),
            Text(
              'Tủ lạnh của tôi',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Tìm kiếm thực phẩm...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 40.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCategoryChip('Tất cả', true),
          _buildCategoryChip('Rau củ', false),
          _buildCategoryChip('Thịt', false),
          _buildCategoryChip('Đã chế biến', false),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        onSelected: (bool selected) {
          // Implement category filtering
        },
        backgroundColor: Colors.grey[200],
        selectedColor: Color(0xFFBF4E19).withOpacity(0.2),
        labelStyle: TextStyle(
          color: isSelected ? Color(0xFFBF4E19) : Colors.black,
        ),
      ),
    );
  }

  Widget _buildFoodList() {
    if (_fridgeFoods.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.no_food, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Chưa có thực phẩm nào trong tủ lạnh',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    final filteredFoods = _fridgeFoods
        .where((food) => food['itemName'].toString().toLowerCase()
        .contains(_searchQuery.toLowerCase()))
        .toList();

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: filteredFoods.length,
      itemBuilder: (context, index) {
        final food = filteredFoods[index];
        final createdAt = DateTime.parse(food['createdAt'] ?? DateTime.now().toIso8601String());
        final expiryDate = createdAt.add(Duration(days: food['useWithin'] ?? 0));

        return Dismissible(
          key: Key(food['id']?.toString() ?? DateTime.now().toString()),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) => _showDeleteConfirmation(food),
          confirmDismiss: (DismissDirection direction) async {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Xác nhận xóa'),
                  content: Text('Bạn có chắc chắn muốn xóa thực phẩm này không?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('Hủy'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text('Xóa'),
                    ),
                  ],
                );
              },
            );
          },
          child: Card(
            elevation: 2,
            margin: EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Color(0xFFBF4E19).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.food_bank,
                  color: Color(0xFFBF4E19),
                ),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      food['itemName']?.toString() ?? 'Không có tên',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // if (_isExpiringSoon(expiryDate))
                  //   Container(
                  //     margin: EdgeInsets.only(left: 8.w),
                  //     padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  //     decoration: BoxDecoration(
                  //       color: Colors.orange.withOpacity(0.2),
                  //       borderRadius: BorderRadius.circular(4.r),
                  //     ),
                  //     child: Text(
                  //       'Sắp hết hạn',
                  //       style: TextStyle(
                  //         color: Colors.orange,
                  //         fontSize: 12.sp,
                  //       ),
                  //     ),
                  //   ),
                  // if (_isExpired(expiryDate))
                  //   Container(
                  //     margin: EdgeInsets.only(left: 8.w),
                  //     padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  //     decoration: BoxDecoration(
                  //       color: Colors.red.withOpacity(0.2),
                  //       borderRadius: BorderRadius.circular(4.r),
                  //     ),
                  //     child: Text(
                  //       'Đã hết hạn',
                  //       style: TextStyle(
                  //         color: Colors.red,
                  //         fontSize: 12.sp,
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4.h),
                  Text('Số lượng: ${food['quantity']?.toString() ?? '0'}'),
                  Text(
                    'Hết hạn: ${DateFormat('dd/MM/yyyy').format(expiryDate)}',
                    style: TextStyle(
                      color: _isExpiringSoon(expiryDate) ? Colors.orange :
                      _isExpired(expiryDate) ? Colors.red : Colors.grey[600],
                    ),
                  ),
                  if (food['note'] != null && food['note'].toString().isNotEmpty)
                    Text('Ghi chú: ${food['note']}'),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _showUpdateFoodDialog(food),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showDeleteConfirmation(Map<String, dynamic> food) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa ${food['foodName']} không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _fridgeFoods.removeWhere((item) => item['id'] == food['id']);
      });
      await _saveFridgeFoods(); // Lưu sau khi xóa
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xóa thực phẩm thành công')),
      );
    }
  }

  Future<void> _showAddFoodDialog() async {
    final selectedFood = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => SelectFoodDialog(),
    );

    print('Selected Food: $selectedFood');

    if (selectedFood != null) {
      final result = await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (context) => AddFoodToFridgeDialog(selectedFood: selectedFood),
      );

      print('Dialog Result: $result');

      if (result != null) {
        setState(() {
          _fridgeFoods.add({
            'id': DateTime.now().toString(),
            'itemName': result['food']['name'],
            'quantity': result['quantity'],
            'useWithin': result['useWithin'],
            'note': result['note'] ?? '',
            'createdAt': DateTime.now().toIso8601String(),
          });
        });

        await _saveFridgeFoods();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã thêm thực phẩm vào tủ lạnh')),
        );
        // try {
        //   final food = result['food'] as Map<String, dynamic>;
        //   final String? foodId = food['_id']?.toString();
        //
        //   print('Adding food with details:');
        //   print('Food ID: $foodId');
        //   print('Quantity: ${result['quantity']}');
        //   print('Use Within: ${result['useWithin']}');
        //   print('Note: ${result['note']}');
        //
        //   if (foodId == null || foodId.isEmpty) {
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       SnackBar(content: Text('Food ID không hợp lệ')),
        //     );
        //     return;
        //   }
        //
        //   // Ensure quantity and useWithin are integers
        //   final quantity = int.tryParse(result['quantity'].toString());
        //   final useWithin = int.tryParse(result['useWithin'].toString());
        //
        //   if (quantity == null || useWithin == null) {
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       SnackBar(content: Text('Số lượng hoặc thời hạn sử dụng không hợp lệ')),
        //     );
        //     return;
        //   }
        //
        //   final newItem = await _fridgeApiService.createFridgeItem(
        //     foodId: foodId,
        //     quantity: quantity,
        //     useWithin: useWithin,
        //     note: result['note'] ?? '',
        //   );
        //
        //   if (newItem != null) {
        //     await _fetchFridgeFoods();
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       SnackBar(content: Text('Đã thêm thực phẩm vào tủ lạnh')),
        //     );
        //   } else {
        //     throw Exception('Không thể thêm thực phẩm: Vui lòng kiểm tra lại thông tin');
        //   }
        // } catch (e) {
        //   print('Error in _showAddFoodDialog: $e');
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text('Thêm thực phẩm thất bại: ${e.toString()}')),
        //   );
        // }
      }
    }
  }

  Future<void> _showUpdateFoodDialog(Map<String, dynamic> food) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => UpdateFoodInFridgeDialog(food: food),
    );

    if (result != null) {
      setState(() {
        final index = _fridgeFoods.indexWhere((item) => item['id'] == food['id']);
        if (index != -1) {
          _fridgeFoods[index] = {
            ..._fridgeFoods[index],
            'quantity': result['quantity'],
            'useWithin': result['useWithin'],
            'note': result['note'] ?? '',
          };
        }
      });
      await _saveFridgeFoods(); // Lưu sau khi cập nhật
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã cập nhật thực phẩm thành công')),
      );
    }
  }
}