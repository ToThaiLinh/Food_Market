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
  Map<DateTime, Map<String, List<String>>> mealsByDate = {};

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('vi', null);

    // Initialize with example data (nếu cần)
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
          _buildDateBar(context),
          Expanded(
            child: _buildMealListForDay(),
          ),
        ],
      ),
    );
  }

  Widget _buildDateBar(BuildContext context) {
    return Container(
      color: Color(0xFFBF4E19),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Ngày ${DateFormat('dd MMMM yyyy', 'vi').format(selectedDate)}',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          IconButton(
            icon: Icon(Icons.calendar_today, color: Colors.white),
            onPressed: () {
              _showCalendarDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMealListForDay() {
    // Nếu chưa có dữ liệu cho ngày được chọn, khởi tạo dữ liệu mặc định
    mealsByDate[selectedDate] ??= {
      'Bữa sáng': [],
      'Bữa trưa': [],
      'Bữa tối': [],
    };

    final meals = mealsByDate[selectedDate]!;
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: meals.keys.length,
      itemBuilder: (context, index) {
        final mealType = meals.keys.elementAt(index);
        final dishes = meals[mealType]!;

        return Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            title: Text(
              mealType,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            children: [
              ...dishes.map(
                    (dish) => ListTile(
                  title: Text(dish),
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
              // Nút thêm món ăn
              ListTile(
                leading: Icon(Icons.add, color: Colors.green),
                title: Text('Thêm món ăn', style: TextStyle(color: Colors.green)),
                onTap: () {
                  _showAddDishDialog(mealType);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCalendarDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddDishDialog(String mealType) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Thêm món ăn cho $mealType'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Nhập tên món ăn'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  mealsByDate[selectedDate] ??= {'Bữa sáng': [], 'Bữa trưa': [], 'Bữa tối': []};
                  mealsByDate[selectedDate]![mealType]!.add(controller.text);
                });
                Navigator.pop(context);
              },
              child: Text('Thêm'),
            ),
          ],
        );
      },
    );
  }
}
