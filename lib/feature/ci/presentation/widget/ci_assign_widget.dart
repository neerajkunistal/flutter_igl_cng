import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/ci/domain/bloc/view_ci_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/domain/domain/model/cng_model.dart';

class CiAssignWidget extends StatelessWidget {
  final CngModel cngData;

  const CiAssignWidget({super.key, required this.cngData});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewCiComplaintBloc, ViewCiComplaintState>(
      builder: (context, state) {
        if (state is FetchViewCiComplaintDataState) {
          return _itemBuilder(dataState: state, context: context);
        } else {
          return _centerLoader();
        }
      },
    );
  }

  Widget _centerLoader() {
    return const Center(child: CenterLoaderWidget());
  }

  Widget _itemBuilder(
      {required FetchViewCiComplaintDataState dataState,
      required BuildContext context}) {
    return  dataState.isVendorListLoader == false
        ? Column(children: [
      SizedBox(
        height: MediaQuery.of(context).size.width * 0.06,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: TextWidget(
          "Assign Vendor",
          fontSize: AppFont.font_14,
          fontWeight: FontWeight.w700,
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.width * 0.04,
      ),
      _vendorDropDown(dataState: dataState, context: context),
      SizedBox(
        height: MediaQuery.of(context).size.width * 0.04,
      ),
      _submitButton(dataState: dataState, context: context),
      SizedBox(
        height: MediaQuery.of(context).size.width * 0.04,
      ),
    ])
        : _centerLoader();
  }

  Widget _vendorDropDown(
      {required FetchViewCiComplaintDataState dataState,
      required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: DropDownSearchWidget(
        isRequired: true,
        selectedItem:
            dataState.vendorData.name != null ? dataState.vendorData : null,
        hint: AppString.vendor,
        items: dataState.vendorList,
        itemAsString: (vendorData) => vendorData.name.toString(),
        onChanged: (value) {
          BlocProvider.of<ViewCiComplaintBloc>(context)
              .add(ViewCiComplaintSelectVendorEvent(vendorData: value));
        },
      ),
    );
  }

  Widget _submitButton(
      {required FetchViewCiComplaintDataState dataState,
      required BuildContext context}) {
    return dataState.isVendorAssignLoader == false
        ? SizedBox(
            width: MediaQuery.of(context).size.width * 0.40,
            child: ButtonWidget(
                text: AppString.assign,
                onPressed: () {
                  BlocProvider.of<ViewCiComplaintBloc>(context).add(
                      ViewCiComplaintVendorAssignEvent(
                          context: context, cngData: cngData));
                }),
          )
        : const DottedLoaderWidget();
  }
}
