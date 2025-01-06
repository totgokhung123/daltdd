import 'package:fitness/view/plan_progress/plan_excution_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubPlanView extends StatefulWidget {
  final List subPlans;

  SubPlanView({required this.subPlans, required Null Function() onComplete});

  @override
  _SubPlanViewState createState() => _SubPlanViewState();
}

class _SubPlanViewState extends State<SubPlanView> {
  get planTitle_day_ => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sub Plans"),
      ),
      body: ListView.builder(
        itemCount: widget.subPlans.length,
        itemBuilder: (context, index) {
          var subPlan = widget.subPlans[index];
          return ListTile(
            title: Text(subPlan['title']),
            subtitle: Text(subPlan['overview']),
            trailing: FutureBuilder(
              future: _isPlanCompleted(subPlan['title']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  bool isCompleted = snapshot.data as bool;
                  return isCompleted
                      ? Icon(Icons.check_circle, color: Colors.green)
                      : Icon(Icons.circle_outlined, color: Colors.grey);
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlanExecutionView(
                    schedule: subPlan['schedule'],
                    planTitle: subPlan['title'],
                    onComplete: () {
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

  Future<bool> _isPlanCompleted(String planTitle) async {
    final prefs = await SharedPreferences.getInstance();
    int dayCount = widget.subPlans
        .firstWhere((plan) => plan['title'] == planTitle)['schedule']
        .length;

    // Kiểm tra tất cả các ngày trong kế hoạch
    for (int i = 0; i < dayCount; i++) {
      if (prefs.getBool('$planTitle_day_$i') != true) {
        return false;
      }
    }
    return true;
  }
}


