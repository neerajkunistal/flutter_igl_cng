part of 'view_cng_bloc.dart';

sealed class ViewCngEvent extends Equatable {
  const ViewCngEvent();
}

class ViewCngPageLoadEvent extends ViewCngEvent {
  @override
  List<Object?> get props => [];
}

class ViewCngSearchEvent extends ViewCngEvent {
  final String keyword;

  const ViewCngSearchEvent({required this.keyword});

  @override
  List<Object?> get props => [keyword];
}

class ViewCngSelectedDateRangeEvent extends ViewCngEvent {
  final BuildContext context;
  final DateTime fromDate;
  final DateTime toDate;

  const ViewCngSelectedDateRangeEvent(
      {required this.context, required this.fromDate, required this.toDate});

  @override
  List<Object?> get props => [context];
}
