part of 'add_cng_bloc.dart';

sealed class AddCngEvent extends Equatable {
  const AddCngEvent();
}

class AddCngPageLoadEvent extends AddCngEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class AddCngSelectDateEvent extends AddCngEvent {
  final BuildContext context;

  const AddCngSelectDateEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class AddCngSelectTimeEvent extends AddCngEvent {
  final BuildContext context;

  const AddCngSelectTimeEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class AddCngSelectFileEvent extends AddCngEvent {
  final BuildContext context;
  final int mediaType;
  final int index;

  const AddCngSelectFileEvent({required this.context, required this.mediaType, required this.index});

  @override
  List<Object?> get props => [context, mediaType];
}

class AddCngFileDeleteEvent extends AddCngEvent {
  final int index;

  const AddCngFileDeleteEvent({required this.index});

  @override
  List<Object?> get props => [index];
}

class AddCngSelectCategoryDataEvent extends AddCngEvent {
  final CategoryModel categoryData;

  const AddCngSelectCategoryDataEvent({required this.categoryData});

  @override
  List<Object?> get props => [categoryData];
}

class AddCngSubmitEvent extends AddCngEvent {
  final BuildContext context;

  const AddCngSubmitEvent({required this.context});

  @override
  List<Object?> get props => [context];
}
