class AppStrings {
  AppStrings._();

  static const String appTitle = 'Bhumipun Orders';
  static const String appSubtitle = 'Land & Agricultural Order Request Portal';

  // Step titles
  static const String step1Title = 'Contact Details';
  static const String step1Subtitle =
      'Personal identification and communication info';
  static const String step2Title = 'Order Details';
  static const String step2Subtitle =
      'Order ID and hierarchical geographic location';
  static const String step3Title = 'Document Uploads';
  static const String step3Subtitle = 'Mandatory verification documents in PDF';
  static const String step4Title = 'Review & Submit';
  static const String step4Subtitle = 'Verify details and submit order request';

  // Form field labels
  static const String firstName = 'First Name';
  static const String lastName = 'Last Name';
  static const String mobileNumber = 'Mobile Number';
  static const String emailAddress = 'Email Address';
  static const String orderId = 'Order ID';
  static const String fullAddress = 'Full Address';
  static const String state = 'State';
  static const String district = 'District';
  static const String taluka = 'Taluka';
  static const String cityVillage = 'City / Village';
  static const String pinCode = 'PIN Code';

  // Document labels
  static const String aadhaarDoc = 'Aadhaar Card';
  static const String aadhaarDocDescription =
      'Upload your government-issued Aadhaar identity card in PDF format.';
  static const String supportingDoc = 'Supporting Document';
  static const String supportingDocDescription =
      'Upload 7/12 extract, purchase order, or land verification proof in PDF.';

  // Buttons
  static const String nextStep = 'Continue';
  static const String previousStep = 'Back';
  static const String reviewOrder = 'Review Order';
  static const String submitOrder = 'Submit Order Request';
  static const String saveDraft = 'Save Draft';
  static const String clearDraft = 'Clear Draft';
  static const String selectFile = 'Select PDF Document';
  static const String replaceFile = 'Replace';
  static const String removeFile = 'Remove';
  static const String createAnother = 'Create Another Request';
  static const String copyReference = 'Copy Reference ID';

  // Validation messages
  static const String requiredField = 'This field is required';
  static const String invalidEmail =
      'Enter a valid email address (e.g. name@domain.com)';
  static const String invalidMobile =
      'Enter a valid 10-digit Indian mobile number (starting with 6, 7, 8, or 9)';
  static const String invalidPinCode = 'Enter a valid 6-digit Indian PIN code';
  static const String pdfOnlyError = 'Only PDF documents (.pdf) are allowed';
  static const String maxFileSizeError =
      'Document size exceeds maximum allowed limit of 2 MB';
  static const String missingAadhaarError = 'Aadhaar Card PDF is mandatory';
  static const String missingSupportingDocError =
      'Supporting Document PDF is mandatory';
  static const String documentInaccessibleError =
      'Previously selected file is no longer accessible. Please re-select it.';

  // Demonstration notice
  static const String demoNotice =
      'Local Demonstration Mode: All data and documents are processed locally on your device. No data is transmitted to an external server.';
}
