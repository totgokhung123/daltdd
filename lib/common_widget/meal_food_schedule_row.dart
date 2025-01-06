import 'package:fitness/common/colo_extension.dart';
import 'package:flutter/material.dart';

class MealFoodScheduleRow extends StatelessWidget {
  final Map mObj;
  final int index;
  const MealFoodScheduleRow({super.key, required this.mObj, required this.index});

  @override
  Widget build(BuildContext context) {
    // Lấy dữ liệu từ mObj
    String mealId = mObj["meal_id"].toString();
    String foodName = mObj["food_name"] ?? "No food name";  // Kiểm tra null
    String mealType = mObj["type_meal_name"] ?? "Unknown";  // Kiểm tra null
    String quantity = mObj["quantity"].toString() ;
    String caloriesPerUnit = mObj["calories_per_unit"].toString() ;
    String caloriesTotal = mObj["calories_total"].toString() ;
    String defaultUnit = mObj["default_unit"] ?? "g";
    String default_size = mObj["default_size"].toString();
    String image = mObj["image"] != null ? mObj["image"].toString() : "assets/img/orange.png";;


    return Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                    color: index % 2 == 0 ? TColor.primaryColor2.withOpacity(0.4) : TColor.secondaryColor2.withOpacity(0.4) ,
                    borderRadius: BorderRadius.circular(10)),
                  alignment: Alignment.center,
                child: Image.asset(
                  mObj["image"].toString(),
                  width: 40,
                  height: 40,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mObj["food_name"].toString(),
                    style: TextStyle(
                        color: TColor.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "quantity: "+ mObj["quantity"].toString() + ",  calories:  " + mObj["calories_per_unit"].toString()+ " Kcal" ,
                    style: TextStyle(
                      color: TColor.gray,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            // IconButton(
            //   onPressed: () {},
            //   icon: Image.asset(
            //     "assets/img/next_go.png",
            //     width: 25,
            //     height: 25,
            //   ),
            // )
          ],
        ));
  }
}
