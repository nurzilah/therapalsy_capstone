import 'package:flutter/material.dart';

class PrivacyPolicyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Privacy Policy")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: const [
            Text("• OVERVIEW\n\nTheraPalsy values your privacy...", style: TextStyle(height: 1.5)),
            SizedBox(height: 10),
            Text("• Information We Collect\n...", style: TextStyle(height: 1.5)),
            SizedBox(height: 10),
            Text("• Use Of Information\n...", style: TextStyle(height: 1.5)),
          ],
        ),
      ),
    );
  }
}
