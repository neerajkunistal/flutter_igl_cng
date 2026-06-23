import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/changePassword/helper/change_password_helper.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  bool _isLoader = false;

  bool get isLoader => _isLoader;

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool _isOldPasswordVisibility = true;

  bool get isOldPasswordVisibility => _isOldPasswordVisibility;

  bool _isNewPasswordVisibility = true;

  bool get isNewPasswordVisibility => _isNewPasswordVisibility;

  bool _isConfirmPasswordVisibility = true;

  bool get isConfirmPasswordVisibility => _isConfirmPasswordVisibility;


  ChangePasswordBloc() : super(ChangePasswordInitial()) {
    on<PageLoadingEvent>(_pageLoading);
    on<OldPasswordVisibility>(_oldPasswordVisibility);
    on<NewPasswordVisibility>(_newPasswordVisibility);
    on<ConfirmPasswordVisibility>(_confirmPasswordVisibility);
    on<PasswordSubmitEvent>(_submitPassword);
  }

  _pageLoading(PageLoadingEvent event, emit) async {
    _isLoader = false;
    _isConfirmPasswordVisibility = true;
    _isOldPasswordVisibility = true;
    _isNewPasswordVisibility = true;
    oldPasswordController.text = "";
    newPasswordController.text = "";
    confirmPasswordController.text = "";
    _eventCompleted(emit);
  }

  _oldPasswordVisibility(OldPasswordVisibility event, emit) {
    _isOldPasswordVisibility = event.isOldPasswordVisibility;
    _eventCompleted(emit);
  }

  _newPasswordVisibility(NewPasswordVisibility event, emit) {
    _isNewPasswordVisibility = event.isNewPasswordVisibility;
    _eventCompleted(emit);
  }

  _confirmPasswordVisibility(ConfirmPasswordVisibility event, emit) {
    _isConfirmPasswordVisibility = event.isConfirmPasswordVisibility;
    _eventCompleted(emit);
  }

  _submitPassword(PasswordSubmitEvent event, emit) async {
    var textFiledValidationCheck =
        await ChangePasswordHelper.textFieldValidationCheck(
            oldPassword: oldPasswordController.text.toString(),
            newPassword: newPasswordController.text.toString(),
            confirmPassword: confirmPasswordController.text.toString(),
            context: event.context);
    if (textFiledValidationCheck == true) {
      _isLoader = true;
      _eventCompleted(emit);
      var res = await ChangePasswordHelper.passwordSaveOnServer(
          newPassword: newPasswordController.text.toString(),
          context: !event.context.mounted ? event.context : event.context);
      if(res != null) {
        await SharedPreferencesUtils.setString(key: PreferencesName.password,
            value: confirmPasswordController.text.toString());
        oldPasswordController.text = "";
        newPasswordController.text = "";
        confirmPasswordController.text = "";
      }
      _isLoader = false;
      _eventCompleted(emit);
    }
  }

  _eventCompleted(Emitter<ChangePasswordState> emit) async {
    emit(ChangePageLoadingState(
        isLoader: isLoader,
        newPasswordController: newPasswordController,
        confirmPasswordController: confirmPasswordController,
        isConfirmPasswordVisibility: isConfirmPasswordVisibility,
        isNewPasswordVisibility: isNewPasswordVisibility,
        oldPasswordController: oldPasswordController,
        isOldPasswordVisibility: isOldPasswordVisibility));
  }
}
