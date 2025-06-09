import 'package:flutter/material.dart';

class FaqView extends StatelessWidget {
  final faqs = {
    "What is TheraPalsy?": "TheraPalsy is an application...",
    "How does the TheraPalsy app work?": "It uses intelligent algorithms...",
    // Add more as needed
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("FAQ")),
      body: ListView(
        children: faqs.entries.map((e) {
          return ExpansionTile(
            title: Text(e.key),
            children: [Padding(padding: EdgeInsets.all(8), child: Text(e.value))],
          );
        }).toList(),
      ),
    );
  }
}
