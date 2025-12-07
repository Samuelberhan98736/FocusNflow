import 'package:flutter/material.dart';

/// Placeholder map view for rooms.
class RoomMapWidget extends StatelessWidget {
  const RoomMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Room Map')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.map_outlined, size: 80),
            SizedBox(height: 12),
            Text('Map integration coming soon'),
          ],
        ),
      ),
    );
  }
}
