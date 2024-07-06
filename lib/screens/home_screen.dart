import 'package:flutter/material.dart';
import 'stock_update_screen.dart';
import 'stock_prediction_screen.dart';
import 'shelf_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inventory App',
          style: TextStyle(
            fontFamily: 'Roboto', // Example of using a custom font
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueGrey[800], // Darker app bar color
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 1,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StockUpdateScreen()),
                  );
                },
                icon: Icon(Icons.update), // Icon added for visual interest
                label: Text(
                  'Stock Update',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Text color
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey[700], // Button color
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50), // Increased padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Added spacing between buttons
            Flexible(
              flex: 1,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StockPredictionScreen()),
                  );
                },
                icon: Icon(Icons.timeline), // Icon added for visual interest
                label: Text(
                  'Stock Prediction',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Text color
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey[700], // Button color
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50), // Increased padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Added spacing between buttons
            Flexible(
              flex: 1,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShelfScreen()),
                  );
                },
                icon: Icon(Icons.storage), // Icon added for visual interest
                label: Text(
                  'Shelf Placement',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Text color
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey[700], // Button color
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50), // Increased padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.blueGrey[100], // Background color
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}



