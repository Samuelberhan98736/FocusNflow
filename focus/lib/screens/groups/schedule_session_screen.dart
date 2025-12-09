import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/schedule_service.dart';
import '../../utils/snackbar.dart';
import '../../utils/time_formattor.dart';
import '../../widgets/custom_buttom.dart';

class ScheduleSessionScreen extends StatefulWidget {
  const ScheduleSessionScreen({super.key, this.groupId});

  final String? groupId;

  @override
  State<ScheduleSessionScreen> createState() => _ScheduleSessionScreenState();
}

class _ScheduleSessionScreenState extends State<ScheduleSessionScreen> {
  DateTime _start = DateTime.now().add(const Duration(hours: 1));
  DateTime _end = DateTime.now().add(const Duration(hours: 2));
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime(bool isStart) async {
    final initial = isStart ? _start : _end;
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null) return;

    final combined = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    setState(() {
      if (isStart) {
        _start = combined;
        if (_end.isBefore(_start)) {
          _end = _start.add(const Duration(hours: 1));
        }
      } else {
        _end = combined;
      }
    });
  }

  Future<void> _submit(String groupId) async {
    setState(() => _loading = true);
    final schedule = context.read<ScheduleService>();
    final id = await schedule.createSession(
      groupId: groupId,
      startTime: _start,
      endTime: _end,
      location: _locationController.text.trim().isEmpty
          ? null
          : _locationController.text.trim(),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );
    if (!mounted) return;
    setState(() => _loading = false);
    if (id == null) {
      showAppSnackBar(context, 'Could not schedule session', isError: true);
    } else {
      showAppSnackBar(context, 'Session scheduled');
      Navigator.of(context).pop(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupId =
        widget.groupId ?? ModalRoute.of(context)?.settings.arguments as String?;
    if (groupId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Schedule Session')),
        body: const Center(child: Text('No group specified')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Schedule Session')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DateRow(
              label: 'Start',
              value: formatDateTime(_start),
              onTap: () => _pickDateTime(true),
            ),
            const SizedBox(height: 12),
            _DateRow(
              label: 'End',
              value: formatDateTime(_end),
              onTap: () => _pickDateTime(false),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location (optional)',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
              ),
            ),
            const Spacer(),
            CustomButton(
              label: 'Create Session',
              onPressed: _loading ? null : () => _submit(groupId),
              isLoading: _loading,
            ),
          ],
        ),
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  const _DateRow({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          const Icon(Icons.calendar_today_outlined),
        ],
      ),
    );
  }
}
