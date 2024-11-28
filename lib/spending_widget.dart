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