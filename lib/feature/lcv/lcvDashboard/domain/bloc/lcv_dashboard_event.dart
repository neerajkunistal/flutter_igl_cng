part of 'lcv_dashboard_bloc.dart';

sealed class LcvDashboardEvent extends Equatable {
  const LcvDashboardEvent();
}

class LcvDashboardPageLoadEvent extends LcvDashboardEvent {
  final BuildContext context;

  const LcvDashboardPageLoadEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class LcvDashboardPageRefreshEvent extends LcvDashboardEvent {
  final BuildContext context;

  const LcvDashboardPageRefreshEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class LcvDashboardDrawerItemSelectedEvent extends LcvDashboardEvent {
  final bool isSelected;
  final int index;
  final BuildContext context;

  const LcvDashboardDrawerItemSelectedEvent(
      {required this.isSelected, required this.index, required this.context});

  @override
  List<Object?> get props => [isSelected, index, context];
}

class LcvDashboardDrawerItemSubListSelectedEvent extends LcvDashboardEvent {
  final bool isSelected;
  final int index;
  final int listIndex;

  const LcvDashboardDrawerItemSubListSelectedEvent({
    required this.isSelected,
    required this.index,
    required this.listIndex,
  });

  @override
  List<Object?> get props => [isSelected, index, listIndex];
}

class LcvDashboardChangeBottomNavigationItemEvent extends LcvDashboardEvent {
  final int index;
  final BuildContext context;

  const LcvDashboardChangeBottomNavigationItemEvent(
      {required this.context, required this.index});

  @override
  List<Object?> get props => [context, index];
}

class LcvDashboardPageNotificationSilentEvent extends LcvDashboardEvent {
  final BuildContext context;

  const LcvDashboardPageNotificationSilentEvent({required this.context});

  @override
  List<Object?> get props => [context];
}
