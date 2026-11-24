part of 'add_spare_part_bloc.dart';

sealed class AddSparePartEvent extends Equatable {
  const AddSparePartEvent();
}

class AddSparePartPageLoadEvent extends AddSparePartEvent {
  final BuildContext context;
  const AddSparePartPageLoadEvent({required this.context});
  @override
  List<Object?> get props => [context]; // SparesModel
}

class AddSparePartClearSparePartEvent extends AddSparePartEvent {
  @override
  List<Object?> get props => []; // SparesModel
}

class AddSparePartSelectPartEvent extends AddSparePartEvent {
  final SparesModel sparesData;
  const AddSparePartSelectPartEvent({required this.sparesData});
  @override
  List<Object?> get props => [sparesData]; // SparesModel
}

class AddSparePartDeletePartEvent extends AddSparePartEvent {
  final int index;
  const AddSparePartDeletePartEvent({required this.index});
  @override
  List<Object?> get props => [index]; // SparesModel
}

class AddSparePartSubmitEvent extends AddSparePartEvent {
  final BuildContext context;
  const AddSparePartSubmitEvent({required this.context});
  @override
  List<Object?> get props => [context]; // SparesModel
}