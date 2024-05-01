import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/home/domain/bloc/home_bloc.dart';
import 'package:flutter_igl_cng/feature/home/presentation/widget/home_drawer_widget.dart';

class PhoneHomeWidget extends StatefulWidget {
  const PhoneHomeWidget({super.key});

  @override
  State<PhoneHomeWidget> createState() => _PhoneHomeWidgetState();
}

class _PhoneHomeWidgetState extends State<PhoneHomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: HomeDrawerWidget(),
        appBar: AppBar(
          elevation: 0,
          title:BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if(state is FetchHomeDataState){
                  return TextWidget(state.title,
                    color: AppColor.white, fontSize: AppFont.font_14, fontWeight: FontWeight.w700,);
                } else {
                  return TextWidget(AppString.appName,
                    color: AppColor.white, fontSize: AppFont.font_14, fontWeight: FontWeight.w700,);
                }
              }
          ),
          actions: [
            BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if(state is FetchHomeDataState){
                    return state.actionButtonWidget;
                  } else {
                    return const SizedBox.shrink();
                  }
                }
            ),
            Image.asset(AppIcon.appLogoIgl),
          ],
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if(state is FetchHomeDataState){
                return state.childWidget;
              } else {
                return const Center(child: CenterLoaderWidget(),);
              }
            }
        )
    );
  }
}
