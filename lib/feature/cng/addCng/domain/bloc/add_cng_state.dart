part of 'add_cng_bloc.dart';

sealed class AddCngState extends Equatable {
  const AddCngState();
}

final class AddCngInitial extends AddCngState {
  @override
  List<Object> get props => [];
}
