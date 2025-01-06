import 'package:carousel_slider/carousel_slider.dart';
import 'package:fitness/view/login/welcome_view.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/colo_extension.dart';
// import '../../common_widget/round_button.dart';
import 'package:fitness/ApiService.dart';

class WhatYourGoalView extends StatefulWidget {
  const WhatYourGoalView({super.key});

  @override
  State<WhatYourGoalView> createState() => _WhatYourGoalViewState();
}

class _WhatYourGoalViewState extends State<WhatYourGoalView> {
  CarouselController buttonCarouselController = CarouselController();
  String? userId; // Biến để lưu userId
  String? weight; // Biến để lưu weight
  String? height; // Biến để lưu height
  double? bmi; // Biến để lưu BMI sau khi tính toán
  String targetValue = ""; // Biến để lưu cân nặng mong muốn
  String selectedGoalType = ""; // Biến để lưu goalType của thẻ được chọn

  @override
  void initState() {
    super.initState();
    _loadData(); // Gọi hàm để lấy dữ liệu user
  }

  void _calculateBMI() {
    if (weight != null && height != null) {
      try {
        double wei = double.parse(weight!);
        double hei = double.parse(height!);

        if (hei > 0) {
          double heigh = hei / 100; // Chuyển chiều cao từ cm sang m
          setState(() {
            bmi = wei / (heigh * heigh); // Tính toán và lưu kết quả BMI
          });
        } else {
          print("Chiều cao không hợp lệ.");
        }
      } catch (e) {
        print("Lỗi khi chuyển đổi dữ liệu: $e");
      }
    } else {
      print("Dữ liệu chưa được tải.");
    }
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
      weight = prefs.getString('weight');
      height = prefs.getString('height');
    });

    _calculateBMI();
  }

  Future<void> _saveGoal(String goalType, String? enteredTargetValue) async {
    try {
      int goalTypeId = goalType == 'Loss Weight'
          ? 1
          : goalType == 'Muscle Gain'
              ? 2
              : 3;

      // Tính toán lượng calories phù hợp (calo/ngày)
      double calories = goalTypeId == 1
          ? 2000 // Giảm cân
          : goalTypeId == 2
              ? 3000 // Tăng cơ
              : 2500; // Duy trì

      String? targetValueToSave = goalTypeId == 1 ? enteredTargetValue : null;

      // Gửi API để lưu dữ liệu
      await ApiService().addGoal(
        userId: userId!,
        goalTypeId: goalTypeId.toString(),
        currentValue: weight!,
        targetValue: targetValueToSave ?? "",
        calories: calories.toString(),
      );

      // Thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Goal saved successfully!')),
      );

      // Chuyển đến màn hình khác nếu cần
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const WelcomeView()));
    } catch (e) {
      print('Lỗi khi lưu mục tiêu: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save goal: $e')),
      );
    }
  }

  List goalArr = [
    {
      "image": "assets/img/goal_1.png",
      "title": "Muscle Gain",
      "subtitle":
          "People with muscles look great. \n I want to be like them. \n I have to increase my muscles."
    },
    {
      "image": "assets/img/goal_2.png",
      "title": "Loss Weight",
      "subtitle":
          "I look fat. Losing weight is better \n for my health. Maybe I should \n lose weight."
    },
    {
      "image": "assets/img/goal_3.png",
      "title": "Maintenance",
      "subtitle":
          "My body seems fine. \n I want to maintain my body. \n Please maintain your body health."
    },
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: CarouselSlider(
                items: goalArr.map((gObj) {
                  // Dựa vào BMI để xác định thẻ nào được đề xuất
                  String? goalTitle = gObj["title"].toString();
                  bool showSuggestion = false;

                  if (bmi != null) {
                    if (bmi! < 18.5 && goalTitle == "Muscle Gain") {
                      showSuggestion = true;
                    } else if (bmi! >= 18.5 &&
                        bmi! <= 24.9 &&
                        goalTitle == "Maintenance") {
                      showSuggestion = true;
                    } else if (bmi! > 25 && goalTitle == "Loss Weight") {
                      showSuggestion = true;
                    }
                  }

                  return GestureDetector(
                    onTap: () async {
                      String goalType = gObj["title"].toString();
                      if (goalType == "Loss Weight") {
                        // Hiện dialog nhập cân nặng mong muốn
                        String? enteredTargetValue = await showDialog<String>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Nhập cân nặng mong muốn"),
                            content: TextField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  hintText: "Nhập cân nặng (kg)"),
                              onChanged: (value) {
                                targetValue = value;
                              },
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, targetValue);
                                },
                                child: const Text("Xác nhận"),
                              ),
                            ],
                          ),
                        );

                        if (enteredTargetValue != null &&
                            enteredTargetValue.isNotEmpty) {
                          await _saveGoal(goalType, enteredTargetValue);
                        }
                      } else {
                        await _saveGoal(goalType, null);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: TColor.primaryG,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: media.width * 0.1, horizontal: 25),
                      alignment: Alignment.center,
                      child: FittedBox(
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Image.asset(
                                  gObj["image"].toString(),
                                  width: media.width * 0.5,
                                  fit: BoxFit.fitWidth,
                                ),
                                if (showSuggestion)
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Đề xuất',
                                        style: TextStyle(
                                            color: TColor.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(
                              height: media.width * 0.1,
                            ),
                            Text(
                              gObj["title"].toString(),
                              style: TextStyle(
                                  color: TColor.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700),
                            ),
                            Container(
                              width: media.width * 0.1,
                              height: 1,
                              color: TColor.white,
                            ),
                            SizedBox(
                              height: media.width * 0.02,
                            ),
                            Text(
                              gObj["subtitle"].toString(),
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: TColor.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
                carouselController: buttonCarouselController,
                options: CarouselOptions(
                  autoPlay: false,
                  enlargeCenterPage: true,
                  viewportFraction: 0.7,
                  aspectRatio: 0.74,
                  initialPage: 0,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              width: media.width,
              child: Column(
                children: [
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  Text(
                    "What is your goal ?",
                    style: TextStyle(
                        color: TColor.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "It will help us to choose a best\nprogram for you",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: TColor.gray, fontSize: 12),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  // RoundButton(
                  //   title: "Confirm",
                  //   onPressed: () async {
                  //     // Lấy giá trị mục tiêu từ biến targetValue
                  //     String goalType =
                  //         "Maintenance"; // Ví dụ, nếu bạn muốn lưu mục tiêu Maintenance mặc định
                  //     if (targetValue.isNotEmpty) {
                  //       // Nếu người dùng nhập cân nặng mục tiêu, gọi hàm _saveGoal
                  //       await _saveGoal(goalType, targetValue);
                  //     } else {
                  //       // Nếu không có mục tiêu nhập, chỉ lưu mục tiêu không có giá trị mục tiêu
                  //       await _saveGoal(goalType, null);
                  //     }
                  //     // Chuyển hướng đến màn hình chào mừng sau khi lưu thành công
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => const WelcomeView()),
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
