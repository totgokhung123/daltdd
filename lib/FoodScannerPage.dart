import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FoodScannerPage extends StatefulWidget {
  @override
  _FoodScannerPageState createState() => _FoodScannerPageState();
}

class _FoodScannerPageState extends State<FoodScannerPage> {
  String? _barcode;
  Map<String, dynamic>? _foodData;
  bool _isLoading = false;
  String _errorMessage = "";

  /// Quét mã vạch
  Future<void> _scanBarcode() async {
    try {
      var result = await BarcodeScanner.scan();
      setState(() {
        _barcode = result.rawContent;
        _foodData = null; // Xóa dữ liệu trước đó
        _errorMessage = ""; // Reset lỗi
      });

      if (_barcode != null && _barcode!.isNotEmpty) {
        _fetchFoodData(_barcode!);
      } else {
        setState(() {
          _errorMessage = "Không nhận được mã vạch.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Quét mã vạch thất bại: $e";
      });
    }
  }

  /// Lấy thông tin thực phẩm từ Open Food Facts API
  Future<void> _fetchFoodData(String barcode) async {
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    final url = Uri.parse(
        'https://world.openfoodfacts.org/api/v0/product/$barcode.json');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          if (data['status'] == 1) {
            _foodData = data['product'];
          } else {
            _errorMessage = "Không tìm thấy dữ liệu cho mã vạch này.";
          }
        });
      } else {
        setState(() {
          _errorMessage =
          "Không thể lấy dữ liệu. Mã lỗi: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Lỗi khi lấy dữ liệu: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Food Scanner"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _scanBarcode,
              child: Text("Quét mã vạch"),
            ),
            SizedBox(height: 20),
            if (_isLoading) ...[
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text("Đang tìm kiếm dữ liệu..."),
            ] else if (_errorMessage.isNotEmpty) ...[
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ] else if (_foodData != null) ...[
              Text(
                  "Tên sản phẩm: ${_foodData!['product_name'] ?? 'Không xác định'}"),
              Text("Mô tả: ${_foodData!['generic_name'] ?? 'Không có mô tả'}"),
              Text(
                "Carbs: ${_foodData!['nutriments']?['carbohydrates_100g'] ?? 'Không rõ'} g",
              ),
              Text(
                "Chất béo: ${_foodData!['nutriments']?['fat_100g'] ?? 'Không rõ'} g",
              ),
              Text(
                "Chất đạm: ${_foodData!['nutriments']?['proteins_100g'] ?? 'Không rõ'} g",
              ),
              if (_foodData!['image_url'] != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(_foodData!['image_url']),
                ),
            ] else if (_barcode != null) ...[
              Text("Không tìm thấy sản phẩm cho mã vạch $_barcode."),
            ],
          ],
        ),
      ),
    );
  }
}