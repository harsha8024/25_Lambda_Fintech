// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:excel/excel.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';
// import 'package:file_picker/file_picker.dart';

// void main() {
//   runApp(FinancialDashboard());
// }

// class FinancialDashboard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: DashboardScreen(),
//     );
//   }
// }

// class DashboardScreen extends StatefulWidget {
//   @override
//   _DashboardScreenState createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   double totalSpending1 = 0;
//   double totalSpending2 = 0;
//   double monthlyLimit = 50000; // Example monthly expense limit
//   double progress1 = 0;
//   double progress2 = 0;

//   Future<void> pickExcelFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['xlsx'],
//     );

//     if (result != null) {
//       File file = File(result.files.single.path!);
//       var bytes = file.readAsBytesSync();
//       var excel = Excel.decodeBytes(bytes);

//       // Assume the data is in the first sheet
//       var sheet = excel.tables[excel.tables.keys.first]!;
//       List<double> column1 = [5,10,15];
//       List<double> column2 = [10,15,20];

//       for (var row in sheet.rows.skip(1)) {
//         // Adjust column indices (e.g., 0, 1) based on your Excel structure
//         column1.add(double.tryParse(row[0]?.value.toString() ?? '0') ?? 0);
//         column2.add(double.tryParse(row[1]?.value.toString() ?? '0') ?? 0);
//       }

//       setState(() {
//         totalSpending1 = column1.reduce((a, b) => a + b);
//         totalSpending2 = column2.reduce((a, b) => a + b);
//         progress1 = totalSpending1 / monthlyLimit;
//         progress2 = totalSpending2 / monthlyLimit;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Financial Dashboard'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.upload_file),
//             onPressed: pickExcelFile,
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: SpendingWidget(
//                 title: "Category 1",
//                 totalSpending: totalSpending1,
//                 progress: progress1,
//                 monthlyLimit: monthlyLimit,
//               ),
//             ),
//             Expanded(
//               child: SpendingWidget(
//                 title: "Category 2",
//                 totalSpending: totalSpending2,
//                 progress: progress2,
//                 monthlyLimit: monthlyLimit,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SpendingWidget extends StatelessWidget {
//   final String title;
//   final double totalSpending;
//   final double progress;
//   final double monthlyLimit;

//   SpendingWidget({
//     required this.title,
//     required this.totalSpending,
//     required this.progress,
//     required this.monthlyLimit,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Text(
//               "Total Spending: ₹${totalSpending.toStringAsFixed(2)}",
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 10),
//             LinearPercentIndicator(
//               lineHeight: 14,
//               percent: progress.clamp(0.0, 1.0),
//               center: Text(
//                 "${(progress * 100).clamp(0, 100).toStringAsFixed(1)}%",
//                 style: TextStyle(fontSize: 12, color: Colors.white),
//               ),
//               progressColor: Colors.green,
//               backgroundColor: Colors.grey[300],
//               barRadius: Radius.circular(10),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:excel/excel.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

void main() {
  runApp(FinancialDashboard());
}

class FinancialDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double totalSpending1 = 0;
  double totalSpending2 = 0;
  double monthlyLimit = 50000; // Example monthly expense limit
  double progress1 = 0;
  double progress2 = 0;

  @override
  void initState() {
    super.initState();
    loadLocalExcelFile();
  }

  // Function to load the local Excel file
  Future<void> loadLocalExcelFile() async {
    try {
      // Load the file from assets
      ByteData data = await rootBundle.load('assets/Book1.xlsx');
      Uint8List bytes = data.buffer.asUint8List();
      var excel = Excel.decodeBytes(bytes);

      // Assume the data is in the first sheet
      var sheet = excel.tables[excel.tables.keys.first]!;

      // Read column data
      List<double> column1 = await readColumnData(sheet, 0); // First column
      List<double> column2 = await readColumnData(sheet, 1); // Second column

      // Update the state with calculated data
      setState(() {
        totalSpending1 = column1.reduce((a, b) => a + b);
        totalSpending2 = column2.reduce((a, b) => a + b);
        progress1 = totalSpending1 / monthlyLimit;
        progress2 = totalSpending2 / monthlyLimit;
      });
    } catch (e) {
      print("Error loading Excel file: $e");
    }
  }

  // Function to read data from a column in the Excel sheet
  Future<List<double>> readColumnData(var sheet, int columnIndex) async {
    List<double> columnData = [];

    for (var row in sheet.rows.skip(1)) { // Skip the header row
      var cellValue = row[columnIndex]?.value;
      if (cellValue != null) {
        columnData.add(double.tryParse(cellValue.toString()) ?? 0.0);
      }
    }
    return columnData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Financial Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SpendingWidget(
                title: "Category 1",
                totalSpending: totalSpending1,
                progress: progress1,
                monthlyLimit: monthlyLimit,
              ),
            ),
            Expanded(
              child: SpendingWidget(
                title: "Category 2",
                totalSpending: totalSpending2,
                progress: progress2,
                monthlyLimit: monthlyLimit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SpendingWidget extends StatelessWidget {
  final String title;
  final double totalSpending;
  final double progress;
  final double monthlyLimit;

  SpendingWidget({
    required this.title,
    required this.totalSpending,
    required this.progress,
    required this.monthlyLimit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Total Spending: ₹${totalSpending.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            LinearPercentIndicator(
              lineHeight: 14,
              percent: progress.clamp(0.0, 1.0),
              center: Text(
                "${(progress * 100).clamp(0, 100).toStringAsFixed(1)}%",
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
              progressColor: Colors.green,
              backgroundColor: Colors.grey[300],
              barRadius: Radius.circular(10),
            ),
          ],
        ),
      ),
    );
  }
}
