# fitness

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.
# DALTDD Fitness 🏋️‍♂️

**DALTDD Fitness** là một ứng dụng di động được phát triển bằng **Flutter**, hỗ trợ người dùng theo dõi và quản lý các hoạt động thể chất, tập luyện và sức khỏe cá nhân. Ứng dụng cung cấp giao diện trực quan, dễ sử dụng cùng các chức năng quản lý bài tập, nhắc nhở lịch trình và theo dõi tiến trình luyện tập.

## 🚀 Tính năng chính

### 📌 1. Đăng nhập & Quản lý tài khoản
- Hỗ trợ **đăng nhập, đăng ký tài khoản**.
- Lưu trữ thông tin cá nhân như **cân nặng, chiều cao, tuổi, giới tính**.
- Quản lý hồ sơ cá nhân, cập nhật thông tin sức khỏe.

### 🏋️ 2. Danh sách bài tập
- Hiển thị danh sách các bài tập theo **các nhóm cơ** (ngực, lưng, chân, vai...).
- Hình ảnh minh họa và hướng dẫn chi tiết từng bài tập.
- Tính năng **bắt đầu tập luyện** với bộ đếm thời gian và số lần lặp.

### 📆 3. Lịch trình tập luyện
- Tạo **kế hoạch tập luyện** theo ngày, tuần.
- Nhắc nhở tập luyện qua **thông báo**.
- Lưu trữ và cập nhật tiến trình tập luyện hàng ngày.

### 📊 4. Theo dõi sức khỏe
- Ghi lại các chỉ số như **cân nặng, BMI, số bước đi hàng ngày**.
- Biểu đồ theo dõi sự thay đổi của các chỉ số theo thời gian.

### 📷 5. Quản lý hình ảnh tiến trình tập luyện
- Người dùng có thể **chụp ảnh hoặc tải lên ảnh** trước & sau khi tập để so sánh tiến bộ.
- Hỗ trợ hiển thị lịch sử ảnh tập luyện theo ngày.

## 📂 Cấu trúc thư mục
```
DALTDD_fitness/
├── lib/                     # Mã nguồn chính
│   ├── main.dart            # Điểm khởi đầu ứng dụng
│   ├── pages/               # Các trang giao diện
│   │   ├── login_page.dart  # Trang đăng nhập
│   │   ├── dashboard.dart   # Màn hình chính
│   │   ├── workout_page.dart# Danh sách bài tập
│   │   ├── profile_page.dart# Hồ sơ cá nhân
│   ├── widgets/             # Các widget tái sử dụng
│   ├── models/              # Các model dữ liệu
├── assets/                  # Chứa hình ảnh, icon
├── pubspec.yaml             # Cấu hình dependencies
├── README.md                # Hướng dẫn sử dụng
```

## 🛠 Công nghệ sử dụng
- **Flutter** (Dart) - Framework chính để phát triển ứng dụng.
- **Firebase Authentication** - Để đăng nhập và quản lý tài khoản.
- **SQLite** - Cơ sở dữ liệu cục bộ để lưu trữ bài tập và lịch sử luyện tập.
- **Provider** - Quản lý trạng thái ứng dụng.
- **SharedPreferences** - Lưu trữ dữ liệu tạm thời như chế độ dark mode, lịch sử đăng nhập.

## 🔧 Cài đặt & Chạy ứng dụng

### 1️⃣ Cài đặt Flutter SDK
Nếu chưa có, hãy cài đặt Flutter theo hướng dẫn tại: [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)

### 2️⃣ Clone dự án
```bash
git clone https://github.com/totgokhung123/daltdd.git
cd daltdd
```

### 3️⃣ Cài đặt dependencies
```bash
flutter pub get
```

### 4️⃣ Chạy ứng dụng
```bash
flutter run
```

> **Lưu ý**: Nếu chạy trên thiết bị thật, cần bật chế độ **Developer Mode** và **USB Debugging**.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
## 🎨 Hình ảnh giao diện
#Preview demo:
![image](https://github.com/user-attachments/assets/ea978214-a844-43d6-a5b1-c04c395dd2c5)
![image](https://github.com/user-attachments/assets/215a7ae7-798d-4a11-8734-b988668bb934)
![image](https://github.com/user-attachments/assets/bb8f44f8-9d76-4b48-9f0c-6aa12ebc9f5b)
![image](https://github.com/user-attachments/assets/df31aaab-3ddd-4420-8810-270d06887b7b)
![image](https://github.com/user-attachments/assets/68c8e557-526e-4964-a029-13e7eeec754a)
![image](https://github.com/user-attachments/assets/80e1be8f-a004-41cb-99d0-b38866f6c25c)
![image](https://github.com/user-attachments/assets/88470653-c19f-49c5-a919-30bcddc7c922)
![image](https://github.com/user-attachments/assets/ca6e0e8a-a6d5-401a-8647-2b509116d924)
![image](https://github.com/user-attachments/assets/54b2662d-05dd-42cf-b49f-0bcaeebb3840)
![image](https://github.com/user-attachments/assets/d90df9e2-37dc-4b96-88f1-68c12f8fc384)
![image](https://github.com/user-attachments/assets/8a9fe5fb-4e02-4d43-9b27-383df5c5ac5a)
![image](https://github.com/user-attachments/assets/f84575f8-7bba-4e12-b24c-4724ea194f39)
![image](https://github.com/user-attachments/assets/f3455e40-f8db-4a5b-8796-1c62d18355db)
![image](https://github.com/user-attachments/assets/64e4af40-a66b-4605-ac38-9841cfefb705)
![image](https://github.com/user-attachments/assets/062ed3bc-ed4b-4cdd-a4e8-0dfc295f5dbf)

