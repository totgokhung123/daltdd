import 'package:fitness/view/login/login_view.dart';
import 'package:fitness/view/main_tab/main_tab_view.dart';
import 'package:fitness/view/on_boarding/started_view.dart';
import 'package:fitness/view/profile/SettingView.dart';
import 'package:fitness/view/meal_planner/meal_schedule_view.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fitness/view/profile/SettingView.dart';  // Đảm bảo đã import đúng file SettingView
import 'common/colo_extension.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Khởi tạo Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness 3 in 1',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: TColor.primaryColor1,
        fontFamily: "Poppins"
      ),
      home: const LoginView(),
    );
  }
}

// class _MyAppState extends State<StatefulWidget> {
//   Locale _locale = Locale('en'); // Mặc định là tiếng Anh
//
//   // Hàm để thay đổi ngôn ngữ
//   void _changeLanguage(Locale locale) {
//     setState(() {
//       _locale = locale;
//     });
//   }
//   // @override
//   // Widget build(BuildContext context) {
//   //   return MaterialApp(
//   //     title: 'Fitness 3 in 1',
//   //     debugShowCheckedModeBanner: false,
//   //     theme: ThemeData(
//   //       primaryColor: TColor.primaryColor1,
//   //       fontFamily: "Poppins",
//   //     ),
//   //     locale: _locale, // Sử dụng locale đã chọn
//   //     supportedLocales: [
//   //       Locale('en', 'US'), // Tiếng Anh
//   //       Locale('vi', 'VN'), // Tiếng Việt
//   //     ],
//   //     localizationsDelegates: [
//   //       GlobalMaterialLocalizations.delegate,
//   //       GlobalWidgetsLocalizations.delegate,
//   //       GlobalCupertinoLocalizations.delegate,
//   //     ],
//   //     home: SettingView(onLanguageChanged: _changeLanguage), // Đảm bảo rằng SettingView đã được định nghĩa
//   //   );
//   // }
// }


