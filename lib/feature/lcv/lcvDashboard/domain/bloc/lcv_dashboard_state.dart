part of 'lcv_dashboard_bloc.dart';

sealed class LcvDashboardState extends Equatable {
  const LcvDashboardState();
}

class LcvDashboardInitial extends LcvDashboardState {
  @override
  List<Object> get props => [];
}

class LcvDashboardPageLoadState extends LcvDashboardInitial {
  @override
  List<Object> get props => [];
}

class FetchLcvDashboardDataState extends LcvDashboardInitial {
  final bool isLoader;
  final List<BottomNavigationBarItem> bottomNavigationBarItemList;
  final int bottomTabIndex;
  final RoleType roleType;
  final List<Widget> pageWidgetList;
  final Widget childWidget;
  final Widget actionButtonWidget;
  final String title;
  final bool isNotificationSilent;
  final List<OverSpeedAlertModel> overSpeedAlertList;

  FetchLcvDashboardDataState({
    required this.isLoader,
    required this.bottomNavigationBarItemList,
    required this.bottomTabIndex,
    required this.roleType,
    required this.pageWidgetList,
    required this.childWidget,
    required this.title,
    required this.actionButtonWidget,
    required this.isNotificationSilent,
    required this.overSpeedAlertList,
  });

  @override
  List<Object> get props => [
    isLoader,
    bottomNavigationBarItemList,
    bottomTabIndex,
    roleType,
    pageWidgetList,
    childWidget,
    title,
    actionButtonWidget,
    isNotificationSilent,
    overSpeedAlertList,
  ];
}