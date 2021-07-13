import 'package:YOURDRS_FlutterAPP/common/app_text.dart';
import 'package:flutter/material.dart';

class TransactionGroupSeparator extends StatelessWidget {
  final String locationName;
  int appointmentsCount;
  final String practice;
  TransactionGroupSeparator(
      {this.locationName, this.appointmentsCount, this.practice});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${this.locationName} - ${this.practice} - (${this.appointmentsCount}) ",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700),
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
