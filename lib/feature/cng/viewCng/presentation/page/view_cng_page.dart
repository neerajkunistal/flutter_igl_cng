import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/cng/addCng/domain/bloc/add_cng_bloc.dart';
import 'package:flutter_igl_cng/feature/cng/addCng/presentation/pages/add_cng_page.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/domain/domain/bloc/view_cng_bloc.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/presentation/widget/view_cng_item_box_widget.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/date_range_pop_widget.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/dotted_line_widget.dart';

class ViewCngPage extends StatefulWidget {
  const ViewCngPage({super.key});

  @override
  State<ViewCngPage> createState() => _ViewCngPageState();
}

class _ViewCngPageState extends State<ViewCngPage> {
  @override
  void initState() {
    BlocProvider.of<ViewCngBloc>(!context.mounted ? context : context)
        .add(ViewCngPageLoadEvent());
    super.initState();
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      backgroundColor: AppColor.themeColor,
      onPressed: () async {
        var res = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddCngPage()),
        );
        if (res != null && res.toString() == "complete") {
          if (!context.mounted) return;
          BlocProvider.of<ViewCngBloc>(!context.mounted ? context : context)
              .add(ViewCngPageLoadEvent());
        }
      },
      child: Icon(
        Icons.add,
        color: AppColor.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: _floatingActionButton(),
      body: appBackGround(
        context: context,
        child: BlocBuilder<ViewCngBloc, ViewCngState>(
          builder: (context, state) {
            if (state is FetchViewCngDataState) {
              return _listBuilder(dataState: state);
            }
            return const CenterLoaderWidget();
          },
        ),
      ),
    );
  }

  Widget _listBuilder({required FetchViewCngDataState dataState}) {
    return Container(
      margin: const EdgeInsets.all(0.0),
      child: Column(
        children: [
          _header(),
          const DottedDividerLine(color: Colors.white),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          dataState.cngList.isNotEmpty
              ? Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Colors.white.withOpacity(.4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: ListView.builder(
                        itemCount: dataState.cngList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0,),
                            child: ViewCngItemBoxWidget(
                              index: index,
                              cngData: dataState.cngList[index],
                            ),
                          );
                        }),
                  ),
                ),
              )
              : const Center(
                  child: TextWidget("No Data"),
                ),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(children: [
      IconButton(onPressed: () {
        Navigator.pop(context);
      }, icon: const Icon(Icons.arrow_back, color: Colors.white,)),

      SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
      Expanded(
        child: TextWidget(
          "View Civil Complaint",
          color: AppColor.white,
          fontSize: AppFont.font_15,
          fontWeight: FontWeight.w600,
        ),
      ),
      Image.asset(
        AppConfig.instanceInit()!.client == Client.iglcng
            ? AppIcon.appLogoIgl
            : AppIcon.appLogoIgl,
        height: MediaQuery.of(context).size.width * 0.13,
        width: MediaQuery.of(context).size.width * 0.13,
      ),
      SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
    ]);
  }
}


