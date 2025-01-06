import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart'; // Import package
import '../../ApiService.dart';

class WorkoutProgressView extends StatefulWidget {
  final String userId;

  WorkoutProgressView({required this.userId});

  @override
  _WorkoutProgressViewState createState() => _WorkoutProgressViewState();
}

class _WorkoutProgressViewState extends State<WorkoutProgressView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<dynamic>> _plans;
  String _statusFilter = 'active'; // Mặc định là 'active'

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _plans = _fetchWorkoutPlans(_statusFilter);
  }

  // Hàm lấy kế hoạch tập luyện từ API theo status
  Future<List<dynamic>> _fetchWorkoutPlans(String status) async {
    ApiService apiService = ApiService();
    try {
      final plans = await apiService.fetchPlans(widget.userId, status); // Truyền status vào API
      if (plans is List) {
        return plans;
      } else {
        throw Exception('Dữ liệu trả về không hợp lệ');
      }
    } catch (e) {
      throw Exception('Lỗi khi lấy dữ liệu kế hoạch tập luyện: $e');
    }
  }

  // Hàm hiển thị chi tiết kế hoạch
  void _showPlanDetails(int planId) async {
    ApiService apiService = ApiService();
    try {
      final planDetails = await apiService.fetchPlanDetails(planId);
      if (planDetails is List && planDetails.isNotEmpty) {
        // Mở màn hình mới để hiển thị chi tiết kế hoạch
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Workoutprogressview(planDetails: planDetails),
          ),
        );
      } else {
        throw Exception('Không tìm thấy chi tiết kế hoạch');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi lấy chi tiết kế hoạch: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kế Hoạch Tập Luyện'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('ID user: ${widget.userId}', style: TextStyle(fontSize: 16)),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) {
            setState(() {
              if (index == 0) {
                _statusFilter = 'active';
              } else if (index == 1) {
                _statusFilter = 'completed';
              } else if (index == 2) {
                _statusFilter = 'cancelled';
              }
              // Gọi lại API với trạng thái mới
              _plans = _fetchWorkoutPlans(_statusFilter);
            });
          },
          tabs: [
            Tab(text: 'Đang Thực Hiện'),
            Tab(text: 'Hoàn Thành'),
            Tab(text: 'Đã Hủy'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _plans,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Không có kế hoạch tập luyện'));
                } else {
                  final plans = snapshot.data!;
                  return ListView.builder(
                    itemCount: plans.length,
                    itemBuilder: (context, index) {
                      var plan = plans[index];
                      double progress = (plan['progress'] ?? 0) / 100; // Lấy giá trị progress (0 - 1)

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          leading: _statusFilter != 'cancelled'
                              ? CircularPercentIndicator(
                            radius: 25.0,
                            lineWidth: 5.0,
                            percent: progress,
                            center: Text("${(progress * 100).toInt()}%"),
                            progressColor: progress == 1.0 ? Colors.green : Colors.blue,
                          )
                              : null,
                          title: Text(
                            plan['title'] ?? 'Không có tên kế hoạch',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Ngày kết thúc: ${plan['end_date'] ?? 'Không có ngày kết thúc'}'),
                          onTap: () {
                            // Gọi hàm hiển thị chi tiết kế hoạch khi bấm vào kế hoạch
                            _showPlanDetails(plan['plan_id']);
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Workoutprogressview extends StatelessWidget {
  final List<dynamic> planDetails;

  Workoutprogressview({required this.planDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi Tiết Kế Hoạch'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: planDetails.length,
          itemBuilder: (context, index) {
            var detail = planDetails[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(detail['title'] ?? 'Không có tên bài tập'),
                subtitle: Text(detail['description'] ?? 'Không có mô tả'),
              ),
            );
          },
        ),
      ),
    );
  }
}
