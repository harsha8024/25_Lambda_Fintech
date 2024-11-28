// import 'package:flutter/material.dart';
// import 'package:percent_indicator/percent_indicator.dart';

// class SpendingWidget extends StatefulWidget {
//   final String title;
//   final double totalSpending;
//   final double monthlyLimit;
//   final String currentStatus;
//   final double predictedAmount;
//   final int rewardPoints;
//   final double progress;

//   const SpendingWidget({
//     super.key,
//     required this.title,
//     required this.totalSpending,
//     required this.monthlyLimit,
//     required this.currentStatus,
//     required this.predictedAmount,
//     required this.rewardPoints,
//     required this.progress,
//   });

//   @override
//   _SpendingWidgetState createState() => _SpendingWidgetState();
// }

// class _SpendingWidgetState extends State<SpendingWidget> {
//   bool isExpanded = false;

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedSize(
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//       child: GestureDetector(
//         onTap: () => setState(() => isExpanded = !isExpanded),
//         child: Card(
//           elevation: 3,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Title always displayed
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       widget.title,
//                       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                     ),
//                     Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 if (isExpanded) _buildExpandedContent() else _buildCollapsedContent(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCollapsedContent() {
//     return LinearPercentIndicator(
//       lineHeight: 12,
//       percent: (widget.totalSpending / widget.monthlyLimit).clamp(0.0, 1.0),
//       center: Text(
//         "${((widget.totalSpending / widget.monthlyLimit) * 100).clamp(0, 100).toStringAsFixed(1)}%",
//         style: const TextStyle(fontSize: 10, color: Colors.white),
//       ),
//       progressColor: Colors.green,
//       backgroundColor: Colors.grey[300],
//       barRadius: const Radius.circular(8),
//     );
//   }

//   Widget _buildExpandedContent() {
//     final spendingDetails = [
//       {"label": "Total Spending", "value": "₹${widget.totalSpending.toStringAsFixed(2)}"},
//       {"label": "Current Status", "value": widget.currentStatus},
//       {"label": "Predicted Amount", "value": "₹${widget.predictedAmount.toStringAsFixed(2)}"},
//       {"label": "Reward", "value": "${widget.rewardPoints} pts"},
//     ];

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         ...spendingDetails.map((detail) => Padding(
//           padding: const EdgeInsets.symmetric(vertical: 4.0),
//           child: Text(
//             "${detail['label']}: ${detail['value']}",
//             style: const TextStyle(fontSize: 14),
//           ),
//         )),
//         const SizedBox(height: 8),
//         LinearPercentIndicator(
//           lineHeight: 12,
//           percent: (widget.totalSpending / widget.monthlyLimit).clamp(0.0, 1.0),
//           center: Text(
//             "${((widget.totalSpending / widget.monthlyLimit) * 100).clamp(0, 100).toStringAsFixed(1)}%",
//             style: const TextStyle(fontSize: 10, color: Colors.white),
//           ),
//           progressColor: Colors.green,
//           backgroundColor: Colors.grey[300],
//           barRadius: const Radius.circular(8),
//         ),
//       ],
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SpendingWidget extends StatefulWidget {
  final String title;
  final double totalSpending;
  final double monthlyLimit;
  final String currentStatus;
  final double predictedAmount;
  final int rewardPoints;
  final double progress;

  const SpendingWidget({
    super.key,
    required this.title,
    required this.totalSpending,
    required this.monthlyLimit,
    required this.currentStatus,
    required this.predictedAmount,
    required this.rewardPoints,
    required this.progress,
  });

  @override
  SpendingWidgetState createState() => SpendingWidgetState();
}

class SpendingWidgetState extends State<SpendingWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: GestureDetector(
        onTap: () => setState(() => isExpanded = !isExpanded),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title always displayed
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                  ],
                ),
                const SizedBox(height: 8),
                if (isExpanded) buildExpandedContent() else buildCollapsedContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCollapsedContent() {
    return LinearPercentIndicator(
      lineHeight: 12,
      percent: (widget.totalSpending / widget.monthlyLimit).clamp(0.0, 1.0),
      center: Text(
        "${((widget.totalSpending / widget.monthlyLimit) * 100).clamp(0, 100).toStringAsFixed(1)}%",
        style: const TextStyle(fontSize: 10, color: Colors.white),
      ),
      progressColor: Colors.green,
      backgroundColor: Colors.grey[300],
      barRadius: const Radius.circular(8),
    );
  }

  Widget buildExpandedContent() {
    final spendingDetails = [
      {"label": "Total Spending", "value": "₹${widget.totalSpending.toStringAsFixed(2)}"},
      {"label": "Current Status", "value": widget.currentStatus},
      {"label": "Predicted Amount", "value": "₹${widget.predictedAmount.toStringAsFixed(2)}"},
      {"label": "Reward", "value": "${widget.rewardPoints} pts"},
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...spendingDetails.map((detail) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            "${detail['label']}: ${detail['value']}",
            style: const TextStyle(fontSize: 14),
          ),
        )),
        const SizedBox(height: 8),
        LinearPercentIndicator(
          lineHeight: 12,
          percent: (widget.totalSpending / widget.monthlyLimit).clamp(0.0, 1.0),
          center: Text(
            "${((widget.totalSpending / widget.monthlyLimit) * 100).clamp(0, 100).toStringAsFixed(1)}%",
            style: const TextStyle(fontSize: 10, color: Colors.white),
          ),
          progressColor: Colors.green,
          backgroundColor: Colors.grey[300],
          barRadius: const Radius.circular(8),
        ),
      ],
    );
  }
}