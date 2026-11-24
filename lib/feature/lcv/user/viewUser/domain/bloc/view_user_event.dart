part of 'view_user_bloc.dart';

abstract class ViewUserEvent extends Equatable {
  const ViewUserEvent();
}

class ViewUserPageLoadEvent extends ViewUserEvent {
  final BuildContext context;

  const ViewUserPageLoadEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class ViewUserDeleteEvent extends ViewUserEvent {
  final BuildContext context;
  final int index;

  const ViewUserDeleteEvent({required this.context, required this.index});

  @override
  List<Object?> get props => [context, index];
}
