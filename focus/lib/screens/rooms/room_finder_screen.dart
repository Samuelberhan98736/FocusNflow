import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/constants.dart';
import '../../models/room_model.dart';
import '../../services/room_service.dart';
import '../../widgets/room_card.dart';

class RoomFinderScreen extends StatelessWidget {
  const RoomFinderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final roomService = context.read<RoomService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Find a Room')),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: roomService.roomStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final rooms =
              (snapshot.data ?? []).map((e) => RoomModel.fromMap(e)).toList();

          if (rooms.isEmpty) {
            roomService.seedDefaultRoomsIfEmpty();
          }

          if (rooms.isEmpty) {
            return const Center(child: Text('No rooms available'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: rooms.length,
            itemBuilder: (_, index) {
              final room = rooms[index];
              return RoomCard(
                room: room,
                onTap: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.roomDetail,
                    arguments: room.roomId,
                  );
                },
                onAction: () async {
                  if (room.isAvailable) {
                    await roomService.reserveRoom(room.roomId);
                  } else {
                    await roomService.releaseRoom(room.roomId);
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.map),
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.roomMap);
        },
      ),
    );
  }
}
