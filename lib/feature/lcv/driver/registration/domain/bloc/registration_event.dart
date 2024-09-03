part of 'registration_bloc.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();
}

class RegistrationPageLoadEvent extends RegistrationEvent {
  final BuildContext context;

  const RegistrationPageLoadEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class RegistrationSelectUserRoleEvent extends RegistrationEvent {
  final RegistrationModel registrationData;

  const RegistrationSelectUserRoleEvent({required this.registrationData});

  @override
  List<Object?> get props => [registrationData];
}

class RegistrationEditEvent extends RegistrationEvent {
  final DriverModel driverData;
  final bool isEdit;

  const RegistrationEditEvent({required this.isEdit, required this.driverData});

  @override
  List<Object?> get props => [driverData, isEdit];
}

class RegistrationUploadPhotoEvent extends RegistrationEvent {
  final int photoIndex;
  final BuildContext context;

  RegistrationUploadPhotoEvent(
      {required this.photoIndex, required this.context});

  @override
  List<Object?> get props => [photoIndex, context];
}

class RegistrationSubmitEvent extends RegistrationEvent {
  final BuildContext context;
  final RoleType roleType;

  const RegistrationSubmitEvent(
      {required this.context, required this.roleType});

  @override
  List<Object?> get props => [context, roleType];
}
