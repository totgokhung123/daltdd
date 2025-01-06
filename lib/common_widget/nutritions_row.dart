import 'package:flutter/material.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

import '../common/colo_extension.dart';

class NutritionRow extends StatelessWidget {
  final Map nObj;
  const NutritionRow({super.key, required this.nObj});

  @override
  Widget build(BuildContext context) {
    double calories = double.tryParse(nObj["calories"].toString()) ?? 0.0;
    double protein = double.tryParse(nObj["protein"].toString()) ?? 0.0;
    double carbs = double.tryParse(nObj["carbs"].toString()) ?? 0.0;
    double fat = double.tryParse(nObj["fat"].toString()) ?? 0.0;

    var media = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: [


          Text(
            "Total Nutrition for Today",
            style: TextStyle(
              color: TColor.black,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          _buildProgressBar(
            context,
            label: "Calories",
            value: calories,
            maxVal: 4000, // Bạn có thể điều chỉnh giá trị tối đa
            color: TColor.primaryColor2,
          ),
          const SizedBox(height: 10),
          _buildProgressBar(
            context,
            label: "Protein",
            value: protein,
            maxVal: 200.0, // Bạn có thể điều chỉnh giá trị tối đa
            color: TColor.primaryColor1,
          ),
          const SizedBox(height: 10),
          _buildProgressBar(
            context,
            label: "Carbs",
            value: carbs,
            maxVal: 300.0, // Bạn có thể điều chỉnh giá trị tối đa
            color: Colors.orange,
          ),
          const SizedBox(height: 10),
          _buildProgressBar(
            context,
            label: "Fat",
            value: fat,
            maxVal: 100.0, // Bạn có thể điều chỉnh giá trị tối đa
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(
      BuildContext context, {
        required String label,
        required double value,
        required double maxVal,
        required Color color,
      }) {
    var media = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "$label: ${value.toStringAsFixed(1)} g",
              style: TextStyle(
                color: TColor.black,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              "${(value / maxVal * 100).toStringAsFixed(1)}%",
              style: TextStyle(color: TColor.gray, fontSize: 11),
            ),
          ],
        ),
        const SizedBox(height: 4),
        SimpleAnimationProgressBar(
          height: 10,
          width: media.width - 30,
          backgroundColor: Colors.grey.shade200,
          foregrondColor: color,
          ratio: value / maxVal,
          direction: Axis.horizontal,
          curve: Curves.fastLinearToSlowEaseIn,
          duration: const Duration(seconds: 3),
          borderRadius: BorderRadius.circular(7.5),
        ),
      ],
    );
  }
}