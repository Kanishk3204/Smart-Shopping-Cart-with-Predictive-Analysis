import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory App',
      theme: ThemeData(
        primaryColor: Colors.blue, // Example primary color
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green), // Example accent color
      ),
      home: HomeScreen(),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'screens/home_screen.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:async';

// void main() {
//   periodicCheck();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Inventory App',
//       theme: ThemeData(
//         primaryColor: Colors.blue, // Example primary color
//         colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green), // Example accent color
//       ),
//       home: HomeScreen(),
//     );
//   }
// }

// // Function to fetch stock data from server
// Future<List<Map<String, dynamic>>> fetchStockData() async {
//   final response = await http.get(Uri.parse('https://script.google.com/macros/s/AKfycbzKTK1HdarjvJ05NGltBA7SA2RppxZ-1hE5MZXyQdr2iGh6hB_F6Y8Kemc5qLD7-rW9/exec'));
//   if (response.statusCode == 200) {
//     final List<dynamic> decodedData = json.decode(response.body);
//     return decodedData.cast<Map<String, dynamic>>();
//   } else {
//     throw Exception('Failed to load stock data');
//   }
// }

// // Function to show notification
// Future<void> _showNotification(
//     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin, String title, String subtitle, String body) async {
//   try {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'your_channel_id', // Change to your own channel ID
//       'Your Channel Name', // Change to your own channel name
//       'Your Channel Description', // Change to your own channel description
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       body,
//       platformChannelSpecifics,
//       payload: subtitle,
//     );
//   } catch (e) {
//     print('Error showing notification: $e');
//   }
// }

// // Function to check stock levels and send notifications
// void checkStockAndSendNotifications() async {
//   try {
//     final List<Map<String, dynamic>> stockData = await fetchStockData();
//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     // Initialize the plugin
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     final InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);

//     // Check each product's stock level
//     for (var product in stockData) {
//       if (product['Stock'] < 10) {
//         // Product stock is below 10, send a notification
//         await _showNotification(
//             flutterLocalNotificationsPlugin, product['Product Name'], 'Stock Alert', 'Stock is low, refill soon');
//       }
//     }
//   } catch (e) {
//     print('Error checking stock and sending notifications: $e');
//   }
// }

// // Periodic task to check stock and send notifications
// void periodicCheck() {
//   try {
//     // Run the task every minute
//     const Duration interval = Duration(minutes: 1);
//     Timer.periodic(interval, (timer) {
//       checkStockAndSendNotifications();
//     });
//   } catch (e) {
//     print('Error setting up periodic check: $e');
//   }
// }
