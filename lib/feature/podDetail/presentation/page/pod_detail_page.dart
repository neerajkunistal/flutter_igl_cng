
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/podDetail/domain/bloc/pod_detail_bloc.dart';
import 'package:flutter_igl_cng/feature/podDetail/presentation/widget/pod_data_table_builder_item_box_widget.dart';
import 'package:flutter_igl_cng/feature/podDetail/presentation/widget/pod_detail_item_box_widget.dart';
import 'package:flutter_igl_cng/feature/podDetail/presentation/widget/pod_list_header_widget.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/dotted_line_widget.dart';

class PodDetailPage extends StatefulWidget {
  const PodDetailPage({super.key});

  @override
  State<PodDetailPage> createState() => _PodDetailPageState();
}

class _PodDetailPageState extends State<PodDetailPage> {

  @override
  void initState() {
    BlocProvider.of<PodDetailBloc>(context).add(PodDetailPageLoadEvent());
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
              BlocBuilder<PodDetailBloc, PodDetailState>(
                builder: (context, state) {
                  if(state is FetchPodDetailDataState){
                    return _searchField(dataState: state);
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),

              Expanded(
                child: BlocBuilder<PodDetailBloc, PodDetailState>(
                  builder: (context, state) {
                    if(state is FetchPodDetailDataState){
                      return state.isLoader == false ?
                      PodDataTableBuilderItemBox(dataState: state)
                          : _centerLoader();
                    } else {
                      return _centerLoader();
                    }
                  },
                ),
              )
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
          "PO Detail",
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

  Widget _searchField({required FetchPodDetailDataState dataState}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFieldWidget(
        labelText: "Search PO",
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
                  BlocProvider.of<PodDetailBloc>(context).
                  add(PodDetailSearchEvent(context: context));
                }) : DottedLoaderWidget(
              color: AppColor.themeSecondary,
              size:  MediaQuery.of(context).size.width * 0.03,),
          ),
        ),
      ),
    );
  }

  Widget _listBuilder({required FetchPodDetailDataState dataState}) {
    return dataState.podDetailList.isNotEmpty ?
    Container(
      padding: const EdgeInsets.all(10.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20)),
        color: Colors.white,
      ),
      child: ListView.builder(
          itemCount: dataState.podDetailList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                index == 0
                    ? PodListHeaderWidget(podDetailModel: dataState.podDetailList[index], total: dataState.podDetailList.length)
                    : const SizedBox.shrink(),
                PodDetailItemBoxWidget(podDetailData: dataState.podDetailList[index])
              ],
            );
          }),
    ): const Center(child: TextWidget("No Record Found", color: Colors.white,),);
  }
}
