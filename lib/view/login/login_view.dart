import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/common_widget/round_button.dart';
import 'package:fitness/common_widget/round_textfield.dart';
import 'package:fitness/view/login/complete_profile_view.dart';
import 'package:fitness/view/login/signup_view.dart';
import 'package:fitness/view/login/welcome_view.dart';
import 'package:flutter/material.dart';
import 'package:fitness/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible =
      false; // Biến để kiểm tra trạng thái ẩn/hiện mật khẩu
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final email = googleUser.email;
        final name = googleUser.displayName ?? "Unknown";

        // Gửi thông tin tới backend để lưu hoặc đăng nhập
        var response = await ApiService().loginGG(
          name: name,
          email: email,
          password: 'Ab123@579', // Mật khẩu mặc định hoặc ngẫu nhiên
        );

        if (response['message'] == "Login successful") {
          // Lưu thông tin vào SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('email', email);
          await prefs.setString('name', name);

          var userId = response['userId'];
          var weight = response['weight'];

          await prefs.setString('userId', userId); // Lưu userId
          await prefs.setString('weight', weight ?? "NULL"); // Lưu weight

          // Debug
          print('Google User: $email, $name');
          print('User ID: $userId');
          print('Weight: $weight');

          // Điều hướng dựa trên trạng thái người dùng
          if (weight == "NULL") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CompleteProfileView(),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WelcomeView(),
              ),
            );
          }
        } else {
          // Xử lý lỗi nếu đăng nhập thất bại
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Error'),
              content: Text('Failed to login: ${response['error']}'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      // Xử lý lỗi trong quá trình đăng nhập Google
      print("Google Sign-In Error: $e");
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Error'),
          content: Text('An error occurred: $e'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: media.height * 0.9,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Hey there,",
                  style: TextStyle(color: TColor.gray, fontSize: 16),
                ),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                RoundTextField(
                  controller: emailController,
                  hitText: "Email",
                  icon: "assets/img/email.png",
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                RoundTextField(
                  controller: passwordController,
                  hitText: "Password",
                  icon: "assets/img/lock.png",
                  obscureText:
                      !isPasswordVisible, // Đặt lại giá trị obscureText tùy theo biến isPasswordVisible
                  rigtIcon: TextButton(
                    onPressed: () {
                      setState(() {
                        isPasswordVisible =
                            !isPasswordVisible; // Chuyển trạng thái ẩn/hiện mật khẩu
                      });
                    },
                    child: Container(
                        alignment: Alignment.center,
                        width: 20,
                        height: 20,
                        child: Image.asset(
                          isPasswordVisible
                              ? "assets/img/show_password.png" // Hình ảnh cho khi mật khẩu hiển thị
                              : "assets/img/show_password.png", // Hình ảnh cho khi mật khẩu ẩn
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                          color: TColor.gray,
                        )),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Forgot your password?",
                      style: TextStyle(
                          color: TColor.gray,
                          fontSize: 10,
                          decoration: TextDecoration.underline),
                    ),
                  ],
                ),
                const Spacer(),
                RoundButton(
                    title: "Login",
                    onPressed: () async {
                      try {
                        var response = await ApiService().loginUser(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                        if (response['message'] == "Login successful") {
                          var userId = response['userId']; // API trả về userId
                          var weight = response['weight']; // API trả về weight

                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          await prefs.setString('userId',
                              userId); // Lưu userId vào SharedPreferences

                          await prefs.setString(
                              'weight',
                              weight ??
                                  "NULL"); // Lưu weight vào SharedPreferences

                          var savedUserId = prefs.getString('userId');
                          print(
                              'Saved User ID: $savedUserId'); // In ra để xác nhận
                          print('Saved Weight: ${prefs.getString('weight')}');

                          if (response['weight'] == "NULL") {
                            // Điều hướng sang trang khác sau khi đăng nhập thành công
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CompleteProfileView(),
                              ),
                            );
                          } else {
                            // Điều hướng sang trang khác sau khi đăng nhập thành công
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WelcomeView(),
                              ),
                            );
                          }
                        } else {
                          // Hiển thị thông báo lỗi nếu đăng nhập không thành công
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text('Error'),
                              content: Text('Invalid email or password'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      } catch (e) {
                        // Hiển thị thông báo lỗi nếu có lỗi khi gửi yêu cầu
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text('Error'),
                            content: Text('An error occurred: $e'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    }),
                SizedBox(
                  height: media.width * 0.04,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                      height: 1,
                      color: TColor.gray.withOpacity(0.5),
                    )),
                    Text(
                      "  Or  ",
                      style: TextStyle(color: TColor.black, fontSize: 12),
                    ),
                    Expanded(
                        child: Container(
                      height: 1,
                      color: TColor.gray.withOpacity(0.5),
                    )),
                  ],
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await loginWithGoogle(); // Gọi hàm đăng nhập với google
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: TColor.white,
                          border: Border.all(
                            width: 1,
                            color: TColor.gray.withOpacity(0.4),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Image.asset(
                          "assets/img/google.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: media.width * 0.04,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: TColor.white,
                          border: Border.all(
                            width: 1,
                            color: TColor.gray.withOpacity(0.4),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Image.asset(
                          "assets/img/facebook.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Don’t have an account yet? ",
                      style: TextStyle(
                        color: TColor.black,
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Điều hướng sang SignUpView
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpView()),
                        );
                      },
                      child: Text(
                        "Register",
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
