part of 'material_detail_bloc.dart';

sealed class MaterialDetailEvent extends Equatable {
  const MaterialDetailEvent();
}

class MaterialDetailPageLoadEvent extends MaterialDetailEvent {
  @override
  List<Object?> get props => [];
}

class MaterialDetailSearchEvent extends MaterialDetailEvent {
  final BuildContext context;
  const MaterialDetailSearchEvent({required this.context});
  @override
  List<Object?> get props => [context];
}