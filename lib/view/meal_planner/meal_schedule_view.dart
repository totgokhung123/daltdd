import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:fitness/scantest.dart';
// import 'package:fitness/AddFoodPage.dart';
import 'package:fitness/te.dart';
import 'package:fitness/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'package:collection/collection.dart';
import '../../common/colo_extension.dart';
import '../../common_widget/meal_food_schedule_row.dart';
import '../../common_widget/nutritions_row.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class MealScheduleView extends StatefulWidget {
  const MealScheduleView({super.key});

  @override
  State<MealScheduleView> createState() => _MealScheduleViewState();
}

class _MealScheduleViewState extends State<MealScheduleView> {
  CalendarAgendaController _calendarAgendaControllerAppBar = CalendarAgendaController();
  var userid = 1;
  DateTime selectedDate = DateTime.now();
  List<dynamic> mealSchedule = [];
  Map<String, List<dynamic>> groupedMeals = {};
  late DateTime _selectedDateAppBBar;
  DateTime _selectedDate = DateTime.now(); // Ngày hiện tại được chọn
  List<Map<String, dynamic>> _mealsForSelectedDate = []; // Dữ liệu món ăn của ngày được chọn
  int getMealTypeId(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return 1;
      case 'lunch':
        return 2;
      case 'light dinner':
        return 3;
      case 'dinner':
        return 4;
      default:
        return 0; // Trường hợp không xác định
    }
  }
  @override
  void initState() {
    super.initState();
    _selectedDateAppBBar = DateTime.now();
    fetchMeals();
  }

  void _updateMealsForSelectedDate(DateTime selectedDate) {
    setState(() {
      _selectedDate = selectedDate;
      print("_selectedDate: "+ _selectedDate.toString());
      // Lọc món ăn theo ngày được chọn
      _mealsForSelectedDate = mealSchedule
          .where((meal) {
        final mealDate = DateTime.tryParse(meal['Ngay'] ?? '');
        if (mealDate == null) return false;
        return mealDate.year == selectedDate.year &&
            mealDate.month == selectedDate.month &&
            mealDate.day == selectedDate.day;
      })
          .cast<Map<String, dynamic>>()
          .toList();

      // Lấy danh sách các loại bữa ăn mặc định
      final defaultMealTypes = ["Breakfast", "Lunch", "Light dinner", "Dinner"];

      // Cập nhật groupedMeals cho ngày đã chọn
      groupedMeals = groupBy(
        _mealsForSelectedDate,
            (meal) => meal['type_meal_name'] as String? ?? 'Unknown', // Nếu không có type_meal_name, gán 'Unknown'
      );
      print("groupedMeals up to date: "+ groupedMeals.toString());
      // // Đảm bảo rằng tất cả các loại bữa ăn mặc định đều có mặt trong groupedMeals
      // for (var mealType in defaultMealTypes) {
      //   groupedMeals.putIfAbsent(mealType, () => []); // Thêm loại bữa ăn trống nếu chưa có
      // }

      // Sắp xếp groupedMeals theo thứ tự mặc định
      groupedMeals = Map.fromEntries(defaultMealTypes.map((type) {
        return MapEntry(type, groupedMeals[type] ?? []);
      }));
      print("groupedMeals maping: "+ groupedMeals.toString());
    });
  }
  Future<void> fetchMeals() async {
    try {
      // Lấy danh sách các loại bữa ăn từ API
      final typeMealsData = await ApiService().fetchTypeMeal();
      // Lấy dữ liệu món ăn từ API
      final mealsDataRaw = await ApiService().fetchMealSchedule(1); // Thay 1 bằng user_id thực tế
      print("mealsDataRaw:" + mealsDataRaw.toString());
      // Chuyển đổi danh sách món ăn thành List<Map<String, dynamic>>
      final mealsData = List<Map<String, dynamic>>.from(mealsDataRaw);
      print("mealsData:" + mealsData.toString());
      // Chuyển đổi dữ liệu loại bữa ăn
      final defaultTypeMeals = List<Map<String, dynamic>>.from(typeMealsData);
      print("defaultTypeMeals:" + defaultTypeMeals.toString());
      // Gộp dữ liệu món ăn theo loại bữa ăn
      Map<String, List<Map<String, dynamic>>> fetchedGroupedMeals = groupBy(
        mealsData,
         (meal) => meal['type_meal_name'] as String, // Đảm bảo meal['type_meal_name'] là String
      );
      print("fetchedGroupedMeals:" + fetchedGroupedMeals.toString());
      // Kết hợp với danh sách mặc định các loại bữa ăn
      Map<String, List<Map<String, dynamic>>> completeGroupedMeals = {
        for (var typeMeal in defaultTypeMeals)
          typeMeal['name']: fetchedGroupedMeals[typeMeal['name']] ?? [],
      };
      print("completeGroupedMeals:" + completeGroupedMeals.toString());
      // Cập nhật trạng thái
      setState(() {
        mealSchedule = mealsData;
        groupedMeals = completeGroupedMeals;
      });

      // Lọc dữ liệu theo ngày hiện tại
      _updateMealsForSelectedDate(_selectedDate);
      print("_updateMealsForSelectedDate:" + _updateMealsForSelectedDate.toString());
    } catch (e) {
      print('Error fetching meals or type meals: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    // Gộp toàn bộ món ăn của các type_meal
    List<Map<String, dynamic>> allFoods = groupedMeals.values
        .expand((entry) => List<Map<String, dynamic>>.from(entry))
        .toList();
    // Lấy tất cả các món ăn cho ngày được chọn
    List<Map<String, dynamic>> selectedFoods = _mealsForSelectedDate.isNotEmpty
        ? _mealsForSelectedDate.expand((entry) => List<Map<String, dynamic>>.from(entry['foods'] ?? []))
        .toList()
        : [];
    double totalCalories = allFoods.fold<double>(
      0.0,
          (sum, item) => sum + (double.parse(((item['calories_per_unit'] as int).toDouble() * double.parse(item['quantity'])).toString())),
    );
    // Tính tổng dinh dưỡng
    double totalProtein = allFoods.fold<double>(
      0.0,
          (sum, item) => sum + (double.parse(item['protein'].toString())),
    );

    double totalCarbs = allFoods.fold<double>(
      0.0,
          (sum, item) => sum + (double.parse(item['carbs'].toString())),
    );

    double totalFat = allFoods.fold<double>(
      0.0,
          (sum, item) => sum + (double.parse(item['fat'].toString())),
    );
    // Dữ liệu tổng hợp
    Map<String, dynamic> nutritionSummary = {
      "calories": totalCalories,
      "protein": totalProtein,
      "carbs": totalCarbs,
      "fat": totalFat,
    };

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: TColor.lightGray,
                borderRadius: BorderRadius.circular(10)),
            child: Image.asset(
              "assets/img/black_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          "Meal Schedule",
          style: TextStyle(
              color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: TColor.lightGray,
                  borderRadius: BorderRadius.circular(10)),
              child: Image.asset(
                "assets/img/more_btn.png",
                width: 15,
                height: 15,
                fit: BoxFit.contain,
              ),
            ),
          )
        ],
      ),
      backgroundColor: TColor.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CalendarAgenda(
            controller: _calendarAgendaControllerAppBar,
            appbar: false,
            selectedDayPosition: SelectedDayPosition.center,
            leading: IconButton(
                onPressed: () {},
                icon: Image.asset(
                  "assets/img/ArrowLeft.png",
                  width: 15,
                  height: 15,
                )),
            training: IconButton(
                onPressed: () {},
                icon: Image.asset(
                  "assets/img/ArrowRight.png",
                  width: 15,
                  height: 15,
                )),
            weekDay: WeekDay.short,
            dayNameFontSize: 12,
            dayNumberFontSize: 16,
            dayBGColor: Colors.grey.withOpacity(0.15),
            titleSpaceBetween: 15,
            backgroundColor: Colors.transparent,
            fullCalendarScroll: FullCalendarScroll.horizontal,
            fullCalendarDay: WeekDay.short,
            selectedDateColor: Colors.white,
            dateColor: Colors.black,
            locale: 'en',
            initialDate: DateTime.now(),
            calendarEventColor: TColor.primaryColor2,
            firstDate: DateTime.now().subtract(const Duration(days: 140)),
            lastDate: DateTime.now().add(const Duration(days: 60)),
            onDateSelected: (date) {
              setState(() {
                selectedDate = date;
              });
              _updateMealsForSelectedDate(date); // Cập nhật dữ liệu món ăn
            },
            selectedDayLogo: Container(
              width: double.maxFinite,
              height: double.maxFinite,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: TColor.primaryG,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hiển thị tất cả meal_type, mặc định có dữ liệu hoặc không
                  if (groupedMeals.isNotEmpty)
                    ...groupedMeals.entries.map((entry) {
                      String mealType = entry.key;
                      print("mealType: "+ mealType.toString());
                      List<Map<String, dynamic>> foods = List<Map<String, dynamic>>.from(entry.value);
                      print("food epand: "+ foods.toString());
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  mealType,
                                  style: TextStyle(
                                    color: TColor.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    "${foods.length} Items | ${(foods.fold<num>(0, (total, food) {
                                      final double quantity = double.tryParse(food['quantity']?.toString() ?? '0') ?? 0;
                                      final double caloriesPerUnit = (food['calories_per_unit'] ?? 0).toDouble();
                                      return total + (quantity * caloriesPerUnit);
                                    })).toInt()} calories",
                                    style: TextStyle(color: TColor.gray, fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                          ),
                          if (foods.isNotEmpty)
                            ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: foods.length,
                              itemBuilder: (context, index) {
                                var mObj = foods[index];
                                return MealFoodScheduleRow(
                                  mObj: mObj,
                                  index: index,
                                );
                              },
                            )
                          else
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                              child: Text(
                                "No food added", // Thông báo nếu không có món ăn
                                style: TextStyle(color: TColor.gray, fontSize: 14),
                              ),
                            ),
                          SizedBox(height: media.width * 0.05),
                          // Nút Add Food

                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                int mealTypeId = getMealTypeId(mealType);
                                print("mealTypeId: "+ mealTypeId.toString());
                                if (mealTypeId == 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Invalid meal type!')),
                                  );
                                  return;
                                }
                                print("date: "+ selectedDate.toString());
                                print(userid.toString());
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => scantest(
                                      userId: userid.toString(),
                                      mealTypeId: mealTypeId,
                                      ngay: selectedDate, // Gán giá trị ngày hiện tại
                                    ),
                                  ),
                                );

                                // Kiểm tra nếu có món ăn mới được thêm
                                if (result == true) {
                                  // Gọi lại fetchMeals() để cập nhật giao diện
                                  await fetchMeals();
                                }
                              },
                              child: Text('Add Food'),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  // Phần tổng hợp dinh dưỡng
                  if (_mealsForSelectedDate.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Today Meal Nutritions",
                            style: TextStyle(
                              color: TColor.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          NutritionRow(nObj: nutritionSummary),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          )

        ],
      ),
    );
  }
}
