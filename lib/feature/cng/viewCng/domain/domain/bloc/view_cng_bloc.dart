import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'view_cng_event.dart';
part 'view_cng_state.dart';

class ViewCngBloc extends Bloc<ViewCngEvent, ViewCngState> {
  ViewCngBloc() : super(ViewCngInitial()) {
    on<ViewCngEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
