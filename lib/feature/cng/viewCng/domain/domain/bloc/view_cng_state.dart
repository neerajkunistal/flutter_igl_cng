part of 'view_cng_bloc.dart';

sealed class ViewCngState extends Equatable {
  const ViewCngState();
}

final class ViewCngInitial extends ViewCngState {
  @override
  List<Object> get props => [];
}
