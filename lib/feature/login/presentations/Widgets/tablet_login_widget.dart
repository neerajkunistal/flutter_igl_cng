import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/login/domain/bloc/login_event.dart';
import 'package:flutter_igl_cng/feature/login/domain/bloc/login_state.dart';

class TabletLoginWidget extends StatefulWidget {
  final FetchLoginStateData dataState;
  const TabletLoginWidget({super.key, required this.dataState});

  @override
  State<TabletLoginWidget> createState() => _TabletLoginWidgetState();
}

class _TabletLoginWidgetState extends State<TabletLoginWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.white,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.04,
                right: MediaQuery.of(context).size.width * 0.04),
              child: Center(child: _logoWithTextWidget()),
            ),
          ),
          Expanded(
            child: _rightRowWidget(dataState: widget.dataState),
          ),
        ],
      ),
    );
  }

  Widget _logoWithTextWidget() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Card(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _logo(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.08,
                  ),
                  TextWidget(AppString.appName,
                    fontSize: AppFont.font_18, fontWeight: FontWeight.w700,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _logo() {
    return Hero(
      tag: 'logo',
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.27,
        child: Stack(
          children: [
            Positioned(
              left: 00.0,
              top:  00.0,
              right: 00.0,
              bottom: MediaQuery.of(context).size.height * 0.13,
              child: Image.asset(AppConfig.instanceInit()!.client == Client.iglcng ?
                   AppIcon.appLogoIgl
                  : AppIcon.appLogoIgl,
                width: MediaQuery.of(context).size.width * 0.30,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                AppIcon.colourStrip,
                color: AppColor.themeColor,
                fit: BoxFit.cover,
/*                width: MediaQuery.of(context).size.width/2.3,*/
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rightRowWidget({required FetchLoginStateData dataState}) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _emailTextField(dataState: dataState),
          _verticalSpace(),
          _passwordTextField(dataState: dataState),
          _verticalSpace(),
/*          _forgotPassword(dataState: dataState),*/
          _loginButton(dataState: dataState),
        ],
      ),
    );
  }

  Widget _emailTextField({required FetchLoginStateData dataState}) {
    return Padding(
      padding:  EdgeInsets.only(left : MediaQuery.of(context).size.width * 0.05,
        right: MediaQuery.of(context).size.width * 0.05,),
      child: TextFieldWidget(
        isRequired: true,
        labelText: AppString.userName,
        textInputType: TextInputType.emailAddress,
        controller: dataState.userNameTextFiledController,
        onChanged: (value) => BlocProvider.of<LoginBloc>(context).add(LoginSetEmailEvent(emailId: value)),
      ),
    );
  }

  Widget _passwordTextField({required FetchLoginStateData dataState}) {
    return Padding(
      padding:  EdgeInsets.only(left : MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05,),
      child: TextFieldPasswordWidget(
        isRequired: true,
        labelText: AppString.password,
        obscureText: dataState.isPassword,
        isPasswordIcon: true,
        textEditingController: dataState.passwordTextFieldController,
        passwordOnPressed: () {
          BlocProvider.of<LoginBloc>(context).add(
              LoginPasswordHideShowEvent(
                  isPassword:  dataState.isPassword == true ? false : true));
        },
        onChanged: (value) => BlocProvider.of<LoginBloc>(context).add(LoginSetPasswordEvent(password: value)),
      ),
    );
  }


  Widget _loginButton({required FetchLoginStateData dataState}) {
    return dataState.isLoader == false ?
    Padding(
      padding:  EdgeInsets.only(left : MediaQuery.of(context).size.width * 0.05,
        right: MediaQuery.of(context).size.width * 0.05,),
      child: ButtonWidget(
          height: MediaQuery.of(context).size.height * 0.10,
          isLockIcon: true,
          text: AppString.login,
          onPressed: () {
            BlocProvider.of<LoginBloc>(context).add(LoginSubmitDataEvent(context: context, isLoginPage: true));
          }),
    ): const DottedLoaderWidget();
  }

  _verticalSpace() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.04,
    );
  }

}
