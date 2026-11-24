import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/materialDetail/domain/bloc/material_detail_bloc.dart';
import 'package:flutter_igl_cng/feature/materialDetail/presentation/widget/material_data_table_builder_item_box_widget.dart';
import 'package:flutter_igl_cng/feature/materialDetail/presentation/widget/material_detail_item_box_widget.dart';
import 'package:flutter_igl_cng/feature/materialDetail/presentation/widget/material_list_header_widget.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/dotted_line_widget.dart';

class MaterialDetailPage extends StatefulWidget {
  const MaterialDetailPage({super.key});

  @override
  State<MaterialDetailPage> createState() => _MaterialDetailPageState();
}

class _MaterialDetailPageState extends State<MaterialDetailPage> {

  @override
  void initState() {
    BlocProvider.of<MaterialDetailBloc>(context).add(MaterialDetailPageLoadEvent());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: appBackGround(
        context: context,
        child: Column(
          children: [
            _appBar(),
            const DottedDividerLine(color: Colors.white,),
            BlocBuilder<MaterialDetailBloc, MaterialDetailState>(
              builder: (context, state) {
                if(state is FetchMaterialDetailDataState){
                  return _searchField(dataState: state);
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),

            Expanded(
              child: BlocBuilder<MaterialDetailBloc, MaterialDetailState>(
                builder: (context, state) {
                  if(state is FetchMaterialDetailDataState){
                    return state.isLoader == false ?
                        MaterialDataTableBuilderItemBox(dataState: state)
                        : _centerLoader();
                  } else {
                    return _centerLoader();
                  }
                },
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget _centerLoader() {
    return const Center(child: CenterLoaderWidget());
  }

  Widget _appBar() {
    return  AppBar(
      backgroundColor: Colors.transparent,
      title: Align(
        alignment: Alignment.centerLeft,
        child: TextWidget(
          "Material Detail",
          color: AppColor.white,
          fontSize: AppFont.font_15,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        Image.asset(
          AppConfig.instanceInit()!.client == Client.iglcng
              ? AppIcon.appLogoIgl
              : AppIcon.appLogoIgl,
          height: MediaQuery.of(context).size.width * 0.13,
          width: MediaQuery.of(context).size.width * 0.13,
        )
      ],
    );
  }

  Widget _searchField({required FetchMaterialDetailDataState dataState}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFieldWidget(
        labelText: "Search Material",
        controller: dataState.searchController,
        suffixIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.width * 0.08,
            width: MediaQuery.of(context).size.width * 0.08,
            child:  dataState.isLoader == false ?
            FloatingActionButton(
                backgroundColor: AppColor.white,
                child: Icon(Icons.search, color: AppColor.themeColor,),
                onPressed: () {
                  BlocProvider.of<MaterialDetailBloc>(context).
                  add(MaterialDetailSearchEvent(context: context));
                }) : DottedLoaderWidget(
              color: AppColor.themeSecondary,
              size:  MediaQuery.of(context).size.width * 0.03,),
          ),
        ),
      ),
    );
  }


  Widget _listBuilder({required FetchMaterialDetailDataState dataState}) {
    return dataState.materialDetailList.isNotEmpty ?
    Container(
      padding: const EdgeInsets.all(10.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20)),
        color: Colors.white,
      ),
      child: ListView.builder(
          itemCount: dataState.materialDetailList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              index == 0
                  ? MaterialListHeaderWidget(materialDetailData: dataState.materialDetailList[index], total: dataState.materialDetailList.length)
                  : const SizedBox.shrink(),
             MaterialDetailItemBoxWidget(materialDetailData: dataState.materialDetailList[index])
            ],
          );
      }),
    ): const Center(child: TextWidget("No Record Found", color: Colors.white,),);
  }

}
