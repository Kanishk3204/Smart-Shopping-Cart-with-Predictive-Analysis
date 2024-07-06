import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StockUpdateScreen extends StatefulWidget {
  @override
  _StockUpdateScreenState createState() => _StockUpdateScreenState();
}

class _StockUpdateScreenState extends State<StockUpdateScreen> {
  List<Map<String, dynamic>> stockData = [];

  Future<void> fetchStockData() async {
    final response = await http.get(Uri.parse(
        'https://script.google.com/macros/s/AKfycbzKTK1HdarjvJ05NGltBA7SA2RppxZ-1hE5MZXyQdr2iGh6hB_F6Y8Kemc5qLD7-rW9/exec')); // Replace with your Google Sheets API URL
    if (response.statusCode == 200) {
      final List<dynamic> decodedData = json.decode(response.body);
      setState(() {
        stockData = decodedData.cast<Map<String, dynamic>>();
      });
    } else {
      throw Exception('Failed to load stock data');
    }
  }

  Future<void> updateStock(String productName, int newStock) async {
    final Uri url = Uri.parse(
        'https://script.google.com/macros/s/AKfycbzKTK1HdarjvJ05NGltBA7SA2RppxZ-1hE5MZXyQdr2iGh6hB_F6Y8Kemc5qLD7-rW9/exec'); // Replace with your update endpoint URL

    try {
      final response = await http.post(
        url,
        body: json.encode({'productName': productName, 'newStock': newStock}),
      );

      if (response.statusCode == 200) {
        // Successfully updated stock
        print('Stock updated successfully');
        // Refresh stock data after updating
        await fetchStockData();
      } else {
        // Failed to update stock
        print('Failed to update stock: ${response.statusCode}');
        throw Exception('Failed to update stock');
      }
    } catch (e) {
      // Error occurred during HTTP request
      print('Error updating stock: $e');
      throw Exception('Error updating stock');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchStockData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Stock Update',
          style: TextStyle(color: Colors.white), // Title color
        ),
        backgroundColor: Colors.blueGrey[800], // App bar color
      ),
      body: ListView.builder(
        itemCount: stockData.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            elevation: 3,
            child: ListTile(
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      stockData[index]['Product Name'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      initialValue: stockData[index]['Stock'].toString(),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Stock',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        int newStock = int.tryParse(value) ?? 0; // Provide a default value if parsed value is null
                        updateStock(stockData[index]['Product Name'], newStock);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      backgroundColor: Colors.blueGrey[100], // Background color
    );
  }
}

