import 'package:flutter/material.dart';
import 'package:fitness/ApiService.dart'; // Đảm bảo import dịch vụ API
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:barcode_scan2/barcode_scan2.dart';
class te extends StatefulWidget {
  final String userId;
  final int mealTypeId;
  final DateTime ngay;

  const te({
    Key? key,
    required this.userId,
    required this.mealTypeId,
    required this.ngay,
  }) : super(key: key);

  @override
  _teState createState() => _teState();
}

class _teState extends State<te> {
  int quantity = 1;
  List<Map<String, dynamic>> foods = [];
  Map<String, dynamic>? selectedFood;
  String? _barcode;
  Map<String, dynamic>? _foodData;
  bool _isLoading = false;
  String _errorMessage = "";
  @override
  void initState() {
    super.initState();
    fetchFoods();
  }

  Future<void> fetchFoods() async {
    final response = await http.get(Uri.parse('http://10.0.2.2/food.php'));
    if (response.statusCode == 200) {
      setState(() {
        foods = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        foods = foods.map((food) {
          food['id'] = int.parse(food['id'].toString());
          return food;
        }).toList();
      });
    } else {
      print('Failed to fetch foods');
    }
  }
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
  void addFood() async {
    if (selectedFood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a food')),
      );
      return;
    }
    final caloriesPerUnit = double.parse(selectedFood!['calories_per_unit']);
    final caloriesTotal = (caloriesPerUnit * quantity).toString();
    try {
      await ApiService().addMealSchedule(
        user_id: widget.userId,
        type_meal_id: widget.mealTypeId.toString(),
        food_id: selectedFood!['id'],
        quantity: quantity.toInt(),
        Ngay: widget.ngay,
        calories_total: caloriesTotal,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Food added successfully')),
      );
      Navigator.pop(context,true); // Quay lại trang trước
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add food: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Food'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: addFood,
          ),
        ],
      ),
      body: foods.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: foods.length,
              itemBuilder: (context, index) {
                final food = foods[index];
                final isSelected = selectedFood != null && selectedFood!['id'] == food['id'];
                return ListTile(
                  title: Text(food['name']),
                  subtitle: Text('Calories: ${food['calories_per_unit']}' + '| protein: ${food['protein']}'+ '| carbs: ${food['carbs']}'+ '| fat: ${food['fat']}'),
                  trailing: Checkbox(
                    value: isSelected,
                    onChanged: (value) {
                      setState(() {
                        selectedFood = value == true ? food : null;
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      selectedFood = food;
                    });
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Quantity: $quantity'),
                Expanded(
                  child: Slider(
                    value: quantity.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: quantity.toString(),
                    onChanged: (value) {
                      setState(() {
                        quantity = value.toInt();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
