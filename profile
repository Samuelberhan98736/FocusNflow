import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: John Doe"),
            Text("Panther ID: 12345678"),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Settings"),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
