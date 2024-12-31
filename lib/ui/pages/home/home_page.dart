import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/meal_plan/meal_plan_bloc.dart';
import '../../../gen/assets.gen.dart';
import '../../../services/meal_plan_service.dart';
import '../../../services/recipe_api_service.dart';
import '../family/family_page.dart';
import '../me/me_page.dart';
import '../recipe/create_recipe_page.dart';
import '../schedule/schedule_page.dart';
import '../shopping/shopping_page.dart';
import '../fridge/fridge_page.dart';
import '../recipe/meal_recipe_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> _recipes = [];
  List<Map<String, dynamic>> _shoppingItems = [];
  final RecipeApiService _apiService = RecipeApiService();

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
    _loadShoppingItems();
  }

  Future<void> _fetchRecipes() async {
    try {
      final List<Map<String, dynamic>>? recipes = await _apiService.getAllRecipes();
      print('Fetched Recipes from API: $recipes'); // Kiểm tra dữ liệu từ API
      if (mounted) {
        setState(() {
          _recipes = recipes ?? [];
        });
      }
    } catch (e) {
      print('Error fetching recipes: $e');
    }
  }

  void _loadShoppingItems() {
    setState(() {
      _shoppingItems = ShoppingPage.getShoppingItems(context); // Updated to call ShoppingPage directly
    });
  }

  // Replace the existing _updateShoppingItems method with this:
  void _updateShoppingItems() {
    setState(() {
      _shoppingItems = ShoppingPage.getShoppingItems(context);
    });
  }

  void _navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeContent(onNavigateToTab: (index) => _navigateToTab(index), recipes: _recipes),
      const ShoppingPage(),
      const FridgePage(),
      SchedulePage(),
      FamilyPage(),
    ];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Text(
              'Foody Mart',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              // Show notifications
            },
          ),
          IconButton(
            icon: CircleAvatar(
              radius: 14,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 20, color: Color(0xFF16A34A)),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MePage()),
              );
            },
          ),
        ],
        backgroundColor: Color(0xFF16A34A),
        elevation: 0,
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Mua sắm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.kitchen_outlined),
            activeIcon: Icon(Icons.kitchen),
            label: 'Tủ lạnh',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Lịch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.family_restroom_outlined),
            activeIcon: Icon(Icons.family_restroom),
            label: 'Gia đình',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Color(0xFF16A34A),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: _navigateToTab,
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  final Function(int) onNavigateToTab;
  final List<Map<String, dynamic>> recipes;

  const HomeContent({super.key, required this.onNavigateToTab, required this.recipes});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<Map<String, dynamic>> get recipes {
    print('Current recipes: $widget.recipes'); // Kiểm tra dữ liệu
    return widget.recipes;
  }
  List<Map<String, dynamic>> _shoppingItems = [];
  List<Map<String, dynamic>> _expiringFoods = [];

  @override
  void initState() {
    super.initState();
    _loadShoppingItems();
    _loadExpiringFoods();
  }

  void _loadExpiringFoods() {
    setState(() {
      _expiringFoods = [
        {'name': 'Thịt bò', 'daysLeft': 2},
        {'name': 'Sữa tươi', 'daysLeft': 1},
        {'name': 'Rau xà lách', 'daysLeft': 3},
        {'name': 'Cá hồi', 'daysLeft': 5},
        {'name': 'Trứng gà', 'daysLeft': 4},
      ];
    });
  }

  void _loadShoppingItems() {
    setState(() {
      _shoppingItems = ShoppingPage.getShoppingItems(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeHeader(),
          _buildQuickActions(context),
          _buildExpiringFoods(),
          _buildMealRecipes(context),
          _buildShoppingList(),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF16A34A),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Xin chào, Gia đình!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Hôm nay bạn muốn nấu gì?',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Truy cập nhanh',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildActionCard(
                title: 'Thêm đồ\nmua sắm',
                icon: Icons.add_shopping_cart,
                color: Color(0xFFF59E0B),
                onTap: () => widget.onNavigateToTab(1),
              ),
              _buildActionCard(
                title: 'Kiểm tra\ntủ lạnh',
                icon: Icons.kitchen,
                color: Color(0xFF3B82F6),
                onTap: () => widget.onNavigateToTab(2),
              ),
              _buildActionCard(
                title: 'Lên thực đơn',
                icon: Icons.restaurant_menu,
                color: Color(0xFFEF4444),
                onTap: () => widget.onNavigateToTab(3),
              ),
              _buildActionCard(
                title: 'Chia sẻ\ngia đình',
                icon: Icons.group_add,
                color: Color(0xFF8B5CF6),
                onTap: () => widget.onNavigateToTab(4),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpiringFoods() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sắp hết hạn',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Container(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _expiringFoods.length,
              itemBuilder: (context, index) {
                final food = _expiringFoods[index];
                return Container(
                  width: 200,
                  margin: EdgeInsets.only(right: 16),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food['name'] ?? 'Không xác định',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Còn ${food['daysLeft']} ngày',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealRecipes(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Gợi ý hôm nay',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateRecipePage(),
                    ),
                  ).then((_) {
                    // Refresh recipe list after creation
                    if (mounted) {
                      setState(() {
                        widget.onNavigateToTab(0);
                      });
                    }
                  });
                },
                child: Text('Thêm công thức'),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            height: 200,
            child: recipes.isEmpty
                ? Center(
              child: Text('Chưa có công thức nào'),
            )
                : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MealRecipePage(
                          mealName: recipe['name'] ?? 'Không có tên',
                          recipeDetails: recipe['htmlContent'] ?? 'Không có mô tả',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 160,
                    margin: EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(recipe['image'] ?? 'assets/default_image.png'), // Cung cấp hình ảnh mặc định
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                      padding: EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe['name'] ?? 'Không có tên',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            recipe['htmlContent'] ?? 'Không có mô tả',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
    );
  }

  Widget _buildShoppingList() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Danh sách mua sắm',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => widget.onNavigateToTab(1),
                child: Text('Xem tất cả'),
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _shoppingItems.length > 3 ? 3 : _shoppingItems.length,
            itemBuilder: (context, index) {
              final item = _shoppingItems[index];
              return Card(
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
                    'Số lượng: ${item['quantity']?.toString() ?? '0'} ${item['unit']}\n'
                        'Danh mục: ${item['category']}',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      // Navigate to shopping page for editing
                      widget.onNavigateToTab(1);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _navigateToShoppingPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShoppingPage(),
      ),
    ).then((_) {
      _loadShoppingItems(); // Reload shopping items when returning
    });
  }
}