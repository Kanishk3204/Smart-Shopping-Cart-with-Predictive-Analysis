

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShelfScreen extends StatefulWidget {
  @override
  _ShelfScreenState createState() => _ShelfScreenState();
}

class _ShelfScreenState extends State<ShelfScreen> {
  List<List<String>> groupsData = [];
  List<List<int>> shelfPlacementData = [];

  Future<void> fetchDataFromSheets() async {
    final groupsUrl =
        'https://script.google.com/macros/s/AKfycbxBqyyLhaDnWYdsyJhTeonZCxYCM6lx5iMJNHAIrFpZXw4FMjOZMcx-gjdxfTDW2W5Z/exec?data=true&sheetNames=group_sheet';
    final shelfPlacementUrl =
        'https://script.google.com/macros/s/AKfycbxBqyyLhaDnWYdsyJhTeonZCxYCM6lx5iMJNHAIrFpZXw4FMjOZMcx-gjdxfTDW2W5Z/exec?data=true&sheetNames=matrix_sheet';

    final groupsResponse = await http.get(Uri.parse(groupsUrl));
    final shelfPlacementResponse = await http.get(Uri.parse(shelfPlacementUrl));

    if (groupsResponse.statusCode == 200 && shelfPlacementResponse.statusCode == 200) {
      final Map<String, dynamic> groupsJson = json.decode(groupsResponse.body);
      final Map<String, dynamic> shelfPlacementJson = json.decode(shelfPlacementResponse.body);

      setState(() {
        groupsData = (groupsJson['group_sheet'] as List)
            .map((group) => List<String>.from(group))
            .toList();
        shelfPlacementData = (shelfPlacementJson['matrix_sheet'] as List)
            .map((row) => List<int>.from(row))
            .toList();
      });
    } else {
      // Handle error
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDataFromSheets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shelf Placement'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Products Association',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: groupsData.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Group ${index + 1}',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          SizedBox(height: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: groupsData[index].map((member) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text('- $member'),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Optimal Shelf Placement',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [Colors.indigo[200]!, Colors.blue[200]!],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: DataTable(
                    headingRowColor: MaterialStateColor.resolveWith((states) => Colors.indigo[700]!),
                    dataRowColor: MaterialStateColor.resolveWith((states) => Colors.indigo[600]!),
                    dividerThickness: 2,
                    columns: [
                      DataColumn(label: Text('Level', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                      ...List.generate(
                        shelfPlacementData.length,
                            (index) =>
                            DataColumn(label: Text('Group ${index + 1}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                      ),
                    ],
                    rows: List.generate(
                      shelfPlacementData.isNotEmpty ? shelfPlacementData.first.length : 0,
                          (index) => DataRow(
                        cells: [
                          DataCell(_buildLevelLabel(index)),
                          ...List.generate(
                            shelfPlacementData.length,
                                (i) => DataCell(
                              Text(
                                shelfPlacementData[i][index].toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelLabel(int index) {
    if (index == 0) {
      return Text('Eye Level', style: TextStyle(color: Colors.white));
    } else if (index == 1) {
      return Text('Top Level', style: TextStyle(color: Colors.white));
    } else if (index == 2) {
      return Text('Bottom Level', style: TextStyle(color: Colors.white));
    }
    return SizedBox(); // Placeholder, adjust as needed
  }
}















