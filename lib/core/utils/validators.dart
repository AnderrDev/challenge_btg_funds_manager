/// Centralized form field validation logic.
class BTGValidators {
  /// Validates that the input is a valid email address.
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Ingrese su email';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Email inválido';
    return null;
  }

  /// Validates that the input is a valid phone number (numeric and minimum 10 digits).
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Ingrese su teléfono';
    // Remove any non-numeric characters if they somehow got in
    final numericValue = value.replaceAll(RegExp(r'\D'), '');
    if (numericValue.length < 10) return 'Mínimo 10 dígitos';
    return null;
  }

  /// Validates that the value is not empty.
  static String? required(String? value, String fieldName) {
    if (value == null || value.isEmpty) return 'Ingrese $fieldName';
    return null;
  }
}
