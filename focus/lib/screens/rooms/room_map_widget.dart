import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/constants.dart';
import '../../models/room_model.dart';
import '../../services/room_service.dart';
import '../../widgets/availability.dart';

/// Static floor map with clickable room pins.
class RoomMapWidget extends StatelessWidget {
  const RoomMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final roomService = context.read<RoomService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Room Map')),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: roomService.roomStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          var rooms = (snapshot.data ?? [])
              .map((e) => RoomModel.fromMap(e))
              .toList();

          // Fallback to static map data if Firestore is empty.
          rooms = rooms.isEmpty ? _defaultRooms : rooms;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const _Legend(),
                const SizedBox(height: 12),
                Expanded(
                  child: InteractiveViewer(
                    minScale: 0.9,
                    maxScale: 2.2,
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: LayoutBuilder(
                        builder: (_, box) {
                          final positions = _generatePositions(rooms.length);
                          final width = box.maxWidth;
                          final height = box.maxHeight;

                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color:
                                  Theme.of(context).colorScheme.surfaceVariant,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Image.asset(
                                      'lib/assets/Building.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  _FloorPlanOverlay(),
                                  for (var i = 0; i < rooms.length; i++)
                                    Positioned(
                                      left: positions[i].dx * width,
                                      top: positions[i].dy * height,
                                      child: _RoomPin(room: rooms[i]),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RoomPin extends StatelessWidget {
  const _RoomPin({required this.room});

  final RoomModel room;

  @override
  Widget build(BuildContext context) {
    final isAvailable = room.isAvailable;
    final color = isAvailable
        ? Colors.green.shade500
        : Theme.of(context).colorScheme.error;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRoutes.roomDetail,
          arguments: room.roomId,
        );
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
              border: Border.all(color: color, width: 2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.meeting_room_outlined,
                  size: 18,
                  color: color,
                ),
                const SizedBox(width: 6),
                Text(
                  room.name,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.surface,
                width: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        AvailabilityIndicator(isAvailable: true),
        SizedBox(width: 8),
        Text('Available'),
        SizedBox(width: 16),
        AvailabilityIndicator(isAvailable: false),
        SizedBox(width: 8),
        Text('Occupied'),
      ],
    );
  }
}

class _FloorPlanOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dividerColor =
        Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.15);

    return CustomPaint(
      painter: _FloorPainter(dividerColor),
      size: Size.infinite,
    );
  }
}

class _FloorPainter extends CustomPainter {
  _FloorPainter(this.dividerColor);

  final Color dividerColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dividerColor
      ..strokeWidth = 2;

    // Draw simple hallways and vertical dividers.
    canvas.drawLine(
      Offset(size.width * 0.05, size.height * 0.3),
      Offset(size.width * 0.95, size.height * 0.3),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.05, size.height * 0.65),
      Offset(size.width * 0.95, size.height * 0.65),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.35, size.height * 0.1),
      Offset(size.width * 0.35, size.height * 0.9),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.65, size.height * 0.1),
      Offset(size.width * 0.65, size.height * 0.9),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

List<Offset> _generatePositions(int count) {
  const cols = 4;
  final rows = (count / cols).ceil().clamp(1, 6);
  final positions = <Offset>[];

  for (var i = 0; i < count; i++) {
    final row = i ~/ cols;
    final col = i % cols;
    final dx = (col + 1) / (cols + 1); // spread evenly across width
    final dy = (row + 1) / (rows + 1); // spread evenly across height
    positions.add(Offset(dx, dy));
  }

  return positions;
}

final List<RoomModel> _defaultRooms = [
  for (var i = 601; i <= 610; i++)
    RoomModel(
      roomId: '$i',
      name: 'Room $i',
      isAvailable: true,
      reservedBy: null,
      reservedAt: null,
    ),
  for (var i = 611; i <= 615; i++)
    RoomModel(
      roomId: '$i',
      name: 'Room $i',
      isAvailable: false,
      reservedBy: null,
      reservedAt: null,
    ),
];
