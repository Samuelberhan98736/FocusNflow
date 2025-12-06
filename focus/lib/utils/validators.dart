/// Common form field validators used across the app.
class Validators {
  static String? requiredField(
    String? value, {
    String fieldName = 'This field',
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    const pattern = r'^[\w\.-]+@[\w\.-]+\.\w{2,}$';
    if (!RegExp(pattern).hasMatch(value.trim())) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? minLength(
    String? value,
    int min, {
    String label = 'Value',
  }) {
    final text = value?.trim() ?? '';
    if (text.length < min) {
      return '$label must be at least $min characters';
    }
    return null;
  }

  static String? password(String? value, {int minLength = 6}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Password is required';
    if (text.length < minLength) {
      return 'Password must be at least $minLength characters';
    }
    return null;
  }

  static String? confirmPassword(String? value, String? original) {
    if ((value ?? '').isEmpty) return 'Please confirm your password';
    if (value != original) return 'Passwords do not match';
    return null;
  }
}
