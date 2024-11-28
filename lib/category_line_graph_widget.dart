// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';

// class CategoryLineGraphWidget extends StatelessWidget {
//   final String title;
//   final Map<String, double> monthlyData;
//   final List<String> months;
//   final double totalSpent;

//   const CategoryLineGraphWidget({
//     Key? key,
//     required this.title,
//     required this.monthlyData,
//     required this.months,
//     required this.totalSpent,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.all(16),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildHeader(),
//             const SizedBox(height: 16),
//             _buildLineChart(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         Text(
//           'Total Spent: ₹${totalSpent.toStringAsFixed(2)}',
//           style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//         ),
//       ],
//     );
//   }

//   Widget _buildLineChart() {
//     // Safeguard for empty data
//     if (monthlyData.isEmpty) {
//       return const Center(
//         child: Text(
//           'No data available',
//           style: TextStyle(fontSize: 16, color: Colors.grey),
//         ),
//       );
//     }

//     // Create a mapping of month labels to their indices
//     final List<String> monthKeys = months;
//     final spots = monthlyData.entries.map((entry) {
//       final monthIndex = monthKeys.indexOf(entry.key); // Find the index of the month
//       if (monthIndex == -1) return null; // Skip if month is not found in the list
//       return FlSpot(monthIndex.toDouble(), entry.value);
//     }).whereType<FlSpot>().toList();

//     return Container(
//       height: 200,
//       width: double.infinity,
//       margin: const EdgeInsets.symmetric(horizontal: 8.0), // Add padding to the graph
//       child: LineChart(
//         LineChartData(
//           minX: 0,
//           maxX: (monthKeys.length - 1).toDouble(),
//           minY: 0,
//           maxY: monthlyData.values.reduce((a, b) => a > b ? a : b) * 1.2,
//           titlesData: FlTitlesData(
//             leftTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 reservedSize: 40, // Adds space for the left titles
//                 getTitlesWidget: (value, meta) {
//                   return Text(
//                     value.toInt().toString(),
//                     style: const TextStyle(fontSize: 12),
//                   );
//                 },
//               ),
//             ),
//             bottomTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 reservedSize: 32, // Adds space for bottom titles
//                 getTitlesWidget: (value, meta) {
//                   final index = value.toInt();
//                   if (index >= 0 && index < monthKeys.length) {
//                     return Text(
//                       monthKeys[index],
//                       style: const TextStyle(fontSize: 10),
//                     );
//                   }
//                   return const Text('');
//                 },
//               ),
//             ),
//           ),
//           borderData: FlBorderData(
//             show: true,
//             border: const Border(
//               left: BorderSide(color: Colors.grey, width: 0.5),
//               bottom: BorderSide(color: Colors.grey, width: 0.5),
//             ),
//           ),
//           gridData: FlGridData(show: true),
//           lineBarsData: [
//             LineChartBarData(
//               spots: spots,
//               isCurved: true,
//               gradient: const LinearGradient(
//                 colors: [Colors.blue, Colors.lightBlue],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//               barWidth: 2,
//               isStrokeCapRound: true,
//               belowBarData: BarAreaData(
//                 show: true,
//                 gradient: LinearGradient(
//                   colors: [Colors.blue.withOpacity(0.3), Colors.lightBlue.withOpacity(0.1)],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CategoryLineGraphWidget extends StatelessWidget {
  final String title;
  final Map<String, double> monthlyData;
  final List<String> months;
  final double totalSpent;

  const CategoryLineGraphWidget({
    Key? key,
    required this.title,
    required this.monthlyData,
    required this.months,
    required this.totalSpent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
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
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          'Total Spent: ₹${totalSpent.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
        ),
      ],
    );
  }

  Widget _buildLineChart() {
    // Safeguard for empty data
    if (monthlyData.isEmpty) {
      return const Center(
        child: Text(
          'No data available',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    final spots = months.asMap().entries.map((entry) {
      int monthIndex = entry.key;
      String month = entry.value;
      double value = monthlyData[month] ?? 0.0;
      return FlSpot(monthIndex.toDouble(), value);
    }).toList();

    return Container(
      height: 200,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (months.length - 1).toDouble(),
          minY: 0,
          maxY: monthlyData.values.reduce((a, b) => a > b ? a : b) * 1.2,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 12),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < months.length) {
                    return Text(
                      months[index].substring(5), // Show only month part
                      style: const TextStyle(fontSize: 10),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              left: BorderSide(color: Colors.grey, width: 0.5),
              bottom: BorderSide(color: Colors.grey, width: 0.5),
            ),
          ),
          gridData: FlGridData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              gradient: const LinearGradient(
                colors: [Colors.blue, Colors.lightBlue],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              barWidth: 2,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [Colors.blue.withOpacity(0.3), Colors.lightBlue.withOpacity(0.1)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}