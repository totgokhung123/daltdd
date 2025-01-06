// import 'package:fitness/view/profile/edit_profile_view.dart';
// import 'package:flutter/material.dart';
//
// import '../../common/colo_extension.dart';
// import '../../common_widget/round_button.dart';
// import '../../common_widget/setting_row.dart';
// import '../../common_widget/title_subtitle_cell.dart';
// import 'package:animated_toggle_switch/animated_toggle_switch.dart';
//
// class ProfileView extends StatefulWidget {
//   const ProfileView({super.key});
//
//   @override
//   State<ProfileView> createState() => _ProfileViewState();
// }
//
// class _ProfileViewState extends State<ProfileView> {
//   bool positive = false;
//
//   List accountArr = [
//     {"image": "assets/img/p_personal.png", "name": "Personal Data", "tag": "1"},
//     {"image": "assets/img/p_achi.png", "name": "Achievement", "tag": "2"},
//     {
//       "image": "assets/img/p_activity.png",
//       "name": "Activity History",
//       "tag": "3"
//     },
//     {
//       "image": "assets/img/p_workout.png",
//       "name": "Workout Progress",
//       "tag": "4"
//     }
//   ];
//
//   List otherArr = [
//     {"image": "assets/img/p_contact.png", "name": "Contact Us", "tag": "5"},
//     {"image": "assets/img/p_privacy.png", "name": "Privacy Policy", "tag": "6"},
//     {"image": "assets/img/p_setting.png", "name": "Setting", "tag": "7"},
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: TColor.white,
//         centerTitle: true,
//         elevation: 0,
//         leadingWidth: 0,
//         title: Text(
//           "Profile",
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
//                 width: 15,
//                 height: 15,
//                 fit: BoxFit.contain,
//               ),
//             ),
//           )
//         ],
//       ),
//       backgroundColor: TColor.white,
//       body: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Row(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(30),
//                     child: Image.asset(
//                       "assets/img/u2.png",
//                       width: 50,
//                       height: 50,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 15,
//                   ),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Stefani Wong",
//                           style: TextStyle(
//                             color: TColor.black,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         Text(
//                           "Lose a Fat Program",
//                           style: TextStyle(
//                             color: TColor.gray,
//                             fontSize: 12,
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     width: 70,
//                     height: 25,
//                     child: RoundButton(
//                       title: "Edit",
//                       type: RoundButtonType.bgGradient,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w400,
//                       onPressed: () {
//                         // Navigator.push(
//                         //   context,
//                         //   MaterialPageRoute(
//                         //     builder: (context) => const ActivityTrackerView(),
//                         //   ),
//                         // );
//
//                         // Chuyển tới màn hình chỉnh sửa và nhận thông tin mới
//                         final result = await Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => EditProfileView(
//                               name: name,
//                               height: height,
//                               weight: weight,
//                               age: age,
//                             ),
//                           ),
//                         );
//
//                         // Nếu có dữ liệu trả về từ EditProfileView, cập nhật thông tin
//                         if (result != null && result is Map<String, String>) {
//                           setState(() {
//                             name = result['name']!;
//                             height = result['height']!;
//                             weight = result['weight']!;
//                             age = result['age']!;
//                           });
//                         }
//                       },
//                     ),
//                   )
//                 ],
//               ),
//               const SizedBox(
//                 height: 15,
//               ),
//               const Row(
//                 children: [
//                   Expanded(
//                     child: TitleSubtitleCell(
//                       title: "180cm",
//                       subtitle: "Height",
//                     ),
//                   ),
//                   SizedBox(
//                     width: 15,
//                   ),
//                   Expanded(
//                     child: TitleSubtitleCell(
//                       title: "65kg",
//                       subtitle: "Weight",
//                     ),
//                   ),
//                   SizedBox(
//                     width: 15,
//                   ),
//                   Expanded(
//                     child: TitleSubtitleCell(
//                       title: "22yo",
//                       subtitle: "Age",
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 25,
//               ),
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//                 decoration: BoxDecoration(
//                     color: TColor.white,
//                     borderRadius: BorderRadius.circular(15),
//                     boxShadow: const [
//                       BoxShadow(color: Colors.black12, blurRadius: 2)
//                     ]),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Account",
//                       style: TextStyle(
//                         color: TColor.black,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     ListView.builder(
//                       physics: const NeverScrollableScrollPhysics(),
//                       shrinkWrap: true,
//                       itemCount: accountArr.length,
//                       itemBuilder: (context, index) {
//                         var iObj = accountArr[index] as Map? ?? {};
//                         return SettingRow(
//                           icon: iObj["image"].toString(),
//                           title: iObj["name"].toString(),
//                           onPressed: () {},
//                         );
//                       },
//                     )
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 height: 25,
//               ),
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//                 decoration: BoxDecoration(
//                     color: TColor.white,
//                     borderRadius: BorderRadius.circular(15),
//                     boxShadow: const [
//                       BoxShadow(color: Colors.black12, blurRadius: 2)
//                     ]),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Notification",
//                       style: TextStyle(
//                         color: TColor.black,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     SizedBox(
//                       height: 30,
//                       child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Image.asset("assets/img/p_notification.png",
//                                 height: 15, width: 15, fit: BoxFit.contain),
//                             const SizedBox(
//                               width: 15,
//                             ),
//                             Expanded(
//                               child: Text(
//                                 "Pop-up Notification",
//                                 style: TextStyle(
//                                   color: TColor.black,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                             CustomAnimatedToggleSwitch<bool>(
//                               current: positive,
//                               values: [false, true],
//                               dif: 0.0,
//                               indicatorSize: Size.square(30.0),
//                               animationDuration:
//                                   const Duration(milliseconds: 200),
//                               animationCurve: Curves.linear,
//                               onChanged: (b) => setState(() => positive = b),
//                               iconBuilder: (context, local, global) {
//                                 return const SizedBox();
//                               },
//                               defaultCursor: SystemMouseCursors.click,
//                               onTap: () => setState(() => positive = !positive),
//                               iconsTappable: false,
//                               wrapperBuilder: (context, global, child) {
//                                 return Stack(
//                                   alignment: Alignment.center,
//                                   children: [
//                                     Positioned(
//                                         left: 10.0,
//                                         right: 10.0,
//
//                                         height: 30.0,
//                                         child: DecoratedBox(
//                                           decoration: BoxDecoration(
//                                              gradient: LinearGradient(
//                                                 colors: TColor.secondaryG),
//                                             borderRadius:
//                                                 const BorderRadius.all(
//                                                     Radius.circular(50.0)),
//                                           ),
//                                         )),
//                                     child,
//                                   ],
//                                 );
//                               },
//                               foregroundIndicatorBuilder: (context, global) {
//                                 return SizedBox.fromSize(
//                                   size: const Size(10, 10),
//                                   child: DecoratedBox(
//                                     decoration: BoxDecoration(
//                                       color: TColor.white,
//                                       borderRadius: const BorderRadius.all(
//                                           Radius.circular(50.0)),
//                                       boxShadow: const [
//                                         BoxShadow(
//                                             color: Colors.black38,
//                                             spreadRadius: 0.05,
//                                             blurRadius: 1.1,
//                                             offset: Offset(0.0, 0.8))
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ]),
//                     )
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 height: 25,
//               ),
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//                 decoration: BoxDecoration(
//                     color: TColor.white,
//                     borderRadius: BorderRadius.circular(15),
//                     boxShadow: const [
//                       BoxShadow(color: Colors.black12, blurRadius: 2)
//                     ]),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Other",
//                       style: TextStyle(
//                         color: TColor.black,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     ListView.builder(
//                       physics: const NeverScrollableScrollPhysics(),
//                       padding: EdgeInsets.zero,
//                       shrinkWrap: true,
//                       itemCount: otherArr.length,
//                       itemBuilder: (context, index) {
//                         var iObj = otherArr[index] as Map? ?? {};
//                         return SettingRow(
//                           icon: iObj["image"].toString(),
//                           title: iObj["name"].toString(),
//                           onPressed: () {},
//                         );
//                       },
//                     )
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:fitness/view/profile/AchievementView.dart';
import 'package:fitness/view/profile/ActivityHistoryView.dart';
import 'package:fitness/view/profile/ContactUsView.dart';
import 'package:fitness/view/profile/PrivacyPolicyView.dart';
import 'package:fitness/view/profile/SettingView.dart';
import 'package:fitness/view/profile/WorkoutProgressView.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/colo_extension.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/setting_row.dart';
import '../../common_widget/title_subtitle_cell.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'edit_profile_view.dart'; // Đảm bảo đã import EditProfileView


class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool positive = false;

  // Thông tin hồ sơ ban đầu
  String name = "Stefani Wong";
  String height = "180cm";
  String weight = "65kg";
  String age = "22yo";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Tải dữ liệu từ SharedPreferences
  _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString('name') ?? 'John Doe';
      height = prefs.getString('height') ?? '170';
      weight = prefs.getString('weight') ?? '60';
      age = prefs.getString('age') ?? '25';
    });
  }

  List accountArr = [
    {"image": "assets/img/p_personal.png", "name": "Personal Data", "tag": "1"},
    {"image": "assets/img/p_achi.png", "name": "Achievement", "tag": "2"},
    {"image": "assets/img/p_activity.png", "name": "Activity History", "tag": "3"},
    {"image": "assets/img/p_workout.png", "name": "Workout Progress", "tag": "4"}
  ];

  List otherArr = [
    {"image": "assets/img/p_contact.png", "name": "Contact Us", "tag": "5"},
    {"image": "assets/img/p_privacy.png", "name": "Privacy Policy", "tag": "6"},
    {"image": "assets/img/p_setting.png", "name": "Setting", "tag": "7"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leadingWidth: 0,
        title: Text(
          "Profile",
          style: TextStyle(
              color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: TColor.lightGray,
                  borderRadius: BorderRadius.circular(10)),
              child: Image.asset(
                "assets/img/more_btn.png",
                width: 15,
                height: 15,
                fit: BoxFit.contain,
              ),
            ),
          )
        ],
      ),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                // children: [
                //   ClipRRect(
                //     borderRadius: BorderRadius.circular(30),
                //     child: Image.asset(
                //       "assets/img/u2.png",
                //       width: 50,
                //       height: 50,
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                //   const SizedBox(width: 15),
                //   Expanded(
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text(
                //           name,
                //           style: TextStyle(
                //             color: TColor.black,
                //             fontSize: 14,
                //             fontWeight: FontWeight.w500,
                //           ),
                //         ),
                //         Text(
                //           "Lose a Fat Program",
                //           style: TextStyle(
                //             color: TColor.gray,
                //             fontSize: 12,
                //           ),
                //         )
                //       ],
                //     ),
                //   ),
                //   SizedBox(
                //     width: 70,
                //     height: 25,
                //     child: RoundButton(
                //       title: "Edit",
                //       type: RoundButtonType.bgGradient,
                //       fontSize: 12,
                //       fontWeight: FontWeight.w400,
                //       onPressed: () async {
                //         // Chuyển tới màn hình chỉnh sửa và nhận thông tin mới
                //         final result = await Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (context) => EditProfileView(
                //               name: name,
                //               height: height,
                //               weight: weight,
                //               age: age,
                //             ),
                //           ),
                //         );
                //
                //         // Nếu có dữ liệu trả về từ EditProfileView, cập nhật thông tin
                //         if (result != null && result is Map<String, String>) {
                //           setState(() {
                //             name = result['name']!;
                //             height = result['height']!;
                //             weight = result['weight']!;
                //             age = result['age']!;
                //           });
                //         }
                //       },
                //     ),
                //   ),
                // ],
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      "assets/img/u2.png",
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            color: TColor.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Lose a Fat Program",
                          style: TextStyle(
                            color: TColor.gray,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 70,
                    height: 25,
                    child: RoundButton(
                      title: "Edit",
                      type: RoundButtonType.bgGradient,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      onPressed: () async {
                        // Chuyển tới màn hình chỉnh sửa và nhận thông tin mới
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfileView(
                              name: name,
                              height: height,
                              weight: weight,
                              age: age,
                            ),
                          ),
                        );

                        // Nếu có dữ liệu trả về từ EditProfileView, cập nhật thông tin
                        if (result != null && result is Map<String, String>) {
                          setState(() {
                            // Cập nhật các giá trị name, height, weight, age mới
                            name = result['name']!;
                            height = result['height']!;
                            weight = result['weight']!;
                            age = result['age']!;
                          });

                          // Cập nhật vào SharedPreferences (nếu cần thiết)
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setString('name', name);
                          prefs.setString('height', height);
                          prefs.setString('weight', weight);
                          prefs.setString('age', age);
                        }
                      },
                    ),
                  ),
                ],

              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: TitleSubtitleCell(
                      title: height,
                      subtitle: "Height",
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TitleSubtitleCell(
                      title: weight,
                      subtitle: "Weight",
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TitleSubtitleCell(
                      title: age,
                      subtitle: "Age",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                    color: TColor.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 2)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Account",
                      style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: accountArr.length,
                      itemBuilder: (context, index) {
                        var iObj = accountArr[index] as Map? ?? {};
                        return SettingRow(
                          icon: iObj["image"].toString(),
                          title: iObj["name"].toString(),
                          onPressed: () {
                            if (iObj["tag"] == "1") {
                              // Điều hướng tới trang chỉnh sửa Personal Data
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  EditProfileView(name: name, height: height, weight: weight, age: age), // Trang chỉnh sửa hồ sơ
                                ),
                              );
                            } else if (iObj["tag"] == "2") {
                              // Điều hướng tới trang Achievement (Thành tựu)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AchievementView(), // Trang Achievement
                                ),
                              );
                            } else if (iObj["tag"] == "3") {
                              // Điều hướng tới trang Activity History (Lịch sử hoạt động)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ActivityHistoryView(), // Trang Activity History
                                ),
                              );
                            } else if (iObj["tag"] == "4") {
                              // Điều hướng tới trang Workout Progress (Tiến độ tập luyện)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WorkoutProgressView(userId: '1',), // Trang Workout Progress
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color: TColor.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Other",
                      style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: otherArr.length,
                      itemBuilder: (context, index) {
                        var iObj = otherArr[index] as Map? ?? {};
                        return SettingRow(
                          icon: iObj["image"].toString(),
                          title: iObj["name"].toString(),
                          onPressed: () {
                            if (iObj["tag"] == "5") {
                              // Điều hướng tới trang Contact Us (Liên hệ)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ContactUsView(), // Trang Contact Us
                                ),
                              );
                            } else if (iObj["tag"] == "6") {
                              // Điều hướng tới trang Privacy Policy (Chính sách bảo mật)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PrivacyPolicyView(), // Trang Privacy Policy
                                ),
                              );
                            }
                            else if (iObj["tag"] == "7") {
                              // Điều hướng tới trang Settings (Cài đặt)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SettingView(
                                    onLanguageChanged: (Locale locale) {
                                      // Đảm bảo bạn có một hàm thay đổi ngôn ngữ ở đây
                                      print('Ngôn ngữ đã thay đổi thành: $locale');
                                    },
                                  ), // Trang Setting với tham số onLanguageChanged
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Màn hình chỉnh sửa thông tin
class EditProfileView extends StatefulWidget {
  final String name;
  final String height;
  final String weight;
  final String age;

  const EditProfileView({
    Key? key,
    required this.name,
    required this.height,
    required this.weight,
    required this.age,
  }) : super(key: key);

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late TextEditingController _nameController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _ageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _heightController = TextEditingController(text: widget.height);
    _weightController = TextEditingController(text: widget.weight);
    _ageController = TextEditingController(text: widget.age);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
    TextFormField(
              controller: _heightController,
              decoration: const InputDecoration(labelText: 'Height (cm)'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _weightController,
              decoration: const InputDecoration(labelText: 'Weight (kg)'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Lấy thông tin từ các trường nhập liệu và trả về
                Navigator.pop(context, {
                  'name': _nameController.text,
                  'height': _heightController.text,
                  'weight': _weightController.text,
                  'age': _ageController.text,
                });
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
