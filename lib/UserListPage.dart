// import 'package:flutter/material.dart';
// import 'package:fitness/ApiService.dart';
// import 'package:fitness/AddFoodPage.dart';
// class MealTypesPage extends StatefulWidget {
//   @override
//   _MealTypesPageState createState() => _MealTypesPageState();
// }
//
// class _MealTypesPageState extends State<MealTypesPage> {
//   late Future<List<dynamic>> _typeMeals;
//
//   @override
//   void initState() {
//     super.initState();
//     _typeMeals = ApiService().fetchTypeMeal();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Meal Types'),
//       ),
//       body: FutureBuilder<List<dynamic>>(
//         future: _typeMeals,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No meal types found.'));
//           }
//
//           final typeMeals = snapshot.data!;
//           return ListView.builder(
//             itemCount: typeMeals.length,
//             itemBuilder: (context, index) {
//               final mealType = typeMeals[index];
//               return ListTile(
//                 title: Text(mealType['name']),
//                 trailing: Icon(Icons.add),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => AddFoodPage(mealTypeId: mealType['id']),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
