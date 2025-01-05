import 'package:fitness/view/profile/ChangePasswordView.dart';
import 'package:flutter/material.dart';

class SettingView extends StatefulWidget {
  final Function(Locale) onLanguageChanged;

  const SettingView({Key? key, required this.onLanguageChanged}) : super(key: key);

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  bool _notificationsEnabled = true; // Biến để lưu trạng thái thông báo
  String _selectedLanguage = "English"; // Ngôn ngữ hiện tại của người dùng

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Bật/Tắt thông báo
          SwitchListTile(
            title: const Text("Enable Notifications"),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
              // Xử lý bật/tắt thông báo (ví dụ: lưu trạng thái vào database hoặc shared preferences)
            },
          ),
          const Divider(),

          // Thay đổi mật khẩu
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text("Change Password"),
            onTap: () {
              // Điều hướng tới trang thay đổi mật khẩu
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangePasswordView(), // Trang thay đổi mật khẩu
                ),
              );
            },
          ),
          const Divider(),

          // Cài đặt ngôn ngữ
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("Language Settings"),
            subtitle: Text("Current Language: $_selectedLanguage"),
            onTap: () {
              // Hiển thị dialog để chọn ngôn ngữ
              _showLanguageDialog(context);
            },
          ),
          const Divider(),
        ],
      ),
    );
  }

  // // Hiển thị dialog để chọn ngôn ngữ
  // void _showLanguageDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text("Select Language"),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             ListTile(
  //               title: const Text("English"),
  //               leading: Radio<String>(
  //                 value: "English",
  //                 groupValue: _selectedLanguage,
  //                 onChanged: (String? value) {
  //                   setState(() {
  //                     _selectedLanguage = value!;
  //                   });
  //                   Navigator.of(context).pop(); // Đóng dialog sau khi chọn
  //                 },
  //               ),
  //             ),
  //             ListTile(
  //               title: const Text("Vietnamese"),
  //               leading: Radio<String>(
  //                 value: "Vietnamese",
  //                 groupValue: _selectedLanguage,
  //                 onChanged: (String? value) {
  //                   setState(() {
  //                     _selectedLanguage = value!;
  //                   });
  //                   Navigator.of(context).pop(); // Đóng dialog sau khi chọn
  //                 },
  //               ),
  //             ),

  // Hiển thị dialog để chọn ngôn ngữ
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Language"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("English"),
                leading: Radio<String>(
                  value: "English",
                  groupValue: _selectedLanguage,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedLanguage = value!;
                    });
                    widget.onLanguageChanged(Locale('en', 'US')); // Thay đổi ngôn ngữ
                    Navigator.of(context).pop(); // Đóng dialog sau khi chọn
                  },
                ),
              ),
              ListTile(
                title: const Text("Vietnamese"),
                leading: Radio<String>(
                  value: "Vietnamese",
                  groupValue: _selectedLanguage,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedLanguage = value!;
                    });
                    widget.onLanguageChanged(Locale('vi', 'VN')); // Thay đổi ngôn ngữ
                    Navigator.of(context).pop(); // Đóng dialog sau khi chọn
                  },
                ),
              ),
              // Thêm các ngôn ngữ khác tại đây nếu cần...
            ],
          ),
        );
      },
    );
  }
}