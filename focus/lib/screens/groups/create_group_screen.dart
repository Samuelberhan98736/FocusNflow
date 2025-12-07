import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/group_service.dart';
import '../../utils/helpers.dart';
import '../../utils/snackbar.dart';
import '../../widgets/custom_buttom.dart';
import '../../widgets/custom_input.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _courseController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _courseController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final groupService = context.read<GroupService>();
    setState(() => _loading = true);

    final id = await groupService.createGroup(
      name: _nameController.text.trim(),
      course: _courseController.text.trim(),
      description: nullIfEmpty(_descriptionController.text),
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (id == null) {
      showAppSnackBar(context, 'Could not create group', isError: true);
      return;
    }

    showAppSnackBar(context, 'Group created');
    Navigator.of(context).pop(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Group')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomInput(
                controller: _nameController,
                label: 'Group name',
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              CustomInput(
                controller: _courseController,
                label: 'Course',
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              CustomInput(
                controller: _descriptionController,
                label: 'Description (optional)',
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              CustomButton(
                label: 'Create',
                onPressed: _submit,
                isLoading: _loading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
