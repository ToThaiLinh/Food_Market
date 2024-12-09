import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food/ui/pages/home/section_detail_page.dart';

import '../../../gen/assets.gen.dart';
import '../me/me_page.dart';
import '../schedule/schedule_page.dart';
import '../shopping/shopping_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeContent(),
    ShoppingPage(),
    SchedulePage(),
    MePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Foody Mart',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Notification action
            },
          ),
        ],
        backgroundColor: const Color(0xFFBF4E19),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(Assets.icons.icHome),
            label: 'Home',
            backgroundColor: const Color(0xFFFEC543),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(Assets.icons.icShoppingCart),
            label: 'Shopping',
            backgroundColor: const Color(0xFFFEC543),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(Assets.icons.icSchedule),
            label: 'Schedule',
            backgroundColor: const Color(0xFFFEC543),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(Assets.icons.icUser),
            label: 'Me',
            backgroundColor: const Color(0xFFFEC543),
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final List<String> recentFoods = [
    'Trứng chiên nước mắm',
    'Cá kho tộ',
    'Rau muống xào tỏi',
    'Canh chua cá lóc',
    'Thịt kho tàu',
    'Gà xào sả ớt',
  ];

  final List<String> todayFood = [
    'Cơm tấm sườn bì chả',
    'Bún bò Huế',
    'Phở gà',
    'Bánh mì thịt',
    'Hủ tiếu nam vang',
    'Cơm gà xối mỡ',
  ];

  final List<String> recipes = [
    'Lòng xào giá mướp',
    'Cá kho tộ',
    'Thịt kho tàu',
    'Canh khổ qua nhồi thịt',
    'Gà kho gừng',
    'Rau muống xào tỏi',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Section(
            title: 'Thực phẩm gần đây',
            items: recentFoods,
          ),
          Section(
            title: 'Hôm nay ăn gì?',
            items: todayFood,
          ),
          Section(
            title: 'Công thức nấu ăn',
            items: recipes,
          ),
          ShoppingSection(),
        ],
      ),
    );
  }
}

class Section extends StatelessWidget {
  final String title;
  final List<String> items;

  const Section({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFFFF3700),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SectionDetailPage(
                        title: title,
                        items: items,
                      ),
                    ),
                  );
                },
                child: const Text(
                  '>> Xem tất cả',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
          Container(
            height: 170,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(Assets.images.imgMonan1.path),
                              ),
                            ),
                            height: 100,
                            width: 100,
                          ),
                          Container(
                            width: 100,
                            child: Text(
                              items[index],
                              style: const TextStyle(fontSize: 14),
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
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
}

class ShoppingSection extends StatefulWidget {
  @override
  _ShoppingSectionState createState() => _ShoppingSectionState();
}

class _ShoppingSectionState extends State<ShoppingSection> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFBF4E19),
            ),
            labelStyle: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelPadding: EdgeInsets.zero,
            dividerColor: Colors.transparent,
            indicatorWeight: 0,
            tabs: const [
              Tab(text: 'Thực phẩm cần mua'),
              Tab(text: 'Thực phẩm trong tủ lạnh'),
            ],
          ),
        ),
        SizedBox(
          height: 200, // Điều chỉnh chiều cao phù hợp
          child: TabBarView(
            controller: _tabController,
            children: [
              // Tab 1: Cần mua ngay
              ListView(
                children: [
                  _buildShoppingItem('Cải thảo/ Cải bao', '2 bắp'),
                  _buildShoppingItem('Thịt heo', '500g'),
                  _buildShoppingItem('Trứng gà', '10 quả'),
                ],
              ),
              // Tab 2: Đã mua
              ListView(
                children: [
                  _buildShoppingItem('Cà rốt', '300g', isDone: true),
                  _buildShoppingItem('Khoai tây', '400g', isDone: true),
                  _buildShoppingItem('Hành lá', '100g', isDone: true),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShoppingItem(String name, String quantity, {bool isDone = false}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: Image.network('https://via.placeholder.com/50'),
        title: Text(
          name,
          style: TextStyle(
            decoration: isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text('Số lượng: $quantity'),
        trailing: isDone
            ? const Icon(Icons.check_circle, color: Colors.green)
            : IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
            // Xử lý logic khi nhấn vào nút mua
          },
        ),
      ),
    );
  }
}