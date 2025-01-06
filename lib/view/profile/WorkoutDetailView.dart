import 'package:flutter/material.dart';

class WorkoutDetailView extends StatelessWidget {
  // Sửa constructor để nhận 'plan' từ bên ngoài
  final Map<String, dynamic> plan;

  // Constructor nhận dữ liệu 'plan' khi tạo đối tượng
  WorkoutDetailView({required this.plan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi Tiết Kế Hoạch'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tên kế hoạch: ${plan['title']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Ngày bắt đầu: ${plan['start_date']}'),
            Text('Ngày kết thúc: ${plan['end_date']}'),
            Text('Trạng thái: ${plan['status']}'),
            SizedBox(height: 16),
            Text('Progress: ${plan['progress']}%', style: TextStyle(fontSize: 18)),
            // Thêm các thông tin khác về kế hoạch nếu cần
          ],
        ),
      ),
    );
  }
}
