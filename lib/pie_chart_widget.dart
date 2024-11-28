// import 'dart:collection';

// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'category_line_graph_widget.dart';

// class PieChartWidget extends StatelessWidget {
//   final List<Map<String, dynamic>> categoryData;

//   const PieChartWidget({super.key, required this.categoryData});

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       children: [
//         _buildPieChartSection(),
//         ...categoryData.map((category) => CategoryLineGraphWidget(
//   title: category['title'].toString(),
//   monthlyData: (category['monthlyData'] as LinkedHashMap<dynamic, dynamic>)
//     .map((key, value) => MapEntry(key.toString(), (value ?? 0.0).toDouble())),
//   months: (category['months'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
//   totalSpent: (category['spent'] ?? 0.0).toDouble(),
// ),).toList(),
//       ],
//     );
//   }

//   Widget _buildPieChartSection() {
//     return Container(
//       height: 300,
//       child: Column(
//         children: [
//           Expanded(
//             flex: 4,
//             child: PieChart(PieChartData(
//               sectionsSpace: 4,
//               centerSpaceRadius: 60,
//               sections: _getPieSections(),
//               borderData: FlBorderData(show: false),
//             )),
//           ),
//           Expanded(
//             flex: 1,
//             child: _buildLegend(),
//           ),
//         ],
//       ),
//     );
//   }

//   List<PieChartSectionData> _getPieSections() {
//     final colors = [Colors.red, Colors.blue, Colors.green, Colors.orange];
//     return categoryData.asMap().entries.map((entry) {
//       int index = entry.key;
//       Map<String, dynamic> data = entry.value;
//       return PieChartSectionData(
//         color: colors[index % colors.length],
//         value: (data['spent']?.toDouble() ?? 0.0), // Convert spent to double
//         title: "",
//         radius: 80,
//       );
//     }).toList();
//   }

//   Widget _buildLegend() {
//     return ListView(
//       scrollDirection: Axis.horizontal,
//       children: categoryData.asMap().entries.map((entry) {
//         int index = entry.key;
//         Map<String, dynamic> data = entry.value;
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//           child: Row(
//             children: [
//               Container(
//                 width: 16, height: 16,
//                 color: _getPieSections()[index].color,
//               ),
//               SizedBox(width: 8),
//               Text(
//                 "${data['title']}: ₹${(data['spent']?.toDouble() ?? 0.0)}",  // Ensure spent is a double here as well
//                 style: TextStyle(fontSize: 12),
//               ),
//             ],
//           ),
//         );
//       }).toList(),
//     );
//   }
// }




import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'category_line_graph_widget.dart';

class PieChartWidget extends StatefulWidget {
  const PieChartWidget({super.key, required List<Map<String, dynamic>> categoryData});

  @override
  _PieChartWidgetState createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  Map<String, dynamic> categoryData = {};

  @override
  void initState() {
    super.initState();
    _loadCategoryData();
  }

  Future<void> _loadCategoryData() async {
    final String jsonString = await rootBundle.loadString('assets/linegraph.json');
    setState(() {
      categoryData = json.decode(jsonString);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (categoryData.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      children: [
        _buildPieChartSection(),
        ...categoryData.entries.map((entry) => CategoryLineGraphWidget(
              title: entry.key,
              monthlyData: Map<String, double>.from(entry.value['monthlyData']),
              months: List<String>.from(entry.value['months']),
              totalSpent: entry.value['totalSpent'],
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
    return categoryData.entries.toList().asMap().entries.map((entry) {
      int index = entry.key;
      MapEntry<String, dynamic> data = entry.value;
      return PieChartSectionData(
        color: colors[index % colors.length],
        value: (data.value['totalSpent']?.toDouble() ?? 0.0),
        title: "",
        radius: 80,
      );
    }).toList();
  }

  Widget _buildLegend() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: categoryData.entries.toList().asMap().entries.map((entry) {
        int index = entry.key;
        MapEntry<String, dynamic> data = entry.value;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Container(
                width: 16, height: 16,
                color: _getPieSections()[index].color,
              ),
              const SizedBox(width: 8),
              Text(
                "${data.key}: ₹${(data.value['totalSpent']?.toDouble() ?? 0.0).toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}