import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/acknowledge/domain/bloc/acknowledge_bloc.dart';
import 'package:flutter_igl_cng/feature/acknowledge/presentation/widget/acknowledge_item_box_widget.dart';
import 'package:flutter_igl_cng/feature/addAcknowledge/addAcknowledgeComplaint/domain/bloc/add_acknowledge_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/addAcknowledge/addAcknowledgeComplaint/domain/bloc/add_acknowledge_complaint_event.dart';
import 'package:flutter_igl_cng/feature/addAcknowledge/addAcknowledgeComplaint/presentation/page/add_acknowledge_page.dart';

class AcknowledgePage extends StatefulWidget {
  const AcknowledgePage({super.key});

  @override
  State<AcknowledgePage> createState() => _AcknowledgePageState();
}

class _AcknowledgePageState extends State<AcknowledgePage> {

   @override
  void initState() {
     BlocProvider.of<AcknowledgeBloc>(context).add(AcknowledgePageLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget("Acknowledge", color: AppColor.white,),
      ),
      body: BlocBuilder<AcknowledgeBloc, AcknowledgeState>(
        builder: (context, state) {
          if(state is FetchAcknowledgeDataState){
            return _itemBuilder(dataState: state);
          } else {
            return const Center(child: CenterLoaderWidget(),);
          }

        },
      ),
    );
  }

  Widget _itemBuilder({required FetchAcknowledgeDataState dataState}) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: dataState.acknowledgeList.isNotEmpty ?
      ListView.builder(
          itemCount: dataState.acknowledgeList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              if(dataState.acknowledgeList[index].complaintStatus.toString() != "2"){
                BlocProvider.of<AddAcknowledgeComplaintBloc>(context).add(
                    AddAcknowledgeComplaintPageLoadEvent(context: context, acknowledgeData: dataState.acknowledgeList[index]));
                final result =  await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddAcknowledgePage()),
                );
                if (!context.mounted) return;
                if(result.toString() == "Completed"){
                  BlocProvider.of<AcknowledgeBloc>(context).add(AcknowledgePageLoadEvent(context: context));
                }
              }
            },
            child: AcknowledgeItemBoxWidget(
              index: index,
              acknowledgeData: dataState.acknowledgeList[index],),
          );
      }): const Center(child: TextWidget("No Data")),
    );
  }

}
