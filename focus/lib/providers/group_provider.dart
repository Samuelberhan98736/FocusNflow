import 'package:flutter/foundation.dart';

import '../models/group_model.dart';
import '../services/group_service.dart';

/// Manages study group data and membership actions.
class GroupProvider extends ChangeNotifier {
  GroupProvider({GroupService? groupService})
      : _groupService = groupService ?? GroupService();

  final GroupService _groupService;

  bool _isLoading = false;
  String? _errorMessage;
  List<GroupModel> _allGroups = [];
  List<GroupModel> _myGroups = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<GroupModel> get allGroups => List.unmodifiable(_allGroups);
  List<GroupModel> get myGroups => List.unmodifiable(_myGroups);

  Future<void> fetchAllGroups() async {
    _setLoading(true);
    try {
      final groups = await _groupService.getAllGroups();
      _allGroups = groups.map(GroupModel.fromMap).toList();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchMyGroups() async {
    _setLoading(true);
    try {
      final groups = await _groupService.getUserGroups();
      _myGroups = groups.map(GroupModel.fromMap).toList();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<GroupModel?> getGroup(String groupId) async {
    final data = await _groupService.getGroup(groupId);
    if (data == null) return null;
    return GroupModel.fromMap(data);
  }

  Future<String?> createGroup({
    required String name,
    required String course,
    String? description,
  }) async {
    _setLoading(true);
    final id = await _groupService.createGroup(
      name: name,
      course: course,
      description: description,
    );
    await fetchMyGroups();
    _setLoading(false);
    return id;
  }

  Future<bool> joinGroup(String groupId) async {
    final ok = await _groupService.joinGroup(groupId);
    if (ok) {
      await fetchAllGroups();
      await fetchMyGroups();
    }
    return ok;
  }

  Future<bool> leaveGroup(String groupId) async {
    final ok = await _groupService.leaveGroup(groupId);
    if (ok) {
      await fetchAllGroups();
      await fetchMyGroups();
    }
    return ok;
  }

  Stream<GroupModel?> watchGroup(String groupId) {
    return _groupService.groupStream(groupId).map((data) {
      if (data == null) return null;
      return GroupModel.fromMap(data);
    });
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
