class Validators {
  Validators._();

  static String? required(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  static String? minLength(String? value, int min, String message) {
    if (value == null || value.trim().length < min) {
      return message;
    }
    return null;
  }

  static String? amount(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    final number = double.tryParse(value.trim());
    if (number == null || number <= 0) {
      return message;
    }
    return null;
  }

  static String? phone(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return null; // Phone is optional
    }
    final cleanValue = value.trim();
    if (cleanValue.length != 10 || int.tryParse(cleanValue) == null) {
      return message;
    }
    return null;
  }
}
