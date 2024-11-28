// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:csv/csv.dart';
// import 'dashboard_info_widget.dart';
// import 'spending_widget.dart';
// import 'pie_chart_widget.dart';
// import 'leaderboard_widget.dart';

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});

//   @override
//   _DashboardScreenState createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   double monthlyLimit = 50000;
//   List<Map<String, dynamic>> categoryData = [];
//   List<String> monthKeys = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     loadCategoryData();
//   }

//   Future<void> loadCategoryData() async {
//     try {
//       // Load CSV file
//       final csvData = await rootBundle.loadString('assets/grouped.csv');
//       List<List<dynamic>> rows = const CsvToListConverter().convert(csvData, eol: "\n");

//       // Convert the rows to a structured list
//       Map<String, Map<String, dynamic>> tempData = {};
//       Set<String> months = {};

//       for (int i = 1; i < rows.length; i++) {
//         final row = rows[i];
//         final month = row[0].toString().trim(); // Ensure month keys are consistent
//         final category = row[1].toString().trim();
//         final total = double.tryParse(row[2].toString()) ?? 0.0;

//         months.add(month);

//         if (!tempData.containsKey(category)) {
//           tempData[category] = {
//             "title": category,
//             "spent": 0.0, // Initialize spent as a double
//             "monthlyData": {},
//             "users": [], // This can be populated with user data later if needed
//           };
//         }
//         tempData[category]!["spent"] += total;
//         tempData[category]!["monthlyData"][month] = total;
//       }

//       // Sort months and update the state
//       setState(() {
//         categoryData = tempData.values.toList();
//         monthKeys = months.toList()..sort();
//         isLoading = false;
//       });
//     } catch (e) {
//       print("Error loading data: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   List<Map<String, String>> extractLeaderboardData() {
//     // You can populate this based on your user logic if needed
//     return [];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Financial Dashboard'),
//           bottom: const TabBar(
//             tabs: [
//               Tab(text: 'Dashboard'),
//               Tab(text: 'Charts'),
//               Tab(text: 'Leaderboard'),
//             ],
//           ),
//         ),
//         body: isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : categoryData.isEmpty
//                 ? const Center(
//                     child: Text(
//                       'No data available',
//                       style: TextStyle(fontSize: 16, color: Colors.grey),
//                     ),
//                   )
//                 : TabBarView(
//                     children: [
//                       // Dashboard Tab
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: SingleChildScrollView(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: categoryData.map((category) {
//                               return Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     category['title'],
//                                     style: const TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 8),
//                                   SpendingWidget(
//                                     title: category['title'],
//                                     totalSpending: category['spent'],
//                                     progress: category['spent'] / monthlyLimit,
//                                     monthlyLimit: monthlyLimit,
//                                     currentStatus: "Active",
//                                     predictedAmount: 0,
//                                     rewardPoints: 0,
//                                   ),
//                                   const SizedBox(height: 16),
//                                 ],
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                       ),

//                       // Charts Tab
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: PieChartWidget(categoryData: categoryData),
//                       ),

//                       // Leaderboard Tab
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: LeaderboardWidget(
//                           leaderboardData: extractLeaderboardData(),
//                         ),
//                       ),
//                     ],
//                   ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'dashboard_info_widget.dart';
import 'spending_widget.dart';
import 'pie_chart_widget.dart';
import 'leaderboard_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Different monthly limits for different categories
  final double monthlyLimitEntertainment = 12000;
  final double monthlyLimitFood = 11000;
  final double monthlyLimitTransport = 12500;
  final double monthlyLimitUtilities = 16500;

  Map<String, dynamic> categoryData = {};
  List<String> monthKeys = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCategoryData();
  }

  Future<void> loadCategoryData() async {
    try {
      // Load CSV file
      final csvData = await rootBundle.loadString('assets/grouped.csv');
      List<List<dynamic>> rows = const CsvToListConverter().convert(csvData, eol: "\n");

      // Convert the rows to a structured list
      Map<String, Map<String, dynamic>> tempData = {};
      Set<String> months = {};

      for (int i = 1; i < rows.length; i++) {
        final row = rows[i];
        final month = row[0].toString().trim();
        final category = row[1].toString().trim();
        final total = double.tryParse(row[2].toString()) ?? 0.0;

        months.add(month);

        if (!tempData.containsKey(category)) {
          tempData[category] = {
            "monthlyData": {},
            "months": [],
            "totalSpent": 0.0,
          };
        }
        tempData[category]!["totalSpent"] += total;
        tempData[category]!["monthlyData"][month] = total;
        tempData[category]!["months"].add(month);
      }

      setState(() {
        categoryData = tempData;
        monthKeys = months.toList()..sort();
        isLoading = false;
      });
    } catch (e) {
      print("Error loading data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  double getCategoryLimit(String category) {
    switch (category) {
      case 'Entertainment':
        return monthlyLimitEntertainment;
      case 'Food':
        return monthlyLimitFood;
      case 'Transportation':
        return monthlyLimitTransport;
      case 'Utilities':
        return monthlyLimitUtilities;
      default:
        return 10000; // Default limit for unknown categories
    }
  }

  List<Map<String, String>> extractLeaderboardData() {
    // Mock data for the leaderboard
    return [
      {"username": "Alice", "points": "1500"},
      {"username": "Bob", "points": "1300"},
      {"username": "John Doe", "points": "1200"},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Financial Dashboard'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Dashboard'),
              Tab(text: 'Charts'),
              Tab(text: 'Leaderboard'),
            ],
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : categoryData.isEmpty
                ? const Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : TabBarView(
                    children: [
                      // Dashboard Tab
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DashboardInfoWidget(), // User info at the top
                              const SizedBox(height: 16),
                              ...categoryData.entries.map((entry) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      entry.key,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    SpendingWidget(
                                      title: entry.key,
                                      totalSpending: entry.value['totalSpent'],
                                      progress: entry.value['totalSpent'] / getCategoryLimit(entry.key),
                                      monthlyLimit: getCategoryLimit(entry.key),
                                      currentStatus: "Ongoing",
                                      predictedAmount: getCategoryLimit(entry.key),
                                      rewardPoints: 5, // Placeholder for reward points logic
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),

                      // Charts Tab
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: PieChartWidget(categoryData: [categoryData]),
                      ),

                      // Leaderboard Tab
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: LeaderboardWidget(
                          leaderboardData: extractLeaderboardData(),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
