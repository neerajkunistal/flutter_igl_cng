part of 'over_speed_alert_bloc.dart';

sealed class OverSpeedAlertState extends Equatable {
  const OverSpeedAlertState();
}

final class OverSpeedAlertInitial extends OverSpeedAlertState {
  @override
  List<Object> get props => [];
}

final class OverSpeedAlertPageLoadState extends OverSpeedAlertInitial {
  @override
  List<Object> get props => [];
}

final class FetchOverSpeedAlertDataState extends OverSpeedAlertInitial {
  final List<OverSpeedAlertModel> overSpeedAlertList;
  final bool isLoader;

  FetchOverSpeedAlertDataState({
   required this.isLoader,
   required this.overSpeedAlertList});

  @override
  List<Object> get props => [isLoader, overSpeedAlertList];
}