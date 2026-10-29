import '../constants/app_strings.dart';

class Validators {
  Validators._();

  static const int maxPdfSizeBytes = 2 * 1024 * 1024; // 2 MB

  /// Validates that a string value is not empty or only whitespace.
  static String? validateRequired(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null
          ? '$fieldName is required'
          : AppStrings.requiredField;
    }
    return null;
  }

  /// Validates personal name (first name, last name).
  static String? validateName(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    final trimmed = value.trim();
    if (trimmed.length < 2) {
      return '$fieldName must be at least 2 characters';
    }
    // Allow alphabetic characters, spaces, and hyphens/apostrophes commonly found in Indian names
    final nameRegex = RegExp(r"^[a-zA-Z\s.'-]+$");
    if (!nameRegex.hasMatch(trimmed)) {
      return '$fieldName should only contain letters';
    }
    return null;
  }

  /// Validates standard email address format.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }
    final trimmed = value.trim();
    // Standard RFC compliant regex for typical email inputs
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$',
    );
    if (!emailRegex.hasMatch(trimmed)) {
      return AppStrings.invalidEmail;
    }
    return null;
  }

  /// Validates Indian mobile number:
  /// - Exactly 10 digits
  /// - Starts with 6, 7, 8, or 9
  static String? validateIndianMobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mobile number is required';
    }
    final cleaned = value.replaceAll(RegExp(r'\s+|-|\+91'), '').trim();
    if (cleaned.length != 10) {
      return 'Mobile number must be exactly 10 digits';
    }
    final mobileRegex = RegExp(r'^[6-9]\d{9}$');
    if (!mobileRegex.hasMatch(cleaned)) {
      return AppStrings.invalidMobile;
    }
    return null;
  }

  /// Validates Indian PIN code:
  /// - Exactly 6 digits
  /// - Digits only
  /// - First digit 1-9
  static String? validatePinCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'PIN code is required';
    }
    final cleaned = value.trim();
    final pinRegex = RegExp(r'^[1-9][0-9]{5}$');
    if (!pinRegex.hasMatch(cleaned)) {
      return AppStrings.invalidPinCode;
    }
    return null;
  }

  /// Validates full address.
  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full address is required';
    }
    if (value.trim().length < 8) {
      return 'Please enter a complete address (at least 8 characters)';
    }
    return null;
  }

  /// Validates PDF file extension, mime type, and file size.
  static String? validatePdfFile({
    required String fileName,
    required int fileSizeBytes,
    String? mimeType,
  }) {
    final lowerName = fileName.toLowerCase();
    if (!lowerName.endsWith('.pdf')) {
      return AppStrings.pdfOnlyError;
    }

    if (mimeType != null && mimeType.isNotEmpty) {
      final lowerMime = mimeType.toLowerCase();
      if (lowerMime != 'application/pdf' && lowerMime != 'application/x-pdf') {
        return AppStrings.pdfOnlyError;
      }
    }

    if (fileSizeBytes <= 0) {
      return 'Selected file is empty';
    }

    if (fileSizeBytes > maxPdfSizeBytes) {
      return AppStrings.maxFileSizeError;
    }

    return null;
  }
}
