import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class CngStationEvent extends Equatable {
  const CngStationEvent();
}

class CngStationDeleteStationEvent extends CngStationEvent {
  final BuildContext context;
  final int index;

  const CngStationDeleteStationEvent(
      {required this.context, required this.index});

  @override
  List<Object?> get props => [context, index];
}

class CngStationPageLoadEvent extends CngStationEvent {
  final BuildContext context;

  const CngStationPageLoadEvent({required this.context});

  @override
  List<Object?> get props => [context];
}
