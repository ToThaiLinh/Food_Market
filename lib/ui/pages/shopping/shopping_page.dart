import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../../services/shopping_api_service.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  List<Map<String, dynamic>> shoppingItems = [];
  final ShoppingApiService _apiService = ShoppingApiService();
  DateTime selectedDate = DateTime.now();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredItems = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadShoppingItems(); // Hiển thị tất cả item ban đầu
  }

  Future<void> _loadShoppingItems() async {
    try {
      final items = await _apiService.getAllFoods();
      if (items != null) {
        setState(() {
          shoppingItems = items;
        });
      }
    } catch (e) {
      print('Error loading shopping items: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi khi tải danh sách thực phẩm')),
      );
    }
    // setState(() {
    //   shoppingItems = []; // Khởi tạo shoppingItems là rỗng
    // });
  }

  void _addItem(Map<String, dynamic> item) async {
    try {
      // Gọi API để thêm hoặc cập nhật thực phẩm
      final result = await _apiService.updateFood(
        name: item['name']!,
        category: item['category'] ?? 'Uncategorized',
        unit: item['unit'] ?? '',
        id: item['id'] ?? '',
        // ID có thể để trống nếu là thực phẩm mới
        quantity: item['quantity'] ?? 0,
      );

      if (result != null) {
        setState(() {
          shoppingItems.add({
            'name': item['name']!,
            'quantity': item['quantity'] ?? 0,
            'unit': item['unit'] ?? '',
            'category': item['category'] ?? 'Uncategorized',
            'id': result // Sử dụng ID trả về từ API
          });
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thêm thực phẩm thành công!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Có lỗi xảy ra khi thêm thực phẩm')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }

  void _removeItem(int index) async {
    // Kiểm tra index có hợp lệ không
    if (index < 0 || index >= shoppingItems.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không tìm thấy thực phẩm để xóa')),
      );
      return;
    }

    final item = shoppingItems[index];

    // Kiểm tra item có tồn tại không
    if (item == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Thực phẩm không tồn tại')),
      );
      return;
    }

    // Lấy ID của item và kiểm tra null
    final itemId = item['id'];
    if (itemId == null || itemId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể xóa thực phẩm vì thiếu ID')),
      );
      return;
    }

    try {
      // Gọi API xóa thực phẩm
      final success = await _apiService.deleteFood(id: itemId);

      if (success == true) {
        // Kiểm tra rõ ràng với true
        setState(() {
          shoppingItems.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xóa thực phẩm thành công!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể xóa thực phẩm. Vui lòng thử lại')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi xóa thực phẩm: $e')),
      );
    }
  }

  // Helper method to extract quantity from the quantity string
  int _extractQuantity(String quantityString) {
    // Remove non-numeric characters and keep only the number
    return int.parse(quantityString.replaceAll(RegExp(r'[^\d.]'), ''));
  }

  // Helper method to extract unit from the quantity string
  String _extractUnit(String quantityString) {
    // Extract the non-numeric part
    return quantityString.replaceAll(RegExp(r'[\d.]'), '').trim();
  }

  void _startSearch() {
    setState(() {
      isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      isSearching = false;
      // filteredItems = availableItems;
      _searchController.clear();
    });
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
        return Dismissible(
          key: Key(item['id']?.toString() ?? DateTime.now().toString()),
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
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Color(0xFFBF4E19).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.shopping_basket,
                  color: Color(0xFFBF4E19),
                ),
              ),
              title: Text(
                item['name']?.toString() ?? 'Không có tên',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Số lượng: ${item['quantity']} ${item['unit']}\nDanh mục: ${item['category']}',
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
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeItem(index),
                  ),
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
    // Debug: In ra toàn bộ item để kiểm tra
    print('Item received: $item');
    print('Item ID type: ${item['_id'].runtimeType}');
    print('Item ID value: ${item['_id']}');

    final nameController = TextEditingController(text: item['name'] ?? '');
    final categoryController = TextEditingController(text: item['category'] ?? '');
    final unitController = TextEditingController(text: item['unit'] ?? '');
    final quantityController = TextEditingController(text: item['quantity']?.toString() ?? '0');

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Chỉnh sửa thực phẩm'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Tên thực phẩm'),
              ),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(labelText: 'Danh mục'),
              ),
              TextField(
                controller: unitController,
                decoration: InputDecoration(labelText: 'Đơn vị'),
              ),
              TextField(
                controller: quantityController,
                decoration: InputDecoration(labelText: 'Số lượng'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                // Kiểm tra và debug ID
                print('Checking ID before update...');
                print('ID value: ${item['_id']}');
                print('ID type: ${item['_id'].runtimeType}');

                // Kiểm tra ID một cách chi tiết hơn
                if (item['_id'] == null || item['_id'].toString().trim().isEmpty) {
                  print('ID validation failed: ${item['_id']}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('ID thực phẩm không hợp lệ')),
                  );
                  return;
                }

                try {
                  // Chuyển đổi ID sang string an toàn
                  final foodId = item['_id'].toString();
                  print('Processed ID for API call: $foodId');

                  final result = await _apiService.updateFood(
                    id: foodId,
                    name: nameController.text.trim(),
                    category: categoryController.text.trim(),
                    unit: unitController.text.trim(),
                    quantity: int.tryParse(quantityController.text) ?? 0,
                  );

                  if (result != null) {
                    setState(() {
                      final index = shoppingItems.indexWhere((i) => i['_id'] == item['_id']);
                      if (index != -1) {
                        shoppingItems[index] = {
                          '_id': item['_id'],
                          'name': nameController.text.trim(),
                          'category': categoryController.text.trim(),
                          'unit': unitController.text.trim(),
                          'quantity': int.tryParse(quantityController.text) ?? 0,
                        };
                      }
                    });

                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Cập nhật thực phẩm thành công')),
                    );
                  } else {
                    print('Update returned null result');
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
        );
      },
    );
  }

    void _showUpdateFoodDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
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
                  Expanded(
                    child: FutureBuilder<List<Map<String, dynamic>>?>(
                      future: _apiService.getAllFoods(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                                Icon(Icons.error_outline,
                                    size: 48, color: Colors.red),
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
                                Icon(Icons.no_food,
                                    size: 48, color: Colors.grey),
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
                                title: Text(
                                  food['name']?.toString() ?? 'Không có tên',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  'Số lượng: ${food['quantity']?.toString() ?? '0'} ${food['unit']?.toString() ?? ''}\n'
                                  'Danh mục: ${food['category']?.toString() ?? 'Chưa phân loại'}',
                                ),
                                onTap: () async {
                                  try {
                                    // Kiểm tra và xử lý null safety cho các trường
                                    final String? id = food['id']?.toString();
                                    final String name =
                                        food['name']?.toString() ??
                                            'Không có tên';
                                    final String category =
                                        food['category']?.toString() ??
                                            'Chưa phân loại';
                                    final String unit =
                                        food['unit']?.toString() ?? '';
                                    final int quantity = int.tryParse(
                                            food['quantity']?.toString() ??
                                                '0') ??
                                        0;

                                    final result = await _apiService.updateFood(
                                      id: id ?? '',
                                      // Đảm bảo id không null
                                      name: name,
                                      category: category,
                                      unit: unit,
                                      quantity: quantity,
                                    );

                                    if (result != null) {
                                      // Cập nhật item với dữ liệu đã được xử lý null safety
                                      _addItem({
                                        'id': result,
                                        'name': name,
                                        'category': category,
                                        'unit': unit,
                                        'quantity': quantity,
                                      });
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Thêm thực phẩm thành công')),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Có lỗi xảy ra khi thêm thực phẩm')),
                                      );
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Lỗi: $e')),
                                    );
                                  }
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
    final categoryController = TextEditingController();
    final unitController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: EdgeInsets.all(16),
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
              TextField(
                controller: categoryController,
                decoration: InputDecoration(
                  labelText: 'Danh mục',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: unitController,
                decoration: InputDecoration(
                  labelText: 'Đơn vị',
                  prefixIcon: Icon(Icons.straighten),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
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
                      // Tạo thực phẩm mới
                      final result = await _apiService.createFood(
                        name: nameController.text,
                        category: categoryController.text,
                        unit: unitController.text,
                      );

                      if (result != null) {
                        // Gọi _addItem để thêm thực phẩm vào shoppingItems
                        _addItem({
                          'name': nameController.text,
                          'quantity': 1, // Hoặc giá trị mặc định khác
                          'unit': unitController.text,
                          'category': categoryController.text,
                          'id': result, // Sử dụng ID trả về từ API
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Tạo thực phẩm thành công!')),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Có lỗi xảy ra khi tạo thực phẩm')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF16A34A),
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Tạo'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
