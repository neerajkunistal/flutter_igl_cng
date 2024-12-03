import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/ci/domain/bloc/view_ci_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/ci/presentation/widget/vendor_list_widget.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/domain/domain/model/cng_model.dart';
import 'package:flutter_igl_cng/utils/commonClass/fade_route.dart';

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
          "Assign Vendor / Review",
          fontSize: AppFont.font_14,
          fontWeight: FontWeight.w700,
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.width * 0.04,
      ),
      _checkBox(dataState: dataState, context: context),

      dataState.isSendToReview == false ?
      SizedBox(
        height: MediaQuery.of(context).size.width * 0.04,
      ) : const SizedBox.shrink(),

      dataState.isSendToReview == false ?
      _assignVendorController(dataState: dataState, context: context)
          : const SizedBox.shrink(),

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

  Widget _checkBox({required FetchViewCiComplaintDataState dataState,
    required BuildContext context}) {
    return Row(
      children: [
        Checkbox(
            value: dataState.isSendToReview,
            onChanged: (value) {
              BlocProvider.of<ViewCiComplaintBloc>(context)
                  .add(ViewCiComplaintSendToReviewEvent(isSendToReview: value!));
             }
           ),
        Expanded(child: TextWidget(AppString.sendToReview)),
      ],
    );
  }

  Widget _assignVendorController({required FetchViewCiComplaintDataState dataState,
    required BuildContext context}) {
    TextEditingController controller =  TextEditingController();
    if(dataState.vendorData.id != null){
      controller.text =  dataState.vendorData.name.toString();
    }
    return TextFieldWidget(
      enabled: false,
      controller: controller,
      isRequired: true,
      labelText: AppString.vendor,
      onTap:  () {
        Navigator.push(
            !context.mounted ? context : context,
            FadeRoute(page: const VendorListWidget()
            )
        );
      },
    );
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
                text: dataState.isSendToReview == false
                    ? AppString.assign : AppString.review,
                onPressed: () {
                  BlocProvider.of<ViewCiComplaintBloc>(context).add(
                      ViewCiComplaintVendorAssignEvent(
                          context: context, cngData: cngData));
                }),
          )
        : const DottedLoaderWidget();
  }
}
