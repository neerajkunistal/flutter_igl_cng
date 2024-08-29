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

class ViewCngSelectTabEvent extends ViewCngEvent {
  final int tabIndex;
  const ViewCngSelectTabEvent({required this.tabIndex});
  @override
  List<Object?> get props => [tabIndex];
}

class ViewCngSelectIndexEvent extends ViewCngEvent {
  final int listIndex;
  const ViewCngSelectIndexEvent({required this.listIndex});
  @override
  List<Object?> get props => [listIndex];
}

class ViewCngCloserRequestEvent extends ViewCngEvent {
  final BuildContext context;
  const ViewCngCloserRequestEvent({required this.context});
  @override
  List<Object?> get props => [context];
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
