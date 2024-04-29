import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/bloc/mi_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/model/action_model.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/model/spares_model.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/domain/model/review_complaint_model.dart';

class MiComplaintPage extends StatefulWidget {
  const MiComplaintPage({super.key});

  @override
  State<MiComplaintPage> createState() => _MiComplaintPageState();
}

class _MiComplaintPageState extends State<MiComplaintPage> {

  @override
  void initState() {
    BlocProvider.of<MiComplaintBloc>(context).add(MiComplaintPageLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget("MI Complaint", color: AppColor.white,),
      ),
      body: BlocBuilder<MiComplaintBloc, MiComplaintState>(
        builder: (context, state) {
          if(state is FetchMiComplaintDataState) {
            return _itemBuilder(dataState: state);
          } else {
            return const Center(child: CenterLoaderWidget(),);
          }
          return Container();
        },
      ),
    );
  }

  Widget _itemBuilder({required FetchMiComplaintDataState dataState}) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child : Column(
          children: [
            _verticalSpace(),
            _complaintTypeDropDown(dataState: dataState),
            _verticalSpace(),
            _amcStatusController(dataState: dataState),
            _verticalSpace(),
            _amcDateController(dataState: dataState),
            _verticalSpace(),
            _sparesDropDown(dataState: dataState),
            _verticalSpace(),
            _radioButton(dataState: dataState),
            _verticalSpace(),
            _actionDropDown(dataState: dataState),
            _verticalSpace(),
            _descriptionController(dataState: dataState),
            _verticalSpace(),
            _observationController(dataState: dataState),
            _verticalSpace(),
            _photo(dataState: dataState),
            _verticalSpace(),
            _verticalSpace(),
            _button(dataState: dataState),
          ],
        ),
      ),
    );
  }

  Widget _complaintTypeDropDown({required FetchMiComplaintDataState dataState}) {
    return DropdownWidget(
      hint: AppString.selectComplaint,
      dropdownValue: dataState.reviewComplaintData.id != null ? dataState.reviewComplaintData : null,
      onChanged: (value) {
        BlocProvider.of<MiComplaintBloc>(context).add(
            MiComplaintSelectComplaintData(reviewComplaintData: value));
      },
      items: dataState.reviewComplaintList.map<DropdownMenuItem<ReviewComplaintModel>>((ReviewComplaintModel reviewComplaintData) {
        return DropdownMenuItem<ReviewComplaintModel>(
          value: reviewComplaintData,
          child: Text(reviewComplaintData.complaintDescription.toString()),
        );
      }).toList(),
    );
  }

  Widget _sparesDropDown({required FetchMiComplaintDataState dataState}) {
    return DropdownWidget(
      hint: AppString.selectSpares,
      dropdownValue: dataState.sparesData.id != null ? dataState.sparesData : null,
      onChanged: (value) {
        BlocProvider.of<MiComplaintBloc>(context).add(
            MiComplaintSelectSpareData(sparesData: value));
      },
      items: dataState.sparesList.map<DropdownMenuItem<SparesModel>>((SparesModel sparesData) {
        return DropdownMenuItem<SparesModel>(
          value: sparesData,
          child: Text(sparesData.spareName.toString()),
        );
      }).toList(),
    );
  }

  Widget _descriptionController({required FetchMiComplaintDataState dataState}) {
    return TextFieldWidget(
      labelText: AppString.description,
      controller: dataState.descriptionController,
    );
  }

  Widget _radioButton({required FetchMiComplaintDataState dataState}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const TextWidget("Approval"),
        Row(
          children: [
            Radio(
              value: "Yes",
              groupValue: dataState.approvalValue,
              onChanged: (val) {
                BlocProvider.of<MiComplaintBloc>(context).add(
                    MiComplaintSelectApprovalData(approvalValue: val.toString()));
              },
            ),
            const TextWidget("Yes"),

            Radio(
              value: "No",
              groupValue: dataState.approvalValue,
              onChanged: (val) {
                BlocProvider.of<MiComplaintBloc>(context).add(
                    MiComplaintSelectApprovalData(approvalValue: val.toString()));
              },
            ),
            const TextWidget("No"),

          ],
        ),
      ],
    );
  }

  Widget _actionDropDown({required FetchMiComplaintDataState dataState}) {
    return DropdownWidget(
      hint: AppString.selectAction,
      dropdownValue: dataState.actionData.id != null ? dataState.actionData : null,
      onChanged: (value) {
        BlocProvider.of<MiComplaintBloc>(context).add(
            MiComplaintSelectActionData(actionData: value));
      },
      items: dataState.actionList.map<DropdownMenuItem<ActionModel>>((ActionModel actionData) {
        return DropdownMenuItem<ActionModel>(
          value: actionData,
          child: Text(actionData.value.toString()),
        );
      }).toList(),
    );
  }

  Widget _amcStatusController({required FetchMiComplaintDataState dataState}) {
    TextEditingController controller =  TextEditingController();
    controller.text =  dataState.reviewComplaintData.id != null ? dataState.reviewComplaintData.amcStatus.toString() : "";
    return TextFieldWidget(
      enabled: false,
      labelText: "AMC Status",
      controller: controller,
    );
  }

  Widget _amcDateController({required FetchMiComplaintDataState dataState}) {
    TextEditingController controller =  TextEditingController();
    controller.text =  dataState.reviewComplaintData.id != null ? dataState.reviewComplaintData.amcDate.toString() : "";
    return TextFieldWidget(
      enabled: false,
      labelText: "AMC Date",
      controller: controller,
    );
  }

  Widget _observationController({required FetchMiComplaintDataState dataState}) {
    return TextFieldWidget(
      labelText: AppString.observation,
      controller: dataState.observationController,
    );
  }

  Widget _photo({required FetchMiComplaintDataState dataState}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width/3,
      height:MediaQuery.of(context).size.width/3,
      child: InkWell(
        onTap: () {
          mediaType(context: context);
        },
        child: DottedBorder(
          color: AppColor.grey,
          strokeWidth: 1,
          child: dataState.file.path.isEmpty ?
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(child: Icon(Icons.photo_camera_back_outlined),),
              Padding(
                padding:  EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                child: TextWidget("Photo",
                  fontSize: AppFont.font_12,
                  color: AppColor.grey,),
              ),
            ],
          ):Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  dataState.file.path.toString().toLowerCase().contains(".jpg")
                      || dataState.file.path.toString().toLowerCase().contains(".png")
                      || dataState.file.path.toString().toLowerCase().contains(".jpeg")
                      ? Image.file(dataState.file,
                    fit: BoxFit.fill,
                    width: MediaQuery.of(context).size.width/3,
                    height: MediaQuery.of(context).size.width/4.5 ,)
                      : dataState.file.path.toString().toLowerCase().contains(".pdf")
                      ? const Icon(Icons.picture_as_pdf_outlined)
                      :  const Icon(Icons.document_scanner_outlined),
                  TextWidget(dataState.file.path.split('/').last.toString(),
                    color: AppColor.themeColor, fontSize: AppFont.font_12,),
                ],
              ),
              Container(
                  width: MediaQuery.of(context).size.width/3,
                  height:MediaQuery.of(context).size.width/3,
                  color : Colors.white.withOpacity(0.6),
                  child: Center(child: Icon(Icons.refresh, color: AppColor.themeColor,))),

            ],
          ),
        ),
      ),
    );
  }

  void mediaType({required BuildContext context}) {
    showModalBottomSheet(
      context: context, // Also default
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.18,
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextButton(onPressed: () {
                BlocProvider.of<MiComplaintBloc>(context).add(MiComplaintAddImageEvent(context: context, mediaType: 1));
              }, child: TextWidget("Camera", fontSize: AppFont.font_16,)),
              const Divider(),
              TextButton(onPressed: () {
                BlocProvider.of<MiComplaintBloc>(context).add(MiComplaintAddImageEvent(context: context, mediaType: 2));
              }, child: TextWidget("Gallery",fontSize: AppFont.font_16,)),
            ],
          ),
        );
      },
    );
  }


  Widget _button({required FetchMiComplaintDataState dataState}) {
    return dataState.isLoader == false ?
    ButtonWidget(text: AppString.submit,
        height: AppConfig.getDeviceType(context: context) == DeviceType.tablet ? MediaQuery.of(context).size.height * 0.13 : null,
        onPressed: () {
          BlocProvider.of<MiComplaintBloc>(context).add(MiComplaintSubmitData(context: context));
        }
    ): const DottedLoaderWidget();
  }


  Widget _verticalSpace() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }

}
