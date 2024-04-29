import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/feature/login/presentations/Widgets/phone_login_widget.dart';
import 'package:flutter_igl_cng/feature/login/presentations/Widgets/tablet_login_widget.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/message_box_pop_button_widget.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/message_box_two_button_pop.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/utils/commonClass/app_config.dart';
import '../../domain/bloc/login_bloc.dart';
import '../../domain/bloc/login_event.dart';
import '../../domain/bloc/login_state.dart';
import '../Widgets/bottom_right_circle.dart';
import '../Widgets/top_right_circle.dart';

class LoginScreenPage extends StatefulWidget {
  const LoginScreenPage({Key? key}) : super(key: key);

  @override
  State<LoginScreenPage> createState() => _LoginScreenPageState();
}

class _LoginScreenPageState extends State<LoginScreenPage> {

   @override
  void initState() {
     BlocProvider.of<LoginBloc>(context).add(LoginPageLoadingEvent());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      resizeToAvoidBottomInset: true,
      body: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if(state is FetchLoginStateData){
            return Center(
              child: AppConfig.getDeviceType(context: context) == DeviceType.phone
                  ? PhoneLoginWidget(dataState: state)
                  : TabletLoginWidget(dataState: state,) ,
            );
          } else{
            return const Center(child: CenterLoaderWidget(),);
          }
        },
      ),
    );
  }
}
