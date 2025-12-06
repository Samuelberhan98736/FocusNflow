import 'package:flutter/foundation.dart';

import '../models/schedule_model.dart';
import '../services/schedule_service.dart';

/// Manages scheduled study sessions and membership state.
class ScheduleProvider extends ChangeNotifier {
  ScheduleProvider({ScheduleService? scheduleService})
      : _scheduleService = scheduleService ?? ScheduleService();

  final ScheduleService _scheduleService;

  bool _isLoading = false;
  String? _errorMessage;
  List<ScheduleModel> _userSessions = [];
  List<ScheduleModel> _groupSessions = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<ScheduleModel> get userSessions => List.unmodifiable(_userSessions);
  List<ScheduleModel> get groupSessions => List.unmodifiable(_groupSessions);

  Future<void> loadUserSessions() async {
    _setLoading(true);
    try {
      final data = await _scheduleService.getUserSessions();
      _userSessions = data.map(ScheduleModel.fromMap).toList();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadGroupSessions(String groupId) async {
    _setLoading(true);
    try {
      final data = await _scheduleService.getGroupSessions(groupId);
      _groupSessions = data.map(ScheduleModel.fromMap).toList();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<ScheduleModel?> getSession(String sessionId) async {
    final data = await _scheduleService.getSession(sessionId);
    if (data == null) return null;
    return ScheduleModel.fromMap(data);
  }

  Future<String?> createSession({
    required String groupId,
    required DateTime startTime,
    required DateTime endTime,
    String? location,
    String? notes,
  }) async {
    _setLoading(true);
    final id = await _scheduleService.createSession(
      groupId: groupId,
      startTime: startTime,
      endTime: endTime,
      location: location,
      notes: notes,
    );
    _setLoading(false);
    return id;
  }

  Future<bool> joinSession(String sessionId) async {
    final ok = await _scheduleService.joinSession(sessionId);
    if (ok) {
      await _refreshAfterMembershipChange(sessionId);
    }
    return ok;
  }

  Future<bool> leaveSession(String sessionId) async {
    final ok = await _scheduleService.leaveSession(sessionId);
    if (ok) {
      await _refreshAfterMembershipChange(sessionId);
    }
    return ok;
  }

  Future<bool> updateSession(
    String sessionId,
    Map<String, dynamic> updates,
  ) {
    return _scheduleService.updateSession(sessionId, updates);
  }

  Stream<ScheduleModel?> watchSession(String sessionId) {
    return _scheduleService.sessionStream(sessionId).map((data) {
      if (data == null) return null;
      return ScheduleModel.fromMap(data);
    });
  }

  Future<void> _refreshAfterMembershipChange(String sessionId) async {
    final session = await getSession(sessionId);
    if (session == null) return;

    _userSessions = _userSessions
        .where((s) => s.sessionId != sessionId)
        .toList(growable: true);
    _userSessions.add(session);
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
