part of 'add_scrap_bloc.dart';

sealed class AddScrapEvent extends Equatable {
  const AddScrapEvent();
}

class AddScrapPageLoadEvent extends AddScrapEvent {
  @override
  List<Object?> get props => [];
}

class AddScrapSelectFileEvent extends AddScrapEvent {
  final BuildContext context;
  final int mediaType;
  final int index;
  const AddScrapSelectFileEvent({
    required this.context,
    required this.mediaType,
    required this.index});
  @override
  List<Object?> get props => [context, mediaType, index];
}

class AddScrapSelectScrapUnitTypeEvent extends AddScrapEvent {
  final ScrapUnitTypeModel scrapUnitTypeData;
  const AddScrapSelectScrapUnitTypeEvent({required this.scrapUnitTypeData});
  @override
  List<Object?> get props => [scrapUnitTypeData];
}

class AddScrapDestroyEvent extends AddScrapEvent {
  final String destroyReusable;
  const AddScrapDestroyEvent({required this.destroyReusable});
  @override
  List<Object?> get props => [destroyReusable];
}

class AddScrapDeleteEvent extends AddScrapEvent {
  final int index;
  const AddScrapDeleteEvent({required this.index});
  @override
  List<Object?> get props => [index];
}

class AddScrapClearScrapDataEvent extends AddScrapEvent {
  final BuildContext context;
  const AddScrapClearScrapDataEvent({required this.context});
  @override
  List<Object?> get props => [context];
}

class AddScrapSubmitEvent extends AddScrapEvent {
  final BuildContext context;
  const AddScrapSubmitEvent({required this.context});
  @override
  List<Object?> get props => [context];
}