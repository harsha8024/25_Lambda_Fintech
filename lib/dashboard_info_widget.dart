import 'package:flutter/material.dart';

class DashboardInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            _buildInfoRow("Username", username),
            _buildInfoRow("Points", points),
            _buildInfoRow("Individual Rank", individualRank),
            _buildInfoRow("Best Month", bestMonth),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          "$label: ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value),
      ],
    );
  }
}