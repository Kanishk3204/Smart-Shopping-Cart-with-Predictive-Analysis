import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StockPredictionScreen extends StatefulWidget {
  @override
  _StockPredictionScreenState createState() => _StockPredictionScreenState();
}

class _StockPredictionScreenState extends State<StockPredictionScreen> {
  List<Map<String, dynamic>> salesData = [];
  Map<String, int> nextWeekQuantities = {};

  Future<void> fetchSalesData() async {
    try {
      final response = await http.get(Uri.parse('https://script.google.com/macros/s/AKfycbwA2zjJvUkZN6lakGqetG6SrGmLii_100L1e-KVZ2gkIVUnmosPPY_r75GgoCvqw1kHTw/exec?data=true'));
      if (response.statusCode == 200) {
        setState(() {
          salesData = (json.decode(response.body) as List<dynamic>).cast<Map<String, dynamic>>();
          nextWeekQuantities = calculateNextWeekQuantities(salesData);
          // Remove the item with quantity 0
          nextWeekQuantities.removeWhere((key, value) => value == 0);
        });
      } else {
        throw Exception('Failed to load sales data');
      }
    } catch (e) {
      print('Error fetching sales data: $e');
    }
  }

  Map<String, int> calculateNextWeekQuantities(List<Map<String, dynamic>> salesData) {
    Map<String, int> nextWeekQuantities = {};

    for (var sale in salesData) {
      String product = sale['name'];
      // Parse 'quantity' field as an integer using tryParse
      int quantitySold = int.tryParse(sale['quantity'].toString()) ?? 0; // Defaulting to 0 if parsing fails
      // Adjust the expected demand for next week
      int expectedDemand = (quantitySold * 1.1).ceil();
      // Add a safety margin
      int requiredQuantity = (expectedDemand * 1.2).ceil();
      // Update or add the product's required quantity
      nextWeekQuantities.update(
        product,
            (value) => value + requiredQuantity,
        ifAbsent: () => requiredQuantity,
      );
    }
    return nextWeekQuantities;
  }

  @override
  void initState() {
    super.initState();
    fetchSalesData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Stock Prediction',
          style: TextStyle(
            fontFamily: 'Roboto', // Example of using a custom font
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueGrey[800], // Darker app bar color
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Next Week\'s Stock Requirements:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: nextWeekQuantities.length,
              itemBuilder: (context, index) {
                String product = nextWeekQuantities.keys.elementAt(index);
                int quantity = nextWeekQuantities.values.elementAt(index);
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(product, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text('Quantity: $quantity', style: TextStyle(fontSize: 16)),
                    leading: Icon(Icons.shopping_cart),
                    // Removed the trailing property
                  ),
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.blueGrey[100], // Background color
    );
  }
}




