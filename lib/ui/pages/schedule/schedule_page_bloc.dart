import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../../bloc/meal_plan/meal_plan_bloc.dart';
import '../../../bloc/meal_plan/meal_plan_event.dart';
import '../../../bloc/meal_plan/meal_plan_state.dart';
import '../../../services/meal_plan_service.dart';


class SchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MealPlanBloc(
        MealPlanService(),
      ),
      child: ScheduleView(),
    );
  }
}

class ScheduleView extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<ScheduleView> {
  DateTime selectedDate = DateTime.now();
  DateTime focusedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('vi', null);
    // Load initial data
    _loadMealPlans();
  }

  void _loadMealPlans() {
    context.read<MealPlanBloc>().add(
      GetMealPlansByDate(
        date: DateFormat('MM/dd/yyyy').format(selectedDate),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<MealPlanBloc, MealPlanState>(
        listener: (context, state) {
          if (state is MealPlanCreated ||
              state is MealPlanDeleted ||
              state is MealPlanUpdated) {
            // Reload meal plans after changes
            _loadMealPlans();
          }
        },
        child: Column(
          children: [
            _buildHeader(),
            _buildCalendar(),
            Expanded(
              child: _buildMealList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDishDialog('Bữa sáng'),
        backgroundColor: Color(0xFFBF4E19),
        child: Icon(Icons.add, color: Colors.white),
        tooltip: 'Thêm món ăn',
      ),
    );
  }

  Widget _buildMealList() {
    return BlocBuilder<MealPlanBloc, MealPlanState>(
      builder: (context, state) {
        if (state is MealPlanLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (state is MealPlanError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Có lỗi xảy ra: ${state.message}'),
                ElevatedButton(
                  onPressed: _loadMealPlans,
                  child: Text('Thử lại'),
                ),
              ],
            ),
          );
        }

        if (state is MealPlansLoaded) {
          final mealTypes = ['Bữa sáng', 'Bữa trưa', 'Bữa tối'];
          final mealIcons = {
            'Bữa sáng': Icons.wb_sunny,
            'Bữa trưa': Icons.wb_sunny_outlined,
            'Bữa tối': Icons.nights_stay,
          };

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: mealTypes.length,
            itemBuilder: (context, index) {
              final mealType = mealTypes[index];
              final dishes = state.mealPlans
                  .where((plan) => plan.name == mealType)
                  .toList();

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
                            (plan) => ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          leading: Icon(
                            Icons.restaurant_menu,
                            color: Colors.grey[600],
                          ),
                          title: Text(
                            plan.food!.name,
                            style: TextStyle(fontSize: 16),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              context.read<MealPlanBloc>().add(
                                DeleteMealPlan(planId: plan.id),
                              );
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

        return SizedBox.shrink();
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
                        context.read<MealPlanBloc>().add(
                          CreateMealPlan(
                            foodName: controller.text,
                            timestamp: DateFormat('yyyy-MM-dd')
                                .format(selectedDate),
                            name: mealType,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFBF4E19),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
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

  // Calendar widget remains mostly the same, just update onDaySelected
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
            leftChevronIcon: Icon(
              Icons.chevron_left,
              color: Color(0xFFBF4E19),
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right,
              color: Color(0xFFBF4E19),
            ),
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
            context.read<MealPlanBloc>().add(
              GetMealPlansByDate(
                date: DateFormat('yyyy-MM-dd').format(selectedDay),
              ),
            );
          },
        ),
      ),
    );
  }

  // Header widget remains the same
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
}
