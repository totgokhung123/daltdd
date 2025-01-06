import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/colo_extension.dart';

class PlanDayDetailView extends StatefulWidget {
  final Map plan;
  final List<Map> days;

  const PlanDayDetailView({required this.plan, super.key, required this.days});

  @override
  _PlanDayDetailViewState createState() => _PlanDayDetailViewState();
}

class _PlanDayDetailViewState extends State<PlanDayDetailView> {
  late List<bool> dayCompletionStatus;

  @override
  void initState() {
    super.initState();
    // Initialize the completion status for each day (all false initially)
    dayCompletionStatus = List<bool>.generate(widget.days.length, (index) => false);
  }

  void _toggleCompletion(int dayIndex) {
    setState(() {
      // Toggle the completion status of the clicked day
      dayCompletionStatus[dayIndex] = !dayCompletionStatus[dayIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var days = widget.days;

    bool allCompleted = dayCompletionStatus.every((status) => status);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "${widget.plan["title"]} Schedule",
          style: TextStyle(
              color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: media.width * 0.05),
              Text(
                "Plan Schedule",
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 10),
              // Hiển thị danh sách các ngày trong kế hoạch
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: days.length,
                itemBuilder: (context, index) {
                  var dayObj = days[index] as Map? ?? {};
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: TColor.lightGray.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Day ${dayObj["day"]}: ${dayObj["title"]}",
                              style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () => _toggleCompletion(index),
                              child: Icon(
                                dayCompletionStatus[index]
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: dayCompletionStatus[index]
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          dayObj["details"] ?? "",
                          style: TextStyle(color: TColor.gray, fontSize: 14),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: media.width * 0.1),
              // Hiển thị phần hoàn thành khi tất cả các ngày đã được hoàn thành
              if (allCompleted)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      // Xử lý khi hoàn thành toàn bộ kế hoạch
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Kế hoạch hoàn thành!"),
                            content: Text("Chúc mừng bạn đã hoàn thành bài tập!"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("OK"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Sử dụng backgroundColor thay cho primary
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text(
                      "Hoàn thành bài tập",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
