import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/background_widget.dart';

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
        body: AppBackgroundWidget(
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
          AppConfig.instanceInit()!.client == Client.igl
              ? AppIcon.appLogoIgl
              : AppConfig.instanceInit()!.client == Client.pbgpl
              ? AppIcon.appLogoPurvaBharti
              : AppConfig.instanceInit()!.client == Client.mahanagar
              ? AppIcon.appLogoMGL
              : AppConfig.instanceInit()!.client == Client.hpcl
              ? AppIcon.appLogoHPCL
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
                child: Icon(Icons.search, color: EnvironmentConfig.of(context)!.primaryTheme,),
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
