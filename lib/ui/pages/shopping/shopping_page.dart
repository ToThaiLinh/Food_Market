import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../../services/shopping_api_service.dart';
import 'food_image_widget.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  _ShoppingPageState createState() => _ShoppingPageState();
  static List<Map<String, dynamic>> getShoppingItems(BuildContext context) {
    final state = context.findAncestorStateOfType<_ShoppingPageState>();
    return state?.getShoppingItems() ?? [];
  }
}

class _ShoppingPageState extends State<ShoppingPage> {
  List<Map<String, dynamic>> shoppingItems = [];
  final ShoppingApiService _apiService = ShoppingApiService();
  DateTime selectedDate = DateTime.now();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredItems = [];
  bool isSearching = false;
  List<Map<String, dynamic>> getShoppingItems() {
    return shoppingItems;
  }
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadShoppingItems(); // Hiển thị tất cả item ban đầu
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _saveShoppingItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String shoppingItemsJson = jsonEncode(shoppingItems);
      await prefs.setString('shopping_items', shoppingItemsJson);
      print('Saved shopping items: $shoppingItemsJson');
    } catch (e) {
      print('Error saving shopping items: $e');
    }
  }

  Future<void> _loadShoppingItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? shoppingItemsJson = prefs.getString('shopping_items');

      if (shoppingItemsJson != null) {
        final List<dynamic> decodedItems = jsonDecode(shoppingItemsJson);
        if (mounted) {
          setState(() {
            shoppingItems = decodedItems.cast<Map<String, dynamic>>();
          });
        }
        print('Loaded shopping items: $shoppingItems');
      }
    } catch (e) {
      print('Error loading shopping items: $e');
    }
  }

  void _addItem(Map<String, dynamic> item) async {
    try {
      final result = await _apiService.createFood(
        name: item['name']!,
        unit: item['unit'] ?? '',
        category: item['category'] ?? 'Uncategorized',
        file: _imageFile!,
      );

      if (result != null) {
        setState(() {
          shoppingItems.add({
            '_id': result['_id'],
            'name': result['name'],
            'unit': result['unit'],
            'category': result['category'],
            'imageUrl': result['imageUrl'],
            'userIdCreate': result['userIdCreate'],
          });
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thêm thực phẩm thành công!')),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Có lỗi xảy ra khi thêm thực phẩm')),
        );
      }
    } catch (e) {
      print('Error in _addItem: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }

  void _removeItem(int index) async {
    if (index < 0 || index >= shoppingItems.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không tìm thấy thực phẩm để xóa')),
      );
      return;
    }

    final item = shoppingItems[index];
    final itemId = item['_id'];

    print('Attempting to delete item with ID: $itemId');

    if (itemId == null || itemId.toString().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể xóa thực phẩm vì thiếu ID')),
      );
      return;
    }

    try {
      final success = await _apiService.deleteFood(id: itemId.toString());
      print('Delete operation result: $success');

      if (success) {
        print('Delete successful, removing item from list');
        setState(() {
          shoppingItems.removeAt(index);
        });

        await _saveShoppingItems(); // Lưu lại danh sách sau khi xóa

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Xóa thực phẩm thành công!')),
          );
        }
      } else {
        print('Delete operation returned false');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Không thể xóa thực phẩm. Vui lòng thử lại')),
          );
        }
      }
    } catch (e) {
      print('Error in _removeItem: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi xóa thực phẩm: $e')),
        );
      }
    }
  }

  void _search(String query) {
    setState(() {
      filteredItems =
          shoppingItems // Sử dụng shoppingItems thay vì availableItems
              .where((item) =>
                  item['name']!.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          _buildDateSelector(),
          _buildCategories(),
          Expanded(
            child: _buildShoppingList(),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingButtons(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFBF4E19),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Danh sách mua sắm',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Quản lý danh sách mua sắm của bạn',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(Icons.calendar_today, color: Color(0xFFBF4E19)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Ngày ${DateFormat('dd MMMM yyyy', 'vi').format(selectedDate)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton.icon(
            icon: Icon(Icons.edit_calendar, color: Color(0xFFBF4E19)),
            label: Text(
              'Đổi ngày',
              style: TextStyle(color: Color(0xFFBF4E19)),
            ),
            onPressed: () => _showCalendarDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    final categories = ['Tất cả', 'Rau củ', 'Thịt', 'Hải sản', 'Gia vị'];
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              label: Text(categories[index]),
              selected: index == 0,
              onSelected: (bool selected) {
                // Implement category filter
              },
              selectedColor: Color(0xFFBF4E19).withOpacity(0.2),
              labelStyle: TextStyle(
                color: index == 0 ? Color(0xFFBF4E19) : Colors.grey[600],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShoppingList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: shoppingItems.length,
      itemBuilder: (context, index) {
        final item = shoppingItems[index];
        print('Rendering item: $item');

        return Dismissible(
          key: Key(item['_id']?.toString() ?? DateTime.now().toString()),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) => _removeItem(index),
          confirmDismiss: (DismissDirection direction) async {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Xác nhận xóa'),
                  content:
                      Text('Bạn có chắc chắn muốn xóa thực phẩm này không?'),
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
              leading: FoodImageWidget(
                imageUrl: item['imageUrl'], // Sử dụng imageUrl từ API
              ),
              title: Text(
                item['name']?.toString() ?? 'Không có tên',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Số lượng: ${item['quantity']?.toString() ?? '0'} ${item['unit']}\n'
                'Danh mục: ${item['category']}',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () async {
                      final item = shoppingItems[index]; // Lấy item hiện tại
                      await _showEditFoodDialog(context, item);
                    },
                  ),
                  // IconButton(
                  //   icon: Icon(Icons.delete, color: Colors.red),
                  //   onPressed: () => _removeItem(index),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'createFood',
            onPressed: () => _showCreateFoodDialog(context),
            backgroundColor: Color(0xFF16A34A),
            child: Icon(Icons.create, color: Colors.white),
            tooltip: 'Tạo món ăn mới',
          ),
          SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'addFood',
            onPressed: () => _showUpdateFoodDialog(context),
            backgroundColor: Color(0xFFBF4E19),
            child: Icon(Icons.add_shopping_cart, color: Colors.white),
            tooltip: 'Thêm vào giỏ hàng',
          ),
        ],
      ),
    );
  }

  void _showCalendarDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFBF4E19),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Chọn ngày',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              TableCalendar(
                locale: 'vi',
                firstDay: DateTime(2020),
                lastDay: DateTime(2100),
                focusedDay: selectedDate,
                selectedDayPredicate: (day) => isSameDay(day, selectedDate),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    selectedDate = selectedDay;
                  });
                  Navigator.pop(context);
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Color(0xFFBF4E19).withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Color(0xFFBF4E19),
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle: TextStyle(color: Colors.red),
                  outsideTextStyle: TextStyle(color: Colors.grey),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                  leftChevronIcon:
                      Icon(Icons.chevron_left, color: Color(0xFFBF4E19)),
                  rightChevronIcon:
                      Icon(Icons.chevron_right, color: Color(0xFFBF4E19)),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Hủy',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFBF4E19),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Xác nhận'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showEditFoodDialog(BuildContext context, Map<String, dynamic> item) {
    final nameController = TextEditingController(text: item['name'] ?? '');
    FoodCategory? selectedCategory; // Initialize with current category
    FoodUnit? selectedUnit; // Initialize with current unit

    // Convert string to enum for category
    selectedCategory = FoodCategory.values.firstWhere(
            (cat) => cat.toString().split('.').last == item['category'],
        orElse: () => FoodCategory.Other
    );

    // Convert string to enum for unit
    selectedUnit = FoodUnit.values.firstWhere(
            (unit) => unit.toString().split('.').last == item['unit'],
        orElse: () => FoodUnit.Other
    );

    return showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.edit_note, color: Color(0xFF16A34A)),
                        SizedBox(width: 8),
                        Text(
                          'Chỉnh sửa thực phẩm',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _imageFile != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _imageFile!,
                          fit: BoxFit.cover,
                        ),
                      )
                          : item['imageUrl'] != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: FoodImageWidget(
                          imageUrl: item['imageUrl'],
                        ),
                      )
                          : IconButton(
                        icon: Icon(Icons.add_photo_alternate),
                        onPressed: () async {
                          await _pickImage();
                          setState(() {}); // Update UI after picking image
                        },
                      ),
                    ),
                    SizedBox(height: 24),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Tên thực phẩm',
                        prefixIcon: Icon(Icons.food_bank),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<FoodCategory>(
                      value: selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Danh mục',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: FoodCategory.values.map((FoodCategory category) {
                        return DropdownMenuItem<FoodCategory>(
                          value: category,
                          child: Text(category.toString().split('.').last),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<FoodUnit>(
                      value: selectedUnit,
                      decoration: InputDecoration(
                        labelText: 'Đơn vị',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: FoodUnit.values.map((FoodUnit unit) {
                        return DropdownMenuItem<FoodUnit>(
                          value: unit,
                          child: Text(unit.toString().split('.').last),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedUnit = value;
                        });
                      },
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Hủy',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () async {
                            if (nameController.text.isEmpty ||
                                selectedCategory == null ||
                                selectedUnit == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
                              );
                              return;
                            }

                            try {
                              final foodId = item['_id'].toString();
                              final result = await _apiService.updateFood(
                                id: foodId,
                                name: nameController.text.trim(),
                                category: selectedCategory.toString().split('.').last,
                                unit: selectedUnit.toString().split('.').last,
                                userIdCreate: item['userIdCreate'] ?? '',
                                file: _imageFile, // Pass the file directly, it can be null
                              );

                              if (result != null) {
                                setState(() {
                                  final index = shoppingItems.indexWhere((i) => i['_id'] == item['_id']);
                                  if (index != -1) {
                                    shoppingItems[index] = {
                                      '_id': result['_id'],
                                      'name': result['name'],
                                      'category': result['category'],
                                      'unit': result['unit'],
                                      'imageUrl': result['imageUrl'] ?? item['imageUrl'], // Keep old image URL if no new one
                                      'userIdCreate': result['userIdCreate'],
                                    };
                                  }
                                });

                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Cập nhật thực phẩm thành công')),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Có lỗi xảy ra khi cập nhật thực phẩm')),
                                );
                              }
                            } catch (e) {
                              print('Error during update: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Có lỗi xảy ra khi cập nhật thực phẩm')),
                              );
                            }
                          },
                          child: Text('Cập nhật'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showUpdateFoodDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // Header
                  Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Text(
                    'Chọn thực phẩm',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Search Box
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Tìm thực phẩm',
                      hintText: 'Nhập tên thực phẩm...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    onChanged: (value) {
                      setState(() {
                        _search(value);
                      });
                    },
                  ),
                  SizedBox(height: 16),

                  // Food List
                  Expanded(
                    child: FutureBuilder<List<Map<String, dynamic>>?>(
                      future: _apiService.getAllFoods(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFBF4E19),
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error_outline, size: 48, color: Colors.red),
                                SizedBox(height: 16),
                                Text('Có lỗi xảy ra: ${snapshot.error}'),
                              ],
                            ),
                          );
                        }

                        final foods = _searchController.text.isEmpty
                            ? snapshot.data ?? []
                            : filteredItems;

                        if (foods.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.no_food, size: 48, color: Colors.grey),
                                SizedBox(height: 16),
                                Text('Không tìm thấy thực phẩm nào'),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: foods.length,
                          itemBuilder: (context, index) {
                            final food = foods[index];
                            return Card(
                              margin: EdgeInsets.only(bottom: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: FoodImageWidget(
                                  imageUrl: food['imageUrl'],
                                ),
                                title: Text(
                                  food['name']?.toString() ?? 'Không có tên',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  'Số lượng: ${food['quantity']?.toString() ?? '0'} ${food['unit']?.toString() ?? ''}\n'
                                      'Danh mục: ${food['category']?.toString() ?? 'Chưa phân loại'}',
                                ),
                                onTap: () async {  // Thêm async
                                  final newItem = {
                                    '_id': food['_id'],
                                    'name': food['name'] ?? 'Không có tên',
                                    'category': food['category'] ?? 'Chưa phân loại',
                                    'unit': food['unit'] ?? '',
                                    'quantity': food['quantity'] ?? 0,
                                    'userIdCreate': food['userIdCreate'] ?? '',
                                    'imageUrl': food['imageUrl'], // Sử dụng imageUrl từ API response
                                  };

                                  setState(() {
                                    final existingIndex = shoppingItems.indexWhere(
                                            (item) => item['_id'] == newItem['_id']
                                    );

                                    if (existingIndex != -1) {
                                      shoppingItems[existingIndex]['quantity'] =
                                          (shoppingItems[existingIndex]['quantity'] ?? 0) +
                                              (newItem['quantity'] ?? 0);
                                    } else {
                                      shoppingItems.add(newItem);
                                    }
                                  });

                                  // Lưu vào SharedPreferences sau khi thêm
                                  await _saveShoppingItems();

                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Đã thêm ${food['name']} vào danh sách')),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showCreateFoodDialog(BuildContext context) {
    final nameController = TextEditingController();
    FoodCategory? selectedCategory; // Khai báo biến để lưu danh mục đã chọn
    FoodUnit? selectedUnit; // Khai báo biến để lưu đơn vị đã chọn

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(Icons.add_circle, color: Color(0xFF16A34A)),
                      SizedBox(width: 8),
                      Text(
                        'Tạo thực phẩm mới',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _imageFile != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _imageFile!,
                        fit: BoxFit.cover,
                      ),
                    )
                        : IconButton(
                      icon: Icon(Icons.add_photo_alternate),
                      onPressed: () async {
                        await _pickImage();
                        setState(() {}); // Update UI sau khi chọn ảnh
                      },
                    ),
                  ),
                  SizedBox(height: 24),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Tên thực phẩm',
                      prefixIcon: Icon(Icons.food_bank),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  SizedBox(height: 16),
                  // Dropdown cho danh mục
                  DropdownButtonFormField<FoodCategory>(
                    decoration: InputDecoration(
                      labelText: 'Danh mục',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: FoodCategory.values.map((FoodCategory category) {
                      return DropdownMenuItem<FoodCategory>(
                        value: category,
                        child: Text(category.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (value) {
                      selectedCategory = value; // Lưu giá trị đã chọn
                    },
                  ),
                  SizedBox(height: 16),
                  // Dropdown cho đơn vị
                  DropdownButtonFormField<FoodUnit>(
                    decoration: InputDecoration(
                      labelText: 'Đơn vị',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: FoodUnit.values.map((FoodUnit unit) {
                      return DropdownMenuItem<FoodUnit>(
                        value: unit,
                        child: Text(unit.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (value) {
                      selectedUnit = value; // Lưu giá trị đã chọn
                    },
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Hủy',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          if (nameController.text.isEmpty ||
                              selectedCategory == null ||
                              selectedUnit == null ||
                              _imageFile == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Vui lòng điền đầy đủ thông tin và chọn ảnh')),
                            );
                            return;
                          }

                          try {
                            final result = await _apiService.createFood(
                              name: nameController.text,
                              category: selectedCategory.toString().split('.').last,
                              unit: selectedUnit.toString().split('.').last,
                              file: _imageFile!,
                            );

                            // Kiểm tra xem result có phải là một Map không
                            if (result != null && result is Map) {
                              _addItem({
                                'name': nameController.text,
                                'unit': selectedUnit.toString().split('.').last,
                                'category': selectedCategory.toString().split('.').last,
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Có lỗi xảy ra khi thêm thực phẩm')),
                              );
                            }
                          } catch (e) {
                            print('Error creating food: $e'); // In ra lỗi để kiểm tra
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Lỗi: $e')),
                            );
                          }
                        },
                        child: Text('Tạo'),
                      ),
                    ],
                  ),
                ],
              ),
              )
            );
          }
        ),
      ),
    );
  }
}

enum FoodCategory {
  Vegetable,
  Meat,
  Tuber,
  Fruit,
  Dairy,
  Spices,
  Other,
}

enum FoodUnit {
  Gram,
  Kilogram,
  Teaspoon,
  Root,
  Fruit,
  Bunch,
  Slice,
  Leaf,
  Package,
  Other,
}