class AppValidators {
  AppValidators._();

  static String? required(final String? value, {final String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required.';
    }
    return null;
  }

  static String? email(final String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required.';
    }
    final RegExp emailRegex = RegExp(r'^[\w.-]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  static String? password(final String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters.';
    }
    return null;
  }

  static String? phone(final String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required.';
    }
    final RegExp phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Please enter a valid phone number.';
    }
    return null;
  }

  static String? confirmPassword(final String? value, final String original) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password.';
    }
    if (value != original) {
      return 'Passwords do not match.';
    }
    return null;
  }

  static String? minLength(final String? value, final int min, {final String? fieldName}) {
    if (value == null || value.length < min) {
      return '${fieldName ?? 'Field'} must be at least $min characters.';
    }
    return null;
  }
}
