import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

void main() {
  runApp(FinancialDashboard());
}

class FinancialDashboard extends StatelessWidget {
  const FinancialDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: DashboardScreen(),
    );
  }
}