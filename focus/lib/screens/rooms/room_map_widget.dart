import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../app/constants.dart';
import '../../models/room_model.dart';
import '../../services/room_service.dart';
import '../../widgets/availability.dart';

/// Google Maps-based floor map with clickable room pins.
class RoomMapWidget extends StatelessWidget {
  const RoomMapWidget({super.key});

  static const LatLng _fallbackTarget = LatLng(33.7537, -84.3863);

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

          var rooms =
              (snapshot.data ?? []).map((e) => RoomModel.fromMap(e)).toList();

          // If empty, seed defaults so reservations work and show a map.
          if (rooms.isEmpty) {
            roomService.seedDefaultRoomsIfEmpty();
            rooms = _defaultRooms;
          }

          final markers = _buildMarkers(context, rooms);
          final initialTarget =
              markers.isNotEmpty ? markers.first.position : _fallbackTarget;

          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: _Legend(),
              ),
              Expanded(
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: initialTarget,
                    zoom: 18,
                  ),
                  markers: markers,
                  compassEnabled: true,
                  mapToolbarEnabled: false,
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  padding: const EdgeInsets.all(12),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Set<Marker> _buildMarkers(BuildContext context, List<RoomModel> rooms) {
    return rooms.map((room) {
      final target = _targetFor(room);
      final hue =
          room.isAvailable ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed;

      return Marker(
        markerId: MarkerId(room.roomId),
        position: target,
        icon: BitmapDescriptor.defaultMarkerWithHue(hue),
        infoWindow: InfoWindow(
          title: room.name,
          snippet: room.isAvailable ? 'Available' : 'Occupied',
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.roomDetail,
              arguments: room.roomId,
            );
          },
        ),
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRoutes.roomDetail,
            arguments: room.roomId,
          );
        },
      );
    }).toSet();
  }

  LatLng _targetFor(RoomModel room) {
    if (room.latitude != null && room.longitude != null) {
      return LatLng(room.latitude!, room.longitude!);
    }
    return _fallbackTarget;
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

final List<RoomModel> _defaultRooms = [
  RoomModel(
    roomId: '601',
    name: 'Room 601',
    isAvailable: true,
    reservedBy: null,
    reservedAt: null,
    latitude: 33.7525,
    longitude: -84.3868,
  ),
  RoomModel(
    roomId: '602',
    name: 'Room 602',
    isAvailable: true,
    reservedBy: null,
    reservedAt: null,
    latitude: 33.7526,
    longitude: -84.3866,
  ),
  RoomModel(
    roomId: '603',
    name: 'Room 603',
    isAvailable: true,
    reservedBy: null,
    reservedAt: null,
    latitude: 33.7527,
    longitude: -84.3864,
  ),
  RoomModel(
    roomId: '604',
    name: 'Room 604',
    isAvailable: true,
    reservedBy: null,
    reservedAt: null,
    latitude: 33.7528,
    longitude: -84.3862,
  ),
  RoomModel(
    roomId: '605',
    name: 'Room 605',
    isAvailable: true,
    reservedBy: null,
    reservedAt: null,
    latitude: 33.7529,
    longitude: -84.386,
  ),
  RoomModel(
    roomId: '606',
    name: 'Room 606',
    isAvailable: true,
    reservedBy: null,
    reservedAt: null,
    latitude: 33.753,
    longitude: -84.3858,
  ),
  RoomModel(
    roomId: '607',
    name: 'Room 607',
    isAvailable: true,
    reservedBy: null,
    reservedAt: null,
    latitude: 33.7531,
    longitude: -84.3856,
  ),
  RoomModel(
    roomId: '608',
    name: 'Room 608',
    isAvailable: true,
    reservedBy: null,
    reservedAt: null,
    latitude: 33.7532,
    longitude: -84.3854,
  ),
  RoomModel(
    roomId: '609',
    name: 'Room 609',
    isAvailable: true,
    reservedBy: null,
    reservedAt: null,
    latitude: 33.7533,
    longitude: -84.3852,
  ),
  RoomModel(
    roomId: '610',
    name: 'Room 610',
    isAvailable: true,
    reservedBy: null,
    reservedAt: null,
    latitude: 33.7534,
    longitude: -84.385,
  ),
  RoomModel(
    roomId: '611',
    name: 'Room 611',
    isAvailable: false,
    reservedBy: null,
    reservedAt: null,
    latitude: 33.7535,
    longitude: -84.3848,
  ),
  RoomModel(
    roomId: '612',
    name: 'Room 612',
    isAvailable: false,
    reservedBy: null,
    reservedAt: null,
    latitude: 33.7536,
    longitude: -84.3846,
  ),
  RoomModel(
    roomId: '613',
    name: 'Room 613',
    isAvailable: false,
    reservedBy: null,
    reservedAt: null,
    latitude: 33.7537,
    longitude: -84.3844,
  ),
  RoomModel(
    roomId: '614',
    name: 'Room 614',
    isAvailable: false,
    reservedBy: null,
    reservedAt: null,
    latitude: 33.7538,
    longitude: -84.3842,
  ),
  RoomModel(
    roomId: '615',
    name: 'Room 615',
    isAvailable: false,
    reservedBy: null,
    reservedAt: null,
    latitude: 33.7539,
    longitude: -84.384,
  ),
];
