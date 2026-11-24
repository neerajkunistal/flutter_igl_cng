part of 'change_password_bloc.dart';

abstract class ChangePasswordState extends Equatable {
  const ChangePasswordState();
}

class ChangePasswordInitial extends ChangePasswordState {
  @override
  List<Object> get props => [];
}

class ChangePageLoadingState extends ChangePasswordInitial {
  final bool isLoader;
  final TextEditingController oldPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final bool isOldPasswordVisibility;
  final bool isNewPasswordVisibility;
  final bool isConfirmPasswordVisibility;

  ChangePageLoadingState(
      {required this.isLoader,
      required this.oldPasswordController,
      required this.newPasswordController,
      required this.confirmPasswordController,
      required this.isOldPasswordVisibility,
      required this.isConfirmPasswordVisibility,
      required this.isNewPasswordVisibility});

  @override
  List<Object> get props => [
        isLoader,
        oldPasswordController,
        newPasswordController,
        confirmPasswordController,
        isOldPasswordVisibility,
        isNewPasswordVisibility,
        isConfirmPasswordVisibility
      ];
}
