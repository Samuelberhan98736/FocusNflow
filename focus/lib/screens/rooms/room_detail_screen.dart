import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/room_model.dart';
import '../../services/room_service.dart';
import '../../utils/snackbar.dart';
import '../../widgets/availability.dart';

class RoomDetailScreen extends StatefulWidget {
  const RoomDetailScreen({super.key, this.roomId});

  final String? roomId;

  @override
  State<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final roomId =
        widget.roomId ?? ModalRoute.of(context)?.settings.arguments as String?;
    final roomService = context.read<RoomService>();

    if (roomId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Room Detail')),
        body: const Center(child: Text('No room specified')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Room Detail')),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: roomService.getRoom(roomId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data;
          if (data == null) {
            return const Center(child: Text('Room not found'));
          }

          final room = RoomModel.fromMap(data);
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 8),
                AvailabilityIndicator(isAvailable: room.isAvailable),
                const SizedBox(height: 12),
                Text(
                  room.isAvailable
                      ? 'This room is available.'
                      : 'This room is currently reserved.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
                FilledButton(
                  onPressed: _loading
                      ? null
                      : () async {
                          setState(() => _loading = true);
                          final ok = room.isAvailable
                              ? await roomService.reserveRoom(room.roomId)
                              : await roomService.releaseRoom(room.roomId);
                          if (mounted) {
                            setState(() => _loading = false);
                            if (!ok) {
                              showAppSnackBar(
                                context,
                                'Unable to update room',
                                isError: true,
                              );
                            } else {
                              showAppSnackBar(context, 'Updated');
                              setState(() {});
                            }
                          }
                        },
                  child: _loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(room.isAvailable ? 'Reserve' : 'Release'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
