part of 'view_cng_bloc.dart';

sealed class ViewCngEvent extends Equatable {
  const ViewCngEvent();
}

class ViewCngPageLoadEvent extends ViewCngEvent {
  @override
  List<Object?> get props => [];
}

