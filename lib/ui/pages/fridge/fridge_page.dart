import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../services/fridge_api_service.dart';
import '../../../services/shopping_api_service.dart';

class FridgePage extends StatefulWidget {
  @override
  _FridgePageState createState() => _FridgePageState();
}

class _FridgePageState extends State<FridgePage> {
  late ShoppingApiService _shoppingApiService;
  late FridgeApiService _fridgeApiService;
  List<dynamic> _availableFridgeFoods = [];

  @override
  void initState() {
    super.initState();
    _shoppingApiService = ShoppingApiService();
    _fridgeApiService = FridgeApiService();
    _fetchAvailableFridgeFoods();
  }

  Future<void> _fetchAvailableFridgeFoods() async {
    final foods = await _shoppingApiService.getAllFoods();
    if (foods != null) {
      Set<String> seenNames = {};
      List<Map<String, dynamic>> uniqueList = foods.where((map) {
        final name = map["name"];
        if (seenNames.contains(name)) {
          return false;
        } else {
          seenNames.add(name);
          return true;
        }
      }).toList();

      setState(() {
        _availableFridgeFoods = uniqueList;
      });
      print("Available Fridge Foods: ${_availableFridgeFoods.length}");
    }
  }

  Future<void> _addFoodToFridge(Map<String, dynamic> food) async {
    // Prompt user for quantity and use-within period
    final result = await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (context) => AddFoodToFridgeDialog(food: food));

    if (result != null) {
      try {
        final fridgeId = await _fridgeApiService.createFood(
          foodName: food['name'],
          useWithin: result['useWithin'],
          quantity: result['quantity'],
          foodId: food['_id'],
        );

        if (fridgeId != null) {
          // Show success message or update UI
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${food['name']} added to fridge')),
          );
          _fetchAvailableFridgeFoods();
          setState(() {});
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add food: $e')),
        );
      }
    }
  }

  Future<void> _updateFoodInFridge(Map<String, dynamic> food) async {
    // // Tìm thực phẩm hiện có trong tủ lạnh
    // final existingFood = _availableFridgeFoods.firstWhere(
    //       (fridgeFood) => fridgeFood['name'] == food['name'],
    //   orElse: () => null,
    // );
    //
    // if (existingFood == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Thực phẩm không tồn tại trong tủ lạnh')),
    //   );
    //   return;
    // }

    // Hiển thị dialog để người dùng nhập thông tin cập nhật
    final result = await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (context) => UpdateFoodInFridgeDialog(food: food));

    if (result != null) {
      try {
        final updatedId = await _fridgeApiService.updateFood(
          newFoodName: result['newFoodName'] ?? food['name'], // Sử dụng tên thực phẩm mới nếu có
          newUseWithin: 123, // Sử dụng giá trị hiện tại nếu không có
          newQuantity: result['quantity'] ?? food['quantity'], // Sử dụng giá trị hiện tại nếu không có
          newNote: result['note'] ?? '', // Sử dụng chuỗi rỗng nếu không có
          itemId: food['_id'],
        );

        if (updatedId != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${food['name']} đã được cập nhật trong tủ lạnh')),
          );
          _fetchAvailableFridgeFoods(); // Cập nhật danh sách thực phẩm
          setState(() {}); // Cập nhật giao diện
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật thực phẩm thất bại: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildSearchBar(),
        Expanded(
          child: _buildFoodGrid(),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Color(0xFFBF4E19),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Quản lý tủ lạnh',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Icon(Icons.add_circle, color: Colors.white),
            onPressed: () {_fetchAvailableFridgeFoods();
      showModalBottomSheet(
      context: context,
      builder: (context) => FoodSelectionBottomSheet(
        foods: _availableFridgeFoods,
        onFoodSelected: _addFoodToFridge,
      ),
    );
  },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Tìm kiếm thực phẩm...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        onChanged: (value) {
          // Implement search functionality
        },
      ),
    );
  }

  Widget _buildFoodGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: _availableFridgeFoods.length,
      itemBuilder: (context, index) {
        final food = _availableFridgeFoods[index];
        return _buildFoodCard(food);
      },
    );
  }

  Widget _buildFoodCard(Map<String, dynamic> food) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _updateFoodInFridge(food),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                'https://via.placeholder.com/150',
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food['name'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Số lượng: ${food['quantity']}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  // Add expiry date if available
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddFoodToFridgeDialog extends StatefulWidget {
  final Map<String, dynamic> food;

  const AddFoodToFridgeDialog({Key? key, required this.food}) : super(key: key);

  @override
  _AddFoodToFridgeDialogState createState() => _AddFoodToFridgeDialogState();
}

class _AddFoodToFridgeDialogState extends State<AddFoodToFridgeDialog> {
  late TextEditingController _quantityController;
  late TextEditingController _useWithinController;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
    _useWithinController = TextEditingController();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _useWithinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Thêm ${widget.food['name']} vào tủ lạnh'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Số lượng',
              hintText: 'Nhập số lượng',
            ),
          ),
          TextField(
            controller: _useWithinController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Sử dụng trong (ngày)',
              hintText: 'Nhập số ngày',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () {
            final quantity = int.tryParse(_quantityController.text);
            final useWithin = int.tryParse(_useWithinController.text);

            if (quantity != null && useWithin != null) {
              Navigator.of(context).pop({
                'quantity': quantity,
                'useWithin': useWithin,
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
              );
            }
          },
          child: Text('Thêm'),
        ),
      ],
    );
  }
}

class UpdateFoodInFridgeDialog extends StatefulWidget {
  final Map<String, dynamic> food;

  const UpdateFoodInFridgeDialog({Key? key, required this.food}) : super(key: key);

  @override
  _UpdateFoodInFridgeDialogState createState() => _UpdateFoodInFridgeDialogState();
}

class _UpdateFoodInFridgeDialogState extends State<UpdateFoodInFridgeDialog> {
  late TextEditingController _quantityController;
  late TextEditingController _useWithinController;
  late TextEditingController _noteController;
  late TextEditingController _foodNameController;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(text: widget.food['quantity']?.toString());
    _useWithinController = TextEditingController(text: widget.food['useWithin']?.toString());
    _noteController = TextEditingController(text: widget.food['note'] ?? '');
    _foodNameController = TextEditingController(text: widget.food['name']); // Initialize with current name
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _useWithinController.dispose();
    _noteController.dispose();
    _foodNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cập nhật ${widget.food['name']}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _foodNameController,
            decoration: InputDecoration(
              labelText: 'Tên thực phẩm',
              hintText: 'Nhập tên thực phẩm mới (tuỳ chọn)',
            ),
          ),
          TextField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Số lượng',
              hintText: 'Nhập số lượng mới (tuỳ chọn)',
            ),
          ),
          TextField(
            controller: _useWithinController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Sử dụng trong (ngày)',
              hintText: 'Nhập số ngày mới (tuỳ chọn)',
            ),
          ),
          TextField(
            controller: _noteController,
            decoration: InputDecoration(
              labelText: 'Ghi chú',
              hintText: 'Nhập ghi chú (tuỳ chọn)',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () {
            final quantity = int.tryParse(_quantityController.text);
            final useWithin = int.tryParse(_useWithinController.text);
            final note = _noteController.text;
            final newFoodName = _foodNameController.text;

            Navigator.of(context).pop({
              'quantity': quantity,
              'useWithin': useWithin,
              'note': note,
              'newFoodName': newFoodName,
            });
          },
          child: Text('Cập nhật'),
        ),
      ],
    );
  }
}

class FoodSelectionBottomSheet extends StatelessWidget {
  final List<dynamic> foods;
  final Function(Map<String, dynamic>) onFoodSelected;

  const FoodSelectionBottomSheet({
    Key? key,
    required this.foods,
    required this.onFoodSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Chọn thực phẩm',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: foods.length,
              itemBuilder: (context, index) {
                final food = foods[index];
                return ListTile(
                  title: Text(food['name'] ?? 'Unnamed Food'),
                  subtitle: Text('Loại: ${food['category'] ?? 'Unknown'}'),
                  onTap: () {
                    Navigator.of(context).pop();
                    onFoodSelected(food);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}