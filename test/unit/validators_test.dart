import 'package:flutter_test/flutter_test.dart';
import 'package:bhumipun_demo/core/utils/validators.dart';
import 'package:bhumipun_demo/core/constants/app_strings.dart';

void main() {
  group('Validators - Required & Names', () {
    test('validateRequired returns error on null or empty', () {
      expect(Validators.validateRequired(null), AppStrings.requiredField);
      expect(Validators.validateRequired(''), AppStrings.requiredField);
      expect(Validators.validateRequired('   '), AppStrings.requiredField);
      expect(Validators.validateRequired('Valid'), isNull);
    });

    test(
      'validateName validates minimum length and alphabetical characters',
      () {
        expect(
          Validators.validateName(null, 'First name'),
          'First name is required',
        );
        expect(
          Validators.validateName('A', 'First name'),
          'First name must be at least 2 characters',
        );
        expect(
          Validators.validateName('John123', 'First name'),
          'First name should only contain letters',
        );
        expect(Validators.validateName('Ramesh Kumar', 'First name'), isNull);
        expect(Validators.validateName("O'Connor", 'Last name'), isNull);
        expect(Validators.validateName('Patel-Shah', 'Last name'), isNull);
      },
    );
  });

  group('Validators - Email & Indian Mobile', () {
    test('validateEmail validates RFC compliant email addresses', () {
      expect(Validators.validateEmail(null), 'Email address is required');
      expect(Validators.validateEmail(''), 'Email address is required');
      expect(
        Validators.validateEmail('invalid-email'),
        AppStrings.invalidEmail,
      );
      expect(Validators.validateEmail('user@'), AppStrings.invalidEmail);
      expect(Validators.validateEmail('@domain.com'), AppStrings.invalidEmail);
      expect(Validators.validateEmail('farmer@bhumipun.in'), isNull);
      expect(Validators.validateEmail('support.agri@portal.co.in'), isNull);
    });

    test(
      'validateIndianMobile accepts only 10 digits starting with 6, 7, 8, 9',
      () {
        expect(
          Validators.validateIndianMobile(null),
          'Mobile number is required',
        );
        expect(
          Validators.validateIndianMobile(''),
          'Mobile number is required',
        );
        // Less than 10 digits
        expect(
          Validators.validateIndianMobile('987654321'),
          'Mobile number must be exactly 10 digits',
        );
        // More than 10 digits
        expect(
          Validators.validateIndianMobile('98765432100'),
          'Mobile number must be exactly 10 digits',
        );
        // Starts with 1, 2, 3, 4, 5
        expect(
          Validators.validateIndianMobile('5876543210'),
          AppStrings.invalidMobile,
        );
        expect(
          Validators.validateIndianMobile('1234567890'),
          AppStrings.invalidMobile,
        );
        // Valid Indian numbers
        expect(Validators.validateIndianMobile('9876543210'), isNull);
        expect(Validators.validateIndianMobile('8123456789'), isNull);
        expect(Validators.validateIndianMobile('7012345678'), isNull);
        expect(Validators.validateIndianMobile('6398765432'), isNull);
        // Strips +91 prefix and spaces automatically
        expect(Validators.validateIndianMobile('+91 98765 43210'), isNull);
      },
    );
  });

  group('Validators - PIN Code & Address', () {
    test('validatePinCode requires exactly 6 digits starting with 1-9', () {
      expect(Validators.validatePinCode(null), 'PIN code is required');
      expect(Validators.validatePinCode(''), 'PIN code is required');
      expect(Validators.validatePinCode('3821'), AppStrings.invalidPinCode);
      expect(Validators.validatePinCode('3821100'), AppStrings.invalidPinCode);
      expect(
        Validators.validatePinCode('082110'),
        AppStrings.invalidPinCode,
      ); // starts with 0
      expect(
        Validators.validatePinCode('38211A'),
        AppStrings.invalidPinCode,
      ); // non-digits
      expect(Validators.validatePinCode('382110'), isNull);
      expect(Validators.validatePinCode('411001'), isNull);
    });

    test('validateAddress requires minimum 8 characters', () {
      expect(Validators.validateAddress(null), 'Full address is required');
      expect(
        Validators.validateAddress('Farm 1'),
        'Please enter a complete address (at least 8 characters)',
      );
      expect(
        Validators.validateAddress(
          'Survey No. 42, Sanand Road, Village Moraiya',
        ),
        isNull,
      );
    });
  });

  group('Validators - PDF File Type & Size Validation', () {
    test('validatePdfFile rejects non-PDF files', () {
      expect(
        Validators.validatePdfFile(
          fileName: 'document.jpg',
          fileSizeBytes: 1024 * 500,
        ),
        AppStrings.pdfOnlyError,
      );

      expect(
        Validators.validatePdfFile(
          fileName: 'identity.png',
          fileSizeBytes: 1024 * 500,
          mimeType: 'image/png',
        ),
        AppStrings.pdfOnlyError,
      );
    });

    test('validatePdfFile rejects empty files', () {
      expect(
        Validators.validatePdfFile(fileName: 'aadhaar.pdf', fileSizeBytes: 0),
        'Selected file is empty',
      );
    });

    test('validatePdfFile rejects files exceeding 2 MB', () {
      const twoMbAndOneByte = 2 * 1024 * 1024 + 1;
      expect(
        Validators.validatePdfFile(
          fileName: 'aadhaar_card.pdf',
          fileSizeBytes: twoMbAndOneByte,
        ),
        AppStrings.maxFileSizeError,
      );
    });

    test('validatePdfFile accepts valid PDF files under 2 MB', () {
      const oneMb = 1024 * 1024;
      expect(
        Validators.validatePdfFile(
          fileName: 'aadhaar_card.pdf',
          fileSizeBytes: oneMb,
          mimeType: 'application/pdf',
        ),
        isNull,
      );
    });
  });
}
