part of 'acknowledge_bloc.dart';

abstract class AcknowledgeState extends Equatable {
  const AcknowledgeState();
}

class AcknowledgeInitial extends AcknowledgeState {
  @override
  List<Object> get props => [];
}

class AcknowledgePageLoadState extends AcknowledgeInitial {
  @override
  List<Object> get props => [];
}

class FetchAcknowledgeDataState extends AcknowledgeInitial {
  final bool isLoader;
  final List<AcknowledgeModel> acknowledgeList;

  FetchAcknowledgeDataState(
      {required this.acknowledgeList, required this.isLoader});

  @override
  List<Object> get props => [acknowledgeList, isLoader];
}
