part of 'add_user_bloc.dart';

abstract class AddUserEvent extends Equatable {
  const AddUserEvent();
}

class AddUserPageLoadEvent extends AddUserEvent {
  final BuildContext context;

  const AddUserPageLoadEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class AddUserSetCngStationDataEvent extends AddUserEvent {
  final CngStationModel cngStationData;

  const AddUserSetCngStationDataEvent({required this.cngStationData});

  @override
  List<Object?> get props => [cngStationData];
}

class AddUserEditEvent extends AddUserEvent {
  final UserModel userData;
  final bool isEdit;

  const AddUserEditEvent({required this.userData, required this.isEdit});

  @override
  List<Object?> get props => [userData, isEdit];
}

class AddUserSubmitEvent extends AddUserEvent {
  final BuildContext context;

  const AddUserSubmitEvent({required this.context});

  @override
  List<Object?> get props => [context];
}
