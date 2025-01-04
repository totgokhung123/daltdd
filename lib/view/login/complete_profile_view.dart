import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/view/login/what_your_goal_view.dart';
import 'package:flutter/material.dart';
import 'package:fitness/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common_widget/round_button.dart';
import '../../common_widget/round_textfield.dart';

class CompleteProfileView extends StatefulWidget {
  const CompleteProfileView({super.key});

  @override
  State<CompleteProfileView> createState() => _CompleteProfileViewState();
}

class _CompleteProfileViewState extends State<CompleteProfileView> {
  TextEditingController txtDate = TextEditingController();
  TextEditingController txtWeight = TextEditingController();
  TextEditingController txtHeight = TextEditingController();
  String? userId; // Biến để lưu userId

  @override
  void initState() {
    super.initState();
    _loadUserId(); // Gọi hàm để lấy userId
  }

  void _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId =
          prefs.getString('userId'); // Truy xuất userId từ SharedPreferences
    });
  }

  void updateProfile() async {
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User ID not found! Please login again.')),
      );
      return;
    }

    try {
      await ApiService().updateUserProfile(
        userId: userId!,
        dateOfBirth: txtDate.text,
        weight: txtWeight.text,
        height: txtHeight.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const WhatYourGoalView()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Image.asset(
                  "assets/img/complete_profile.png",
                  width: media.width,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Text(
                  "Let’s complete your profile",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  "It will help us to know more about you!",
                  style: TextStyle(color: TColor.gray, fontSize: 12),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                RoundTextField(
                  controller: txtDate,
                  hitText: "Date of Birth (yyyy-mm-dd)",
                  icon: "assets/img/date.png",
                ),
                SizedBox(height: media.width * 0.04),
                Row(
                  children: [
                    Expanded(
                      child: RoundTextField(
                        controller: txtWeight,
                        hitText: "Your Weight",
                        icon: "assets/img/weight.png",
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: TColor.secondaryG),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Text(
                        "KG",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: media.width * 0.04),
                Row(
                  children: [
                    Expanded(
                      child: RoundTextField(
                        controller: txtHeight,
                        hitText: "Your Height",
                        icon: "assets/img/hight.png",
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: TColor.secondaryG),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Text(
                        "CM",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: media.width * 0.07),
                RoundButton(
                  title: "Next >",
                  onPressed: () async {
                    try {
                      // Lấy userId từ SharedPreferences
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String? userId = prefs.getString('userId');

                      if (userId != null) {
                        // Cập nhật thông tin người dùng
                        await ApiService().updateUserProfile(
                          userId: userId,
                          weight: txtWeight.text,
                          height: txtHeight.text,
                          dateOfBirth: txtDate.text,
                        );

                        // Hiển thị thông báo thành công
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Profile updated successfully!')),
                        );
                        // Điều hướng tới màn hình tiếp theo
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WhatYourGoalView()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'User ID not found. Please log in again.')),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to update profile: $e')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
