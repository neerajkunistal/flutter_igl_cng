part of 'pod_detail_bloc.dart';

sealed class PodDetailEvent extends Equatable {
  const PodDetailEvent();
}

class PodDetailPageLoadEvent extends PodDetailEvent {
  @override
  List<Object?> get props => [];
}

class PodDetailSearchEvent extends PodDetailEvent {
  final BuildContext context;
  const PodDetailSearchEvent({required this.context});
  @override
  List<Object?> get props => [context];
}