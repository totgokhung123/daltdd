import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../common/colo_extension.dart';
import '../../common_widget/what_train_row.dart';
import 'WorkoutDetailPage.dart';
import 'ApiService_workout.dart';

class WorkoutTrackerView extends StatefulWidget {
  const WorkoutTrackerView({super.key});

  @override
  State<WorkoutTrackerView> createState() => _WorkoutTrackerViewState();
}

class _WorkoutTrackerViewState extends State<WorkoutTrackerView> {
  final ApiService apiService = ApiService();
  late Future<List<dynamic>> _workouts;

  @override
  void initState() {
    super.initState();
    _workouts = apiService.fetchWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Container(
      decoration:
          BoxDecoration(gradient: LinearGradient(colors: TColor.primaryG)),
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.transparent,
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
                "Workout Tracker",
                style: TextStyle(
                    color: TColor.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ];
        },
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: TColor.white,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          child: FutureBuilder<List<dynamic>>(
            future: _workouts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                final workouts = snapshot.data!;
                return ListView.builder(
                  itemCount: workouts.length,
                  itemBuilder: (context, index) {
                    final workout = workouts[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                WorkoutDetailPage(workout: workout),
                          ),
                        );
                      },
                      child: WhatTrainRow(
                        wObj: {
                          "image":
                              "assets/img/workout_placeholder.png", // Thay bằng ảnh phù hợp nếu cần
                          "title": workout['name'],
                          "exercises": workout['description'], // Mô tả bài tập
                          "time": workout['duration'] // Thời gian (nếu có)
                        },
                      ),
                    );
                  },
                );
              }
              return Center(child: Text('No workouts found.'));
            },
          ),
        ),
      ),
    );
  }
}
