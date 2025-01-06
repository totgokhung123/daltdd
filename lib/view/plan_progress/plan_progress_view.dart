import 'package:fitness/view/plan_progress/sub_plan_view.dart';
import 'package:flutter/material.dart';

class PlanProgressView extends StatefulWidget {
  const PlanProgressView({super.key});

  @override
  State<PlanProgressView> createState() => _PlanProgressViewState();
}

class _PlanProgressViewState extends State<PlanProgressView> {
  // Cấu trúc danh sách kế hoạch
  List planArr = [
    {
      "title": "Nutrition Plan",
      "description": "A complete nutrition plan for the next 30 days.",
      "image": "assets/img/nutrition_plan.png",
      "subPlans": [
        {
          "title": "Weight Loss Plan",
          "image": "assets/img/diet_plan.jpg",
          "overview": "A 30-day weight loss plan with balanced meals.",
          "schedule": [
            {"day": 1, "title": "Start Diet", "details": "Eat more vegetables."},
            {"day": 2, "title": "Focus on Protein", "details": "Increase protein intake."},
            // Thêm các ngày khác...
          ],
        },
        {
          "title": "Healthy Diet Plan",
          "image": "assets/img/healthy_plan.jpg",
          "overview": "A 7-day diet plan to improve health.",
          "schedule": [
            {"day": 1, "title": "Day 1", "details": "Eat a low-fat diet rich in vegetables."},
            {"day": 2, "title": "Day 2", "details": "Add nuts and fish oil."},
            // Thêm các ngày khác...
          ],
        }
      ],
    },
    {
      "title": "Workout Plan",
      "description": "A workout plan with daily exercises.",
      "image": "assets/img/workout_plan",
      "subPlans": [
        {
          "title": "Beginner Workout",
          "image": "assets/img/nutrition_plan.png",
          "overview": "A 7-day workout plan for beginners.",
          "schedule": [
            {"day": 1, "title": "Full Body Workout", "details": "Focus on major muscle groups."},
            {"day": 2, "title": "Cardio", "details": "30-minute cardio session."},
            // Thêm các ngày khác...
          ],
        },
      ],
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Plans"),
      ),
      body: ListView.builder(
        itemCount: planArr.length,
        itemBuilder: (context, index) {
          var plan = planArr[index];
          return ListTile(
            title: Text(plan['title']),
            subtitle: Text(plan['description']),
            onTap: () {
              // Khi nhấn vào một Plan chính, chuyển đến danh sách các Plan nhỏ
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubPlanView(
                    subPlans: plan['subPlans'],
                    onComplete: () {
                      // Bạn có thể thêm logic khi hoàn thành
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

