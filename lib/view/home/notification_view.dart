// import 'package:flutter/material.dart';
//
// import '../../common/colo_extension.dart';
// import '../../common_widget/notification_row.dart';
//
// class NotificationView extends StatefulWidget {
//   const NotificationView({super.key});
//
//   @override
//   State<NotificationView> createState() => _NotificationViewState();
// }
//
// class _NotificationViewState extends State<NotificationView> {
//   List notificationArr = [
//     {"image": "assets/img/Workout1.png", "title": "Hey, it’s time for lunch", "time": "About 1 minutes ago"},
//     {"image": "assets/img/Workout2.png", "title": "Don’t miss your lowerbody workout", "time": "About 3 hours ago"},
//     {"image": "assets/img/Workout3.png", "title": "Hey, let’s add some meals for your b", "time": "About 3 hours ago"},
//     {"image": "assets/img/Workout1.png", "title": "Congratulations, You have finished A..", "time": "29 May"},
//     {"image": "assets/img/Workout2.png", "title": "Hey, it’s time for lunch", "time": "8 April"},
//     {"image": "assets/img/Workout3.png", "title": "Ups, You have missed your Lowerbo...", "time": "8 April"},
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: TColor.white,
//         centerTitle: true,
//         elevation: 0,
//         leading: InkWell(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: Container(
//             margin: const EdgeInsets.all(8),
//             height: 40,
//             width: 40,
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//                 color: TColor.lightGray,
//                 borderRadius: BorderRadius.circular(10)),
//             child: Image.asset(
//               "assets/img/black_btn.png",
//               width: 15,
//               height: 15,
//               fit: BoxFit.contain,
//             ),
//           ),
//         ),
//         title: Text(
//           "Notification",
//           style: TextStyle(
//               color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
//         ),
//         actions: [
//           InkWell(
//             onTap: () {},
//             child: Container(
//               margin: const EdgeInsets.all(8),
//               height: 40,
//               width: 40,
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                   color: TColor.lightGray,
//                   borderRadius: BorderRadius.circular(10)),
//               child: Image.asset(
//                 "assets/img/more_btn.png",
//                 width: 12,
//                 height: 12,
//                 fit: BoxFit.contain,
//               ),
//             ),
//           )
//         ],
//       ),
//       backgroundColor: TColor.white,
//       body: ListView.separated(
//         padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
//         itemBuilder: ((context, index) {
//           var nObj = notificationArr[index] as Map? ?? {};
//           return NotificationRow(nObj: nObj);
//       }), separatorBuilder: (context, index){
//         return Divider(color: TColor.gray.withOpacity(0.5), height: 1, );
//       }, itemCount: notificationArr.length),
//     );
//   }
// }
//
//

import 'package:flutter/material.dart';

import '../../common/colo_extension.dart';
import '../../common_widget/notification_row.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  List<dynamic> notificationArr = [];

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    final response = await http.get(Uri.parse(
        'https://dae2-171-247-159-64.ngrok-free.app/flutter/user.php?notifications=true'));

    if (response.statusCode == 200) {
      setState(() {
        notificationArr = json.decode(response.body);
      });
    } else {
      // Xử lý lỗi nếu không lấy được thông báo
      print('Failed to load notifications');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Phần code hiển thị thông báo như trước
      body: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          itemBuilder: ((context, index) {
            var nObj = notificationArr[index] as Map? ?? {};
            return NotificationRow(nObj: nObj);
          }),
          separatorBuilder: (context, index) {
            return Divider(
              color: TColor.gray.withOpacity(0.5),
              height: 1,
            );
          },
          itemCount: notificationArr.length),
    );
  }
}
