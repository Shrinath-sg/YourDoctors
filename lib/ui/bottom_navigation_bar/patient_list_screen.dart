import 'package:flutter/material.dart';

class PatientListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Patient List"),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Work in Progress...',
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
