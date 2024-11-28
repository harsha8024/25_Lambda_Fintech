import 'package:flutter/material.dart';

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