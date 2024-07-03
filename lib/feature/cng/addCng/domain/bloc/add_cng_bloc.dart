import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_cng_event.dart';
part 'add_cng_state.dart';

class AddCngBloc extends Bloc<AddCngEvent, AddCngState> {
  AddCngBloc() : super(AddCngInitial()) {
    on<AddCngEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
