part of 'view_cng_scm_bloc.dart';

abstract class ViewCngScmEvent extends Equatable {
  const ViewCngScmEvent();
}

class ViewCngScmPageLoadEvent extends ViewCngScmEvent {
  final BuildContext context;

  const ViewCngScmPageLoadEvent({required this.context});

  @override
  List<Object?> get props => [context];
}
