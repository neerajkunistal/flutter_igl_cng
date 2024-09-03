part of 'add_cng_scm_bloc.dart';

abstract class AddCngScmState extends Equatable {
  const AddCngScmState();
}

class AddCngScmInitial extends AddCngScmState {
  @override
  List<Object> get props => [];
}

class AddCngScmPageLoadState extends AddCngScmInitial {
  @override
  List<Object> get props => [];
}

class FetchAddCngScmDataState extends AddCngScmState {
  final bool isLoader;
  final TextEditingController currentScmController;
  final TextEditingController sellScmController;
  final TextEditingController remainScnController;
  final TextEditingController requiredScmController;
  final TextEditingController remarkController;

  const FetchAddCngScmDataState({
    required this.isLoader,
    required this.remarkController,
    required this.currentScmController,
    required this.remainScnController,
    required this.requiredScmController,
    required this.sellScmController,
  });

  @override
  List<Object> get props => [
        isLoader,
        currentScmController,
        sellScmController,
        remainScnController,
        requiredScmController,
        remarkController
      ];
}
