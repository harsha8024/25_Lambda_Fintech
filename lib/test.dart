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
  String username = "John Doe";
  String points = "1200";
  String individualRank = "2";
  String bestMonth = "August 2024";
  

  // Updated categoryData with user-specific information
  List<Map<String, dynamic>> categoryData = [
    {
      "title": "Category 1", 
      "spent": 500,
      "monthlyData": [100.0, 200.0, 300.0, 400.0, 500.0, 600.0],
      "users": [
        {
          "username": "johndoe",
          "points": 150,
          "monthlySpending": [120.0, 180.0, 220.0, 300.0, 400.0, 500.0]
        },
        {
          "username": "janedoe",
          "points": 120,
          "monthlySpending": [80.0, 150.0, 200.0, 250.0, 350.0, 450.0]
        }
      ]
    },
    {
      "title": "Category 2", 
      "spent": 9000,
      "monthlyData": [1500.0, 2000.0, 3000.0, 4000.0, 5000.0, 9000.0],
      "users": [
        {
          "username": "alicesmith",
          "points": 200,
          "monthlySpending": [1200.0, 1800.0, 2500.0, 3500.0, 4500.0, 9000.0]
        },
        {
          "username": "bobwilson",
          "points": 180,
          "monthlySpending": [1000.0, 1500.0, 2000.0, 3000.0, 4000.0, 8000.0]
        }
      ]
    },
    {
      "title": "Category 3", 
      "spent": 12000,
      "monthlyData": [2000.0, 4000.0, 6000.0, 8000.0, 10000.0, 12000.0],
      "users": [
        {
          "username": "charliebrown",
          "points": 180,
          "monthlySpending": [1800.0, 3500.0, 5500.0, 7500.0, 9500.0, 12000.0]
        },
        {
          "username": "davidlee",
          "points": 160,
          "monthlySpending": [1500.0, 3000.0, 5000.0, 7000.0, 9000.0, 11000.0]
        }
      ]
    },
  ];

  // Leaderboard Data Extraction Method
  List<Map<String, String>> extractLeaderboardData() {
  // Collect all users across categories
  List<Map<String, dynamic>> allUsers = [];
  for (var category in categoryData) {
    allUsers.addAll(category['users']);
  }

  // Sort users by points in descending order
  allUsers.sort((a, b) => (b['points'] as int).compareTo(a['points'] as int));

  // Convert to leaderboard format with ranks
  return List.generate(allUsers.length, (index) => {
    'Rank': (index + 1).toString(),
    'Name': allUsers[index]['username'],
    'Points': allUsers[index]['points'].toString()
  });
}

  // ... existing loadLocalExcelFile method remains the same

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Updated to 3 tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Financial Dashboard'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Dashboard'),
              Tab(text: 'Charts'),
              Tab(text: 'Leaderboard'), // New Leaderboard tab
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
                  _buildDashboardInfo(),


                  SizedBox(height: 16),
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
            // Leaderboard Tab
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: LeaderboardWidget(leaderboardData: extractLeaderboardData()),
            ),
          ],
        ),
      ),
    );
  }
}
Widget _buildDashboardInfo() {
  String username = "John Doe";
  String points = "1200";
  String individualRank = "2";
  String bestMonth = "August 2024";
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Dashboard Info",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  "Username: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(username),
              ],
            ),
            Row(
              children: [
                Text(
                  "Points: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(points),
              ],
            ),
            Row(
              children: [
                Text(
                  "Individual Rank: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(individualRank),
              ],
            ),
            Row(
              children: [
                Text(
                  "Best Month: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(bestMonth),
              ],
            ),
          ],
        ),
      ),
    );
}

class SpendingWidget extends StatefulWidget {
  final String title;
  final double totalSpending;
  final double monthlyLimit;
  final String currentStatus;
  final double predictedAmount;
  final int rewardPoints;

  const SpendingWidget({
    super.key,
    required this.title,
    required this.totalSpending,
    required this.monthlyLimit,
    required this.currentStatus,
    required this.predictedAmount,
    required this.rewardPoints, required double progress,
  });

  @override
  _SpendingWidgetState createState() => _SpendingWidgetState();
}

class _SpendingWidgetState extends State<SpendingWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: GestureDetector(
        onTap: () => setState(() => isExpanded = !isExpanded),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: isExpanded ? _buildExpandedContent() : _buildCollapsedContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsedContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        Icon(Icons.expand_more),
      ],
    );
  }

  Widget _buildExpandedContent() {
    final spendingDetails = [
      {"label": "Total Spending", "value": "₹${widget.totalSpending.toStringAsFixed(2)}"},
      {"label": "Current Status", "value": widget.currentStatus},
      {"label": "Predicted Amount", "value": "₹${widget.predictedAmount.toStringAsFixed(2)}"},
      {"label": "Reward", "value": "${widget.rewardPoints} pts"},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            Icon(Icons.expand_less),
          ],
        ),
        SizedBox(height: 8),
        ...spendingDetails.map((detail) => Text(
          "${detail['label']}: ${detail['value']}",
          style: TextStyle(fontSize: 14),
        )).toList(),
        LinearPercentIndicator(
          lineHeight: 12,
          percent: (widget.totalSpending / widget.monthlyLimit).clamp(0.0, 1.0),
          center: Text(
            "${((widget.totalSpending / widget.monthlyLimit) * 100).clamp(0, 100).toStringAsFixed(1)}%",
            style: TextStyle(fontSize: 10, color: Colors.white),
          ),
          progressColor: Colors.green,
          backgroundColor: Colors.grey[300],
          barRadius: Radius.circular(8),
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
    return ListView(
      children: [
        _buildPieChartSection(),
        ...categoryData.map((category) => CategoryLineGraphWidget(
          title: category['title'], 
          monthlyData: category['monthlyData'] ?? [],
          totalSpent: category['spent']
        )).toList(),
      ],
    );
  }

  Widget _buildPieChartSection() {
    return Container(
      height: 300,
      child: Column(
        children: [
          Expanded(
            flex: 4,
            child: PieChart(PieChartData(
              sectionsSpace: 4,
              centerSpaceRadius: 60,
              sections: _getPieSections(),
              borderData: FlBorderData(show: false),
            )),
          ),
          Expanded(
            flex: 1,
            child: _buildLegend(),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _getPieSections() {
    final colors = [Colors.red, Colors.blue, Colors.green, Colors.orange];
    return categoryData.asMap().entries.map((entry) {
      int index = entry.key;
      Map<String, dynamic> data = entry.value;
      return PieChartSectionData(
        color: colors[index % colors.length],
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
                width: 16, height: 16,
                color: _getPieSections()[index].color,
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
}

class CategoryLineGraphWidget extends StatelessWidget {
  final String title;
  final List<double> monthlyData;
  final double totalSpent;
  static const  List<String> _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];

  const CategoryLineGraphWidget({
    super.key, 
    required this.title, 
    required this.monthlyData,
    required this.totalSpent
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 16),
            _buildLineChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title, 
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
        ),
        Text(
          'Total Spent: ₹${totalSpent.toStringAsFixed(2)}', 
          style: TextStyle(fontSize: 14, color: Colors.grey[700])
        ),
      ],
    );
  }

  Widget _buildLineChart() {
    return Container(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) => Text(
                  _months[value.toInt() % _months.length],
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) => Text(
                  value.toStringAsFixed(0),
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: monthlyData.asMap().entries.map((entry) => 
                FlSpot(entry.key.toDouble(), entry.value)
              ).toList(),
              isCurved: true,
              color: Colors.blue,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class LeaderboardWidget extends StatelessWidget {
  final List<Map<String, String>> leaderboardData;
  
  const LeaderboardWidget({super.key, required this.leaderboardData});
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Leaderboard',
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 16),
              DataTable(
                columnSpacing: 20,
                columns: const [
                  DataColumn(label: Text('Rank', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Points', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: leaderboardData.map((entry) => DataRow(
                  cells: [
                    DataCell(Text(entry['Rank'] ?? '', style: TextStyle(fontWeight: FontWeight.w500))),
                    DataCell(Text(entry['Name'] ?? '', style: TextStyle(fontWeight: FontWeight.w500))),
                    DataCell(Text(
                      entry['Points'] ?? '', 
                      style: TextStyle(
                        fontWeight: FontWeight.w500, 
                        color: Colors.blue
                      ),
                    )),
                  ]
                )).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}