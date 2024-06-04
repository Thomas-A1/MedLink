class FormValidation {
  static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    // Regular Expression for email validation
    final emailReg = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailReg.hasMatch(value)) {
      return 'Invalid email address.';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    // Checking for minimum password length
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    // Check for Uppercase letters
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    // Check for numbers
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least 1 number';
    }
    // Check for special characters
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}_|<>;]'))) {
      return 'Password must contain at least 1 special character';
    }
    return null;
  }

  static String? validatecontact(String? value) {
    if (value == null || value.isEmpty) {
      return 'Contact is required';
    }
    final contactReg = RegExp(r'^\d{10}$');

    if (!contactReg.hasMatch(value)) {
      return 'Invalid number (10 digits required)';
    }
    return null;
  }
}
