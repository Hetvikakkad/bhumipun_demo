import 'package:equatable/equatable.dart';

import '../data/models/document_file_model.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class OrderInitialized extends OrderEvent {
  const OrderInitialized();
}

class OrderStepChanged extends OrderEvent {
  final int step;
  const OrderStepChanged(this.step);

  @override
  List<Object?> get props => [step];
}

class ContactDetailsChanged extends OrderEvent {
  final String? firstName;
  final String? lastName;
  final String? mobileNumber;
  final String? email;

  const ContactDetailsChanged({
    this.firstName,
    this.lastName,
    this.mobileNumber,
    this.email,
  });

  @override
  List<Object?> get props => [firstName, lastName, mobileNumber, email];
}

class OrderDetailsChanged extends OrderEvent {
  final String? orderId;
  final String? address;
  final String? pinCode;

  const OrderDetailsChanged({this.orderId, this.address, this.pinCode});

  @override
  List<Object?> get props => [orderId, address, pinCode];
}

class StateChanged extends OrderEvent {
  final String? state;
  const StateChanged(this.state);

  @override
  List<Object?> get props => [state];
}

class DistrictChanged extends OrderEvent {
  final String? district;
  const DistrictChanged(this.district);

  @override
  List<Object?> get props => [district];
}

class TalukaChanged extends OrderEvent {
  final String? taluka;
  const TalukaChanged(this.taluka);

  @override
  List<Object?> get props => [taluka];
}

class CityVillageChanged extends OrderEvent {
  final String? cityVillage;
  const CityVillageChanged(this.cityVillage);

  @override
  List<Object?> get props => [cityVillage];
}

class DocumentUpdated extends OrderEvent {
  final DocumentType type;
  final DocumentFileModel document;

  const DocumentUpdated({required this.type, required this.document});

  @override
  List<Object?> get props => [type, document];
}

class DocumentRemoved extends OrderEvent {
  final DocumentType type;
  const DocumentRemoved(this.type);

  @override
  List<Object?> get props => [type];
}

class SaveDraftClicked extends OrderEvent {
  const SaveDraftClicked();
}

class ClearDraftClicked extends OrderEvent {
  const ClearDraftClicked();
}

class SubmitOrderClicked extends OrderEvent {
  const SubmitOrderClicked();
}

class ResetFormClicked extends OrderEvent {
  const ResetFormClicked();
}

class ClearNotification extends OrderEvent {
  const ClearNotification();
}
