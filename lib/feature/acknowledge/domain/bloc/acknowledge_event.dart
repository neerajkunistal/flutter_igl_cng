part of 'acknowledge_bloc.dart';

abstract class AcknowledgeEvent extends Equatable {
  const AcknowledgeEvent();
}

class AcknowledgePageLoadEvent extends AcknowledgeEvent {
  final BuildContext context;

  const AcknowledgePageLoadEvent({required this.context});

  @override
  List<Object?> get props => [context];
}
