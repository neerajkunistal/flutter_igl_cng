import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/ci/domain/bloc/view_ci_complaint_bloc.dart';

class VendorListWidget extends StatefulWidget {
  const VendorListWidget({super.key});

  @override
  State<VendorListWidget> createState() => _VendorListWidgetState();
}

class _VendorListWidgetState extends State<VendorListWidget> {
  
  List<DataRow> rowCellsList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: appBackGround(
        context: context,
        child: Column(
          children: [
            _appBar(),
            BlocBuilder<ViewCiComplaintBloc, ViewCiComplaintState>(
              builder: (context, state) {
                if(state is FetchViewCiComplaintDataState) {
                   return Expanded(
                       child: _tableBuilder(dataState: state));
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return  AppBar(
      backgroundColor: Colors.transparent,
      title: Align(
        alignment: Alignment.centerLeft,
        child: TextWidget(
          "Vendor List",
          color: AppColor.white,
          fontSize: AppFont.font_15,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        BlocBuilder<ViewCiComplaintBloc, ViewCiComplaintState>(
          builder: (context, state) {
            if(state is FetchViewCiComplaintDataState) {
              return  state.selectedVendorId.isEmpty ?
              Image.asset(
                AppConfig.instanceInit()!.client == Client.iglcng
                    ? AppIcon.appLogoIgl
                    : AppIcon.appLogoIgl,
                height: MediaQuery.of(context).size.width * 0.13,
                width: MediaQuery.of(context).size.width * 0.13,
              ) : _doneButton(dataState: state);
            } else {
              return const SizedBox.shrink();
            }
          },
        ),

      ],
    );
  }

  Widget _doneButton({required FetchViewCiComplaintDataState dataState}) {
    return TextButton(
        onPressed: () {
          for (var vendorData in dataState.vendorList) {
            if(vendorData.id.toString() == dataState.selectedVendorId){
              BlocProvider.of<ViewCiComplaintBloc>(context)
                  .add(ViewCiComplaintSelectVendorEvent(vendorData: vendorData));
              Navigator.pop(context);
            }
          }
        },
        child: TextWidget("Done",color: AppColor.white,
         fontWeight: FontWeight.w700,)
    );
  }

  Widget _tableBuilder(
      {required FetchViewCiComplaintDataState dataState}){
    rowCellsList = [];
    for (var vendorData in dataState.vendorList) {
      double totalValue =  double.parse(vendorData.consumedValue.toString())
          + double.parse(vendorData.provisionalApproved.toString());
      rowCellsList.add(
          DataRow(cells: [
            DataCell(Row(
              children: [
                _radioButton(dataState: dataState, groupValue: vendorData.id.toString()),
                TextWidget(vendorData.name.toString()),
              ],
            ),),
            DataCell(TextWidget(vendorData.poAmount.toString())),
            DataCell(TextWidget(vendorData.consumedValue.toString())),
            DataCell(TextWidget(totalValue.toString())),
           ],
          )
       );
    }
    return dataState.vendorList.isNotEmpty ?
    Container(
      padding: const EdgeInsets.all(10.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20)),
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
              showCheckboxColumn: false, // <-- this is important
              columns: const [
                DataColumn(label: TextWidget('Name')),
                DataColumn(label: TextWidget('PO Value')),
                DataColumn(label: TextWidget('Consumed Value')),
                DataColumn(label: TextWidget('Total \n(Consumed Value + Provisionally Approve)',
                  textAlign: TextAlign.center,)),
              ],
              rows:rowCellsList
          ),
        ),
      ),
    ) : const Center(child: TextWidget("No Record Found", color: Colors.white,));
  }

  Widget _radioButton({required FetchViewCiComplaintDataState dataState,
  required String groupValue,
  }) {
    return Radio(
        value: groupValue,
        groupValue: dataState.selectedVendorId,
        onChanged: (value) {
          BlocProvider.of<ViewCiComplaintBloc>(context)
              .add(ViewCiComplaintSelectVendorTableValueEvent(selectedVendorId: value.toString()));
        },
    );
  }
}