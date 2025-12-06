import 'package:flutter/foundation.dart';

import '../models/room_model.dart';
import '../services/room_service.dart';

/// Keeps room availability in sync for the UI.
class RoomProvider extends ChangeNotifier {
  RoomProvider({RoomService? roomService})
      : _roomService = roomService ?? RoomService();

  final RoomService _roomService;

  bool _isLoading = false;
  String? _errorMessage;
  List<RoomModel> _rooms = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<RoomModel> get rooms => List.unmodifiable(_rooms);

  Future<void> fetchRooms() async {
    _setLoading(true);
    try {
      final data = await _roomService.getAllRooms();
      _rooms = data.map(RoomModel.fromMap).toList();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<RoomModel?> getRoom(String roomId) async {
    final data = await _roomService.getRoom(roomId);
    if (data == null) return null;
    return RoomModel.fromMap(data);
  }

  Stream<List<RoomModel>> watchRooms() {
    return _roomService.roomStream().map(
          (rooms) => rooms.map(RoomModel.fromMap).toList(),
        );
  }

  Future<bool> reserveRoom(String roomId) async {
    final ok = await _roomService.reserveRoom(roomId);
    if (ok) await fetchRooms();
    return ok;
  }

  Future<bool> releaseRoom(String roomId) async {
    final ok = await _roomService.releaseRoom(roomId);
    if (ok) await fetchRooms();
    return ok;
  }

  Future<bool> updateAvailability({
    required String roomId,
    required bool isAvailable,
  }) async {
    final ok = await _roomService.updateRoomAvailability(
      roomId: roomId,
      isAvailable: isAvailable,
    );
    if (ok) await fetchRooms();
    return ok;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
