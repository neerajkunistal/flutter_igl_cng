import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/changePassword/domain/bloc/change_password_bloc.dart';


class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  @override
  void initState() {
    BlocProvider.of<ChangePasswordBloc>(context).add(PageLoadingEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme:
            const IconThemeData(size: 30.0, color: Colors.black, opacity: 10.0),
        title: TextWidget(
          "Change Password",
          fontSize: AppFont.font_16,
          fontWeight: FontWeight.w700,
          color: AppColor.white,
        ),
      ),
      body: BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
        builder: (context, state) {
          if (state is ChangePageLoadingState) {
            return _itemBuilder(dataState: state);
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _itemBuilder({required ChangePageLoadingState dataState}) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _horizontalSpace(),
              _appLogo(),
              _horizontalSpace(),
              _oldPasswordTextField(dataState: dataState),
              _horizontalSpace(),
              _newPasswordTextField(dataState: dataState),
              _horizontalSpace(),
              _confirmPasswordTextField(dataState: dataState),
              _horizontalSpace(),
              _submit(dataState: dataState),
              _horizontalSpace(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appLogo() {
    return Hero(
      tag: 'logo',
      child: Image.asset(
        AppConfig.instanceInit()!.client == Client.iglcng
            ? AppIcon.appLogoIgl
            : AppConfig.instanceInit()!.client == Client.pbgplCNG
            ? AppIcon.appLogoPurvaBharti : AppIcon.appLogoIgl,
        width: MediaQuery.of(context).size.width * 0.30,
      ),
    );
  }

  Widget _oldPasswordTextField({required ChangePageLoadingState dataState}) {
    return TextFieldPasswordWidget(
      isBoardRemove: true,
      isRequired: true,
      labelText: AppString.oldPassword,
      obscureText: dataState.isOldPasswordVisibility,
      isPasswordIcon: true,
      textEditingController: dataState.oldPasswordController,
      passwordOnPressed: () {
        BlocProvider.of<ChangePasswordBloc>(context).add(OldPasswordVisibility(
            isOldPasswordVisibility:
                dataState.isOldPasswordVisibility == true ? false : true));
      },
    );
  }

  Widget _newPasswordTextField({required ChangePageLoadingState dataState}) {
    return TextFieldPasswordWidget(
      isBoardRemove: true,
      isRequired: true,
      labelText: AppString.newPassword,
      obscureText: dataState.isNewPasswordVisibility,
      isPasswordIcon: true,
      textEditingController: dataState.newPasswordController,
      passwordOnPressed: () {
        BlocProvider.of<ChangePasswordBloc>(context).add(NewPasswordVisibility(
            isNewPasswordVisibility:
                dataState.isNewPasswordVisibility == true ? false : true));
      },
    );
  }

  Widget _confirmPasswordTextField(
      {required ChangePageLoadingState dataState}) {
    return TextFieldPasswordWidget(
      isBoardRemove: true,
      isRequired: true,
      labelText: AppString.confirmPassword,
      obscureText: dataState.isConfirmPasswordVisibility,
      isPasswordIcon: true,
      textEditingController: dataState.confirmPasswordController,
      passwordOnPressed: () {
        BlocProvider.of<ChangePasswordBloc>(context).add(
            ConfirmPasswordVisibility(
                isConfirmPasswordVisibility:
                    dataState.isConfirmPasswordVisibility == true
                        ? false
                        : true));
      },
    );
  }

  Widget _submit({required ChangePageLoadingState dataState}) {
    return dataState.isLoader == false
        ? ButtonWidget(
            text: AppString.submit,
            onPressed: () {
              BlocProvider.of<ChangePasswordBloc>(context)
                  .add(PasswordSubmitEvent(context: context));
            })
        : const DottedLoaderWidget();
  }

  _horizontalSpace() {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.07,
    );
  }
}
