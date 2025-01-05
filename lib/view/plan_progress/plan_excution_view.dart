import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlanExecutionView extends StatefulWidget {
  final List schedule;
  final String planTitle;
  final Function onComplete;

  const PlanExecutionView({
    required this.schedule,
    required this.planTitle,
    required this.onComplete,
    super.key,
  });

  @override
  _PlanExecutionViewState createState() => _PlanExecutionViewState();
}

class _PlanExecutionViewState extends State<PlanExecutionView> {
  int currentDay = 0;  // Trạng thái ngày hiện tại
  List<bool> completedDays = [];  // Danh sách các ngày đã hoàn thành

  @override
  void initState() {
    super.initState();
    completedDays = List<bool>.filled(widget.schedule.length, false);
    _loadCompletionState();  // Tải trạng thái hoàn thành từ SharedPreferences
  }

  // Tải trạng thái hoàn thành của các ngày từ SharedPreferences
  Future<void> _loadCompletionState() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < widget.schedule.length; i++) {
      completedDays[i] = prefs.getBool('${widget.planTitle}_day_$i') ?? false;
    }
    setState(() {});  // Cập nhật lại giao diện sau khi tải trạng thái
  }

  // Lưu trạng thái hoàn thành vào SharedPreferences
  Future<void> _saveCompletionState() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < widget.schedule.length; i++) {
      await prefs.setBool('${widget.planTitle}_day_$i', completedDays[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    var day = widget.schedule[currentDay];  // Lấy thông tin ngày hiện tại

    return Scaffold(
      appBar: AppBar(
        title: const Text("Executing Plan"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Day ${day['day']}: ${day['title']}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(day['details']),
            const Spacer(),
            // Nếu chưa hoàn thành ngày hiện tại
            if (!completedDays[currentDay])
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      completedDays[currentDay] = true;  // Đánh dấu ngày hoàn thành
                    });
                    _saveCompletionState();  // Lưu trạng thái vào SharedPreferences
                    widget.onComplete();  // Thực hiện callback khi hoàn thành
                  },
                  child: const Text("Mark as Completed"),
                ),
              ),
            // Nếu đã hoàn thành ngày hiện tại
            if (completedDays[currentDay])
              Center(
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 40,
                ),
              ),
            // Nếu có ngày tiếp theo
            if (currentDay < widget.schedule.length - 1)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Nếu ngày hiện tại chưa được đánh dấu hoàn thành thì hiển thị cảnh báo
                    if (completedDays[currentDay]) {
                      setState(() {
                        currentDay++;  // Di chuyển sang ngày tiếp theo
                      });
                    } else {
                      _showIncompleteDialog();
                    }
                  },
                  child: const Text("Next Day"),
                ),
              )
            else
            // Khi đã là ngày cuối, nút "End Plan"
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Kiểm tra nếu tất cả các ngày đều hoàn thành trước khi kết thúc kế hoạch
                    if (_canEndPlan()) {
                      widget.onComplete();  // Gọi callback khi hoàn thành kế hoạch
                      Navigator.pop(context);  // Quay lại màn hình trước
                    } else {
                      _showIncompleteDialog();
                    }
                  },
                  child: const Text("End Plan"),
                ),
              ),
            // Nếu có ngày trước đó
            if (currentDay > 0)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentDay--;  // Quay lại ngày trước đó
                    });
                  },
                  child: const Text("Previous Day"),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Kiểm tra nếu tất cả các ngày đều hoàn thành trước khi kết thúc kế hoạch
  bool _canEndPlan() {
    return completedDays.every((completed) => completed);
  }

  // Hiển thị cảnh báo nếu người dùng chưa hoàn thành ngày hiện tại
  void _showIncompleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Warning"),
          content: const Text("You need to mark the current day as completed before moving to the next day or ending the plan."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);  // Đóng cảnh báo
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
