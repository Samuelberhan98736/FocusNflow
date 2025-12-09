import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/constants.dart';
import '../../services/auth_service.dart';
import '../../utils/snackbar.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_buttom.dart';
import '../../widgets/custom_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passwordController.text.trim() != _confirmController.text.trim()) {
      showAppSnackBar(context, 'Passwords do not match', isError: true);
      return;
    }
    setState(() => _loading = true);

    final auth = context.read<AuthService>();
    final error = await auth.signUp(
      email: _emailController.text.trim(),
      name: _nameController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (error != null) {
      showAppSnackBar(context, error, isError: true);
      return;
    }

    showAppSnackBar(context, 'Account created');
    Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Padding(
        padding: defaultScreenPadding,
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Join FocusNFlow',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 16),
              CustomInput(
                controller: _nameController,
                label: 'Full name',
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              CustomInput(
                controller: _emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
              ),
              const SizedBox(height: 12),
              CustomInput(
                controller: _passwordController,
                label: 'Password',
                obscureText: true,
                validator: (v) => Validators.password(v, minLength: 6),
              ),
              const SizedBox(height: 12),
              CustomInput(
                controller: _confirmController,
                label: 'Confirm password',
                obscureText: true,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Please confirm password' : null,
              ),
              const SizedBox(height: 20),
              CustomButton(
                label: 'Create Account',
                onPressed: _submit,
                isLoading: _loading,
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _goToLogin,
                child: const Text('Already have an account? Log in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
