part of 'add_cng_scm_bloc.dart';

abstract class AddCngScmEvent extends Equatable {
  const AddCngScmEvent();
}

class AddCngScmPageLoadEvent extends AddCngScmEvent {
  final BuildContext context;

  const AddCngScmPageLoadEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class AddCngScmSubmitEvent extends AddCngScmEvent {
  final BuildContext context;

  const AddCngScmSubmitEvent({required this.context});

  @override
  List<Object?> get props => [context];
}
