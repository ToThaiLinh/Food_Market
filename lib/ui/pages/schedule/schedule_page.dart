import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime selectedDate = DateTime.now();
  DateTime focusedDate = DateTime.now();
  Map<DateTime, Map<String, List<String>>> mealsByDate = {};

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('vi', null);
    mealsByDate[DateTime.now()] = {
      'Bữa sáng': ['Món 1'],
      'Bữa trưa': ['Món 2'],
      'Bữa tối': ['Món 3'],
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          _buildCalendar(),
          Expanded(
            child: _buildMealList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDishDialog('Bữa sáng'),
        backgroundColor: Color(0xFFBF4E19),
        child: Icon(Icons.add, color: Colors.white),
        tooltip: 'Thêm món ăn',
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFBF4E19),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lịch ăn uống',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            DateFormat('EEEE, dd MMMM yyyy', 'vi').format(selectedDate),
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Card(
      margin: EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: TableCalendar(
          locale: 'vi',
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: focusedDate,
          selectedDayPredicate: (day) => isSameDay(selectedDate, day),
          calendarFormat: CalendarFormat.week,
          startingDayOfWeek: StartingDayOfWeek.monday,
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            leftChevronIcon: Icon(Icons.chevron_left, color: Color(0xFFBF4E19)),
            rightChevronIcon: Icon(Icons.chevron_right, color: Color(0xFFBF4E19)),
            titleTextStyle: TextStyle(
              color: Color(0xFFBF4E19),
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          calendarStyle: CalendarStyle(
            isTodayHighlighted: true,
            selectedDecoration: BoxDecoration(
              color: Color(0xFFBF4E19),
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: Color(0xFFBF4E19).withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            weekendTextStyle: TextStyle(color: Colors.red),
            selectedTextStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              selectedDate = selectedDay;
              focusedDate = focusedDay;
            });
          },
        ),
      ),
    );
  }

  Widget _buildMealList() {
    mealsByDate[selectedDate] ??= {
      'Bữa sáng': [],
      'Bữa trưa': [],
      'Bữa tối': [],
    };

    final meals = mealsByDate[selectedDate]!;

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: meals.keys.length,
      itemBuilder: (context, index) {
        final mealType = meals.keys.elementAt(index);
        final dishes = meals[mealType]!;
        final mealIcons = {
          'Bữa sáng': Icons.wb_sunny,
          'Bữa trưa': Icons.wb_sunny_outlined,
          'Bữa tối': Icons.nights_stay,
        };

        return Card(
          elevation: 4,
          margin: EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
            ),
            child: ExpansionTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFFBF4E19).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  mealIcons[mealType] ?? Icons.restaurant,
                  color: Color(0xFFBF4E19),
                ),
              ),
              title: Text(
                mealType,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFBF4E19),
                ),
              ),
              children: [
                if (dishes.isEmpty)
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Chưa có món ăn nào',
                      style: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ...dishes.map(
                      (dish) => ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    leading: Icon(
                      Icons.restaurant_menu,
                      color: Colors.grey[600],
                    ),
                    title: Text(
                      dish,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          dishes.remove(dish);
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextButton.icon(
                    icon: Icon(Icons.add, color: Color(0xFF16A34A)),
                    label: Text(
                      'Thêm món ăn',
                      style: TextStyle(
                        color: Color(0xFF16A34A),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => _showAddDishDialog(mealType),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddDishDialog(String mealType) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.restaurant_menu, color: Color(0xFFBF4E19)),
                  SizedBox(width: 8),
                  Text(
                    'Thêm món ăn cho $mealType',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Tên món ăn',
                  hintText: 'Nhập tên món ăn',
                  prefixIcon: Icon(Icons.restaurant),
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
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        setState(() {
                          mealsByDate[selectedDate]![mealType]!.add(controller.text);
                        });
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFBF4E19),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Thêm'),
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