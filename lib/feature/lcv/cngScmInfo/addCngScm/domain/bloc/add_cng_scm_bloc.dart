import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/cngScmInfo/addCngScm/helper/add_cng_scm_helper.dart';
import 'package:flutter_igl_cng/feature/lcv/cngScmInfo/viewCngScm/domain/bloc/view_cng_scm_bloc.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

part 'add_cng_scm_event.dart';
part 'add_cng_scm_state.dart';

class AddCngScmBloc extends Bloc<AddCngScmEvent, AddCngScmState> {
  bool _isLoader = false;

  bool get isLoader => _isLoader;

  TextEditingController currentScmController = TextEditingController();
  TextEditingController sellScmController = TextEditingController();
  TextEditingController remainScnController = TextEditingController();
  TextEditingController requiredScmController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  LoginDataModel _userData = UserInfo.instance!.userData!;

  LoginDataModel get userData => _userData;

  AddCngScmBloc() : super(AddCngScmInitial()) {
    on<AddCngScmPageLoadEvent>(_pageLoad);
    on<AddCngScmSubmitEvent>(_submit);
  }

  _pageLoad(AddCngScmPageLoadEvent event, emit) async {
    emit(AddCngScmPageLoadState());
    _isLoader = false;
    _userData = UserInfo.instance!.userData!;
    currentScmController.text = "";
    sellScmController.text = "";
    remainScnController.text = "";
    requiredScmController.text = "";
    remarkController.text = "";
    _eventCompleted(emit);
  }

  _submit(AddCngScmSubmitEvent event, emit) async {
    _isLoader = false;
    var textFieldValidation = await AddCngScmHelper.textFieldValidation(
        context: event.context,
        currentScm: currentScmController.text.toString(),
        sellScm: sellScmController.text.toString(),
        remainScm: remainScnController.text.toString(),
        requiredScm: requiredScmController.text.toString());
    if (textFieldValidation == false) {
      return;
    }
    _isLoader = true;
    _eventCompleted(emit);
    var res = await AddCngScmHelper.submitCngScmData(
        context: event.context,
        currentScm: currentScmController.text.toString(),
        sellScm: sellScmController.text.toString(),
        remainScm: remainScnController.text.toString(),
        requiredScm: requiredScmController.text.toString(),
        userData: userData);
    _isLoader = false;
    _eventCompleted(emit);
    if (res != null) {
      currentScmController.text = "";
      sellScmController.text = "";
      remainScnController.text = "";
      requiredScmController.text = "";
      remarkController.text = "";
      _eventCompleted(emit);
      BlocProvider.of<ViewCngScmBloc>(event.context)
          .add(ViewCngScmPageLoadEvent(context: event.context));
    }
  }

  _eventCompleted(Emitter<AddCngScmState> emit) {
    emit(FetchAddCngScmDataState(
      isLoader: isLoader,
      remarkController: remarkController,
      currentScmController: currentScmController,
      remainScnController: remainScnController,
      requiredScmController: requiredScmController,
      sellScmController: sellScmController,
    ));
  }
}
