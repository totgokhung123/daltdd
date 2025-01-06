import 'package:fitness/view/plan_progress/plan_excution_view.dart';
import 'package:flutter/material.dart';

class PlanDetailView extends StatefulWidget {
  final Map subPlan;  // Đổi từ String title và List schedule sang Map subPlan

  const PlanDetailView({required this.subPlan, super.key});

  @override
  _PlanDetailViewState createState() => _PlanDetailViewState();
}

class _PlanDetailViewState extends State<PlanDetailView> {
  @override
  Widget build(BuildContext context) {
    var schedule = widget.subPlan['schedule']; // Lấy schedule từ subPlan
    var planTitle = widget.subPlan['title'];   // Lấy title từ subPlan

    return Scaffold(
      appBar: AppBar(
        title: Text(planTitle),  // Hiển thị tên của Plan
      ),
      body: ListView.builder(
        itemCount: schedule.length,  // Lấy số lượng ngày trong kế hoạch
        itemBuilder: (context, index) {
          var day = schedule[index];
          return ListTile(
            title: Text(day['title']),  // Tiêu đề của từng ngày
            subtitle: Text(day['details']),  // Chi tiết của từng ngày
            onTap: () {
              // Điều hướng đến PlanExecutionView và truyền các tham số cần thiết
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlanExecutionView(
                    schedule: day,  // Truyền chi tiết từng ngày
                    planTitle: planTitle,  // Truyền tên kế hoạch
                    onComplete: () {
                      // Logic khi hoàn thành kế hoạch
                      setState(() {});
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
