import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart'; // Thêm thư viện quét mã vạch
import 'package:fitness/ApiService.dart'; // Đảm bảo import dịch vụ API
import 'dart:convert';
import 'package:http/http.dart' as http;

class scantest extends StatefulWidget {
  final String userId;
  final int mealTypeId;
  final DateTime ngay;

  const scantest({
    Key? key,
    required this.userId,
    required this.mealTypeId,
    required this.ngay,
  }) : super(key: key);

  @override
  _scantestState createState() => _scantestState();
}

class _scantestState extends State<scantest> {
  int quantity = 1;
  List<Map<String, dynamic>> foods = [];
  Map<String, dynamic>? selectedFood;

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

  Future<void> _scanBarcode() async {
    try {
      // Quét mã vạch
      var result = await BarcodeScanner.scan();
      String barcode = result.rawContent;

      if (barcode.isNotEmpty) {
        // Gửi yêu cầu xử lý mã vạch đến server
        final response = await http.post(
          Uri.parse('http://10.0.2.2/handle_barcode.php'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'barcode': barcode,
            'user_id': widget.userId,
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          if (data['status'] == 'found') {
            // Mã vạch đã tồn tại -> Chọn thực phẩm này
            setState(() {
              selectedFood = foods.firstWhere(
                    (food) => food['id'] == data['food_id'],
              );
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Food selected: ${selectedFood!['name']}')),
            );
          } else if (data['status'] == 'added') {
            // Mã vạch mới -> Thêm thực phẩm mới vào danh sách
            setState(() {
              foods.add(data['new_food']);
              selectedFood = data['new_food'];
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('New food added: ${selectedFood!['name']}')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to handle barcode.')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error scanning barcode: $e')),
      );
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
      Navigator.pop(context, true); // Quay lại trang trước
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
                  subtitle: Text(
                      'Calories: ${food['calories_per_unit']} | Protein: ${food['protein']} | Carbs: ${food['carbs']} | Fat: ${food['fat']}'),
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
          ElevatedButton.icon(
            onPressed: _scanBarcode,
            icon: Icon(Icons.qr_code_scanner),
            label: Text("Scan Barcode"),
          ),
        ],
      ),
    );
  }
}
