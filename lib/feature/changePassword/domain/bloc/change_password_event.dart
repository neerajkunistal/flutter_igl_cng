part of 'change_password_bloc.dart';

abstract class ChangePasswordEvent extends Equatable {}

class PageLoadingEvent extends ChangePasswordEvent {
  @override
  List<Object?> get props => [];
}

class SetNewPassword extends ChangePasswordEvent {
  final String newPassword;

  SetNewPassword({required this.newPassword});

  @override
  List<Object?> get props => [newPassword];
}

class SetConfirmPassword extends ChangePasswordEvent {
  final String confirmPassword;

  SetConfirmPassword({required this.confirmPassword});

  @override
  List<Object?> get props => [confirmPassword];
}

class OldPasswordVisibility extends ChangePasswordEvent {
  final bool isOldPasswordVisibility;

  OldPasswordVisibility({required this.isOldPasswordVisibility});

  @override
  List<Object?> get props => [isOldPasswordVisibility];
}

class NewPasswordVisibility extends ChangePasswordEvent {
  final bool isNewPasswordVisibility;

  NewPasswordVisibility({required this.isNewPasswordVisibility});

  @override
  List<Object?> get props => [isNewPasswordVisibility];
}

class ConfirmPasswordVisibility extends ChangePasswordEvent {
  final bool isConfirmPasswordVisibility;

  ConfirmPasswordVisibility({required this.isConfirmPasswordVisibility});

  @override
  List<Object?> get props => [isConfirmPasswordVisibility];
}

class PasswordSubmitEvent extends ChangePasswordEvent {
  final BuildContext context;

  PasswordSubmitEvent({required this.context});

  @override
  List<Object?> get props => [context];
}
