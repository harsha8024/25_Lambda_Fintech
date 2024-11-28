import 'dart:convert';
import 'package:flutter/services.dart';

class ExpenseDataLoader {
  static Future<Map<String, dynamic>> loadExpenseData() async {
    try {
      // Load the JSON file from assets
      String jsonString = await rootBundle.loadString('assets/expense_data.json');
      
      // Parse the JSON
      Map<String, dynamic> expenseData = json.decode(jsonString);
      
      return expenseData;
    } catch (e) {
      print('Error loading expense data: $e');
      return {};
    }
  }

  static List<Map<String, dynamic>> preparePieChartData(Map<String, dynamic> expenseData) {
    return expenseData.entries.map((entry) {
      return {
        'title': entry.key,
        'spent': entry.value['totalSpent']
      };
    }).toList();
  }

  static Map<String, Map<String, dynamic>> prepareLineGraphData(Map<String, dynamic> expenseData) {
    return expenseData.map((category, data) {
      return MapEntry(category, {
        'monthlyData': data['monthlyData'],
        'months': data['months'],
        'totalSpent': data['totalSpent']
      });
    });
  }
}