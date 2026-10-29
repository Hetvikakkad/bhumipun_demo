import 'package:equatable/equatable.dart';

import '../../../../core/utils/validators.dart';
import 'document_file_model.dart';

class OrderRequestModel extends Equatable {
  final String firstName;
  final String lastName;
  final String mobileNumber;
  final String email;

  final String orderId;
  final String address;
  final String? state;
  final String? district;
  final String? taluka;
  final String? cityVillage;
  final String pinCode;

  final DocumentFileModel? aadhaarDoc;
  final DocumentFileModel? supportingDoc;

  final String? referenceId;
  final DateTime? submittedAt;

  const OrderRequestModel({
    this.firstName = '',
    this.lastName = '',
    this.mobileNumber = '',
    this.email = '',
    this.orderId = '',
    this.address = '',
    this.state,
    this.district,
    this.taluka,
    this.cityVillage,
    this.pinCode = '',
    this.aadhaarDoc,
    this.supportingDoc,
    this.referenceId,
    this.submittedAt,
  });

  String get fullName => '$firstName $lastName'.trim();

  // --- Step 1 Validation Check ---
  bool get isStep1Valid {
    return Validators.validateName(firstName, 'First name') == null &&
        Validators.validateName(lastName, 'Last name') == null &&
        Validators.validateIndianMobile(mobileNumber) == null &&
        Validators.validateEmail(email) == null;
  }

  // --- Step 2 Validation Check ---
  bool get isStep2Valid {
    return Validators.validateRequired(orderId, 'Order ID') == null &&
        Validators.validateAddress(address) == null &&
        state != null &&
        state!.isNotEmpty &&
        district != null &&
        district!.isNotEmpty &&
        taluka != null &&
        taluka!.isNotEmpty &&
        cityVillage != null &&
        cityVillage!.isNotEmpty &&
        Validators.validatePinCode(pinCode) == null;
  }

  // --- Step 3 Validation Check ---
  bool get isStep3Valid {
    if (aadhaarDoc == null || supportingDoc == null) return false;
    final aadhaarValid =
        aadhaarDoc!.isAccessible &&
        Validators.validatePdfFile(
              fileName: aadhaarDoc!.name,
              fileSizeBytes: aadhaarDoc!.sizeBytes,
              mimeType: aadhaarDoc!.mimeType,
            ) ==
            null;

    final supportingValid =
        supportingDoc!.isAccessible &&
        Validators.validatePdfFile(
              fileName: supportingDoc!.name,
              fileSizeBytes: supportingDoc!.sizeBytes,
              mimeType: supportingDoc!.mimeType,
            ) ==
            null;

    return aadhaarValid && supportingValid;
  }

  bool get isReadyForSubmission => isStep1Valid && isStep2Valid && isStep3Valid;

  OrderRequestModel copyWith({
    String? firstName,
    String? lastName,
    String? mobileNumber,
    String? email,
    String? orderId,
    String? address,
    String? state,
    String? district,
    String? taluka,
    String? cityVillage,
    String? pinCode,
    bool clearDistrict = false,
    bool clearTaluka = false,
    bool clearCityVillage = false,
    DocumentFileModel? aadhaarDoc,
    DocumentFileModel? supportingDoc,
    bool clearAadhaar = false,
    bool clearSupporting = false,
    String? referenceId,
    DateTime? submittedAt,
  }) {
    return OrderRequestModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      email: email ?? this.email,
      orderId: orderId ?? this.orderId,
      address: address ?? this.address,
      state: state ?? this.state,
      district: clearDistrict ? null : (district ?? this.district),
      taluka: clearTaluka ? null : (taluka ?? this.taluka),
      cityVillage: clearCityVillage ? null : (cityVillage ?? this.cityVillage),
      pinCode: pinCode ?? this.pinCode,
      aadhaarDoc: clearAadhaar ? null : (aadhaarDoc ?? this.aadhaarDoc),
      supportingDoc: clearSupporting
          ? null
          : (supportingDoc ?? this.supportingDoc),
      referenceId: referenceId ?? this.referenceId,
      submittedAt: submittedAt ?? this.submittedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'mobileNumber': mobileNumber,
      'email': email,
      'orderId': orderId,
      'address': address,
      'state': state,
      'district': district,
      'taluka': taluka,
      'cityVillage': cityVillage,
      'pinCode': pinCode,
      'aadhaarDoc': aadhaarDoc?.toJson(),
      'supportingDoc': supportingDoc?.toJson(),
      'referenceId': referenceId,
      'submittedAt': submittedAt?.toIso8601String(),
    };
  }

  factory OrderRequestModel.fromJson(Map<String, dynamic> json) {
    return OrderRequestModel(
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      mobileNumber: json['mobileNumber'] as String? ?? '',
      email: json['email'] as String? ?? '',
      orderId: json['orderId'] as String? ?? '',
      address: json['address'] as String? ?? '',
      state: json['state'] as String?,
      district: json['district'] as String?,
      taluka: json['taluka'] as String?,
      cityVillage: json['cityVillage'] as String?,
      pinCode: json['pinCode'] as String? ?? '',
      aadhaarDoc: json['aadhaarDoc'] != null
          ? DocumentFileModel.fromJson(
              json['aadhaarDoc'] as Map<String, dynamic>,
            )
          : null,
      supportingDoc: json['supportingDoc'] != null
          ? DocumentFileModel.fromJson(
              json['supportingDoc'] as Map<String, dynamic>,
            )
          : null,
      referenceId: json['referenceId'] as String?,
      submittedAt: json['submittedAt'] != null
          ? DateTime.tryParse(json['submittedAt'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    mobileNumber,
    email,
    orderId,
    address,
    state,
    district,
    taluka,
    cityVillage,
    pinCode,
    aadhaarDoc,
    supportingDoc,
    referenceId,
    submittedAt,
  ];
}
