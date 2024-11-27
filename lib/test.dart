import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:excel/excel.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart'; // Import the fl_chart package for the PieChart

void main() {
  runApp(FinancialDashboard());
}

class FinancialDashboard extends StatelessWidget {
  const FinancialDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true), // Enable Material 3 design
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double totalSpending1 = 0;
  double totalSpending2 = 0;
  double monthlyLimit = 50000; // Example monthly expense limit
  double progress1 = 0;
  double progress2 = 0;

  // Data for the Pie Chart
  List<Map<String, dynamic>> categoryData = [
    {"title": "Category 1", "spent": 500},
    {"title": "Category 2", "spent": 9000},
    {"title": "Category 3", "spent": 12000},
    {"title": "Category 4", "spent": 8000},
  ];

  @override
  void initState() {
    super.initState();
    loadLocalExcelFile();
  }

  // Function to load the local Excel file
  Future<void> loadLocalExcelFile() async {
    try {
      ByteData data = await rootBundle.load('assets/Book1.xlsx');
      Uint8List bytes = data.buffer.asUint8List();
      var excel = Excel.decodeBytes(bytes);

      // Assume the data is in the first sheet
      var sheet = excel.tables[excel.tables.keys.first]!;

      // Read column data
      List<double> column1 = await readColumnData(sheet, 0); // First column
      List<double> column2 = await readColumnData(sheet, 1); // Second column

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

  Future<List<double>> readColumnData(var sheet, int columnIndex) async {
    List<double> columnData = [];

    for (var row in sheet.rows.skip(1)) {
      // Skip the header row
      var cellValue = row[columnIndex]?.value;
      if (cellValue != null) {
        columnData.add(double.tryParse(cellValue.toString()) ?? 0.0);
      }
    }
    return columnData;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Financial Dashboard'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Dashboard'),
              Tab(text: 'Charts'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Dashboard Tab
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SpendingWidget(
                    title: "Category 1",
                    totalSpending: totalSpending1,
                    progress: progress1,
                    monthlyLimit: monthlyLimit,
                    currentStatus: "Ongoing",
                    predictedAmount: 52000,
                    rewardPoints: 5,
                  ),
                  SizedBox(height: 16),
                  SpendingWidget(
                    title: "Category 2",
                    totalSpending: totalSpending2,
                    progress: progress2,
                    monthlyLimit: monthlyLimit,
                    currentStatus: "Stable",
                    predictedAmount: 48000,
                    rewardPoints: 10,
                  ),
                ],
              ),
            ),
            // Pie Chart Tab
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: PieChartWidget(categoryData: categoryData),
            ),
          ],
        ),
      ),
    );
  }
}

class SpendingWidget extends StatefulWidget {
  final String title;
  final double totalSpending;
  final double progress;
  final double monthlyLimit;
  final String currentStatus;
  final double predictedAmount;
  final int rewardPoints;

  const SpendingWidget({
    super.key,
    required this.title,
    required this.totalSpending,
    required this.progress,
    required this.monthlyLimit,
    required this.currentStatus,
    required this.predictedAmount,
    required this.rewardPoints,
  });

  @override
  _SpendingWidgetState createState() => _SpendingWidgetState();
}

class _SpendingWidgetState extends State<SpendingWidget>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: GestureDetector(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: Card(
          elevation: 3,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: isExpanded ? buildExpandedContent() : buildCollapsedContent(),
          ),
        ),
      ),
    );
  }

  Widget buildCollapsedContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        Icon(Icons.expand_more),
      ],
    );
  }

  Widget buildExpandedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Icon(Icons.expand_less),
          ],
        ),
        SizedBox(height: 8),
        Text(
          "Total Spending: ₹${widget.totalSpending.toStringAsFixed(2)}",
          style: TextStyle(fontSize: 14),
        ),
        LinearPercentIndicator(
          lineHeight: 12,
          percent: widget.progress.clamp(0.0, 1.0),
          center: Text(
            "${(widget.progress * 100).clamp(0, 100).toStringAsFixed(1)}%",
            style: TextStyle(fontSize: 10, color: Colors.white),
          ),
          progressColor: Colors.green,
          backgroundColor: Colors.grey[300],
          barRadius: Radius.circular(8),
        ),
        Text(
          "Current Status: ${widget.currentStatus}",
          style: TextStyle(fontSize: 14),
        ),
        Text(
          "Predicted Amount: ₹${widget.predictedAmount.toStringAsFixed(2)}",
          style: TextStyle(fontSize: 14),
        ),
        Text(
          "Reward: ${widget.rewardPoints} pts",
          style: TextStyle(fontSize: 14, color: Colors.blue),
        ),
      ],
    );
  }
}

class PieChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> categoryData;

  const PieChartWidget({super.key, required this.categoryData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 60,
                sections: _getPieSections(),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: _buildLegend(),
        ),
      ],
    );
  }

  List<PieChartSectionData> _getPieSections() {
    return categoryData.asMap().entries.map((entry) {
      int index = entry.key;
      Map<String, dynamic> data = entry.value;
      return PieChartSectionData(
        color: _getCategoryColor(index),
        value: data['spent'].toDouble(),
        title: "",
        radius: 80,
      );
    }).toList();
  }

  Widget _buildLegend() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: categoryData.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, dynamic> data = entry.value;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                color: _getCategoryColor(index),
              ),
              SizedBox(width: 8),
              Text(
                "${data['title']}: ₹${data['spent']}",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _getCategoryColor(int index) {
    const List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
    ];
    return colors[index % colors.length];
  }
}
