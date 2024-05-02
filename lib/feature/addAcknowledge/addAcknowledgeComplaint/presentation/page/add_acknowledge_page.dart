import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/acknowledge/presentation/widget/acknowledge_item_box_widget.dart';
import 'package:flutter_igl_cng/feature/addAcknowledge/addAcknowledgeComplaint/domain/bloc/add_acknowledge_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/addAcknowledge/addAcknowledgeComplaint/domain/bloc/add_acknowledge_complaint_event.dart';
import 'package:flutter_igl_cng/feature/acknowledge/domain/model/acknowledge_model.dart';
import 'package:flutter_igl_cng/feature/addAcknowledge/addAcknowledgeComplaint/domain/model/acknowledge_user_model.dart';
import 'package:flutter_igl_cng/feature/addAcknowledge/addAcknowledgeComplaint/domain/model/complaint_model.dart';
import 'package:flutter_igl_cng/feature/addAcknowledge/addAcknowledgeComplaint/domain/model/department_model.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/addEquipmentComplaint/domain/model/complaint_type_model.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/addEquipmentComplaint/domain/model/equipment_type_model.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/domain/model/review_complaint_model.dart';

class AddAcknowledgePage extends StatefulWidget {
  const AddAcknowledgePage({super.key});

  @override
  State<AddAcknowledgePage> createState() => _AddAcknowledgePageState();
}

class _AddAcknowledgePageState extends State<AddAcknowledgePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget("Update Acknowledge", color: AppColor.white,),
      ),
      body: BlocBuilder<AddAcknowledgeComplaintBloc, AddAcknowledgeComplaintState>(
        builder: (context, state) {
          if(state is FetchAddAcknowledgeComplaintState) {
            return _itemWidget(dataState: state);
          } else {
            return const Center(child: CenterLoaderWidget(),);
          }
        },
      ),
    );
  }

  Widget _itemWidget({required FetchAddAcknowledgeComplaintState dataState}) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child : Column(
          children: [
            AcknowledgeItemBoxWidget(acknowledgeData: dataState.acknowledgeData, index: 0),
            _verticalSpace(),
            _complaintTypeDropDown(dataState: dataState),
             _verticalSpace(),
            dataState.complaintTypeData.id.toString() == "2"
                ? _equipmentDropDown(dataState: dataState) : const SizedBox.shrink(),
            dataState.complaintTypeData.id.toString() == "2"? _verticalSpace() : const SizedBox.shrink(),
            Row(
              children: [
                Expanded(child: _dateController(dataState: dataState)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Expanded(child: _timeController(dataState: dataState)),
              ],
            ),
            _verticalSpace(),
            _descriptionRemark(dataState: dataState),
            _radioButton(dataState: dataState),
            _verticalSpace(),
            _userDropDown(dataState: dataState),
            _verticalSpace(),
            _remark(dataState: dataState),
            _verticalSpace(),
            _verticalSpace(),
            _button(dataState: dataState),
          ],
        ),
      ),
    );
  }

  Widget _complaintTypeDropDown({required FetchAddAcknowledgeComplaintState dataState}) {
    return DropdownWidget(
      hint: AppString.editComplaintType,
      dropdownValue: dataState.complaintTypeData.id != null ? dataState.complaintTypeData : null,
      onChanged: (value) {
        BlocProvider.of<AddAcknowledgeComplaintBloc>(context).add(
            AddAcknowledgeComplaintSelectComplaintDataEvent(complaintTypeData: value));
      },
      items: dataState.complaintTypeList.map<DropdownMenuItem<ComplaintTypeModel>>((ComplaintTypeModel complaintTypeData) {
        return DropdownMenuItem<ComplaintTypeModel>(
          value: complaintTypeData,
          child: Text(complaintTypeData.name.toString()),
        );
      }).toList(),
    );
  }

  Widget _equipmentDropDown({required FetchAddAcknowledgeComplaintState dataState}) {
    return DropdownWidget(
      hint: AppString.editEquipment,
      dropdownValue: dataState.equipmentTypeData.description != null ? dataState.equipmentTypeData : null,
      onChanged: (value) {
        BlocProvider.of<AddAcknowledgeComplaintBloc>(context).add(
            AddAcknowledgeComplaintSelectEquipmentDataEvent(equipmentTypeData: value));
      },
      items: dataState.equipmentTypeList.map<DropdownMenuItem<EquipmentTypeModel>>((EquipmentTypeModel equipmentTypeData) {
        return DropdownMenuItem<EquipmentTypeModel>(
          value: equipmentTypeData,
          child: Text(equipmentTypeData.description.toString()),
        );
      }).toList(),
    );
  }

  Widget _userDropDown({required FetchAddAcknowledgeComplaintState dataState}) {
    return DropdownWidget(
      hint: AppString.assignUSer,
      dropdownValue: dataState.acknowledgeUserData.id != null ? dataState.acknowledgeUserData : null,
      onChanged: (value) {
        BlocProvider.of<AddAcknowledgeComplaintBloc>(context).add(
            AddAcknowledgeComplaintSelectUserEvent(acknowledgeUserData: value));
      },
      items: dataState.acknowledgeUserList.map<DropdownMenuItem<AcknowledgeUserModel>>((AcknowledgeUserModel acknowledgeUserData) {
        return DropdownMenuItem<AcknowledgeUserModel>(
          value: acknowledgeUserData,
          child: Text(acknowledgeUserData.name.toString()),
        );
      }).toList(),
    );
  }

  Widget _reviewComplaintDropDown({required FetchAddAcknowledgeComplaintState dataState}) {
    return DropdownWidget(
      hint: AppString.selectReviewComplaint,
      dropdownValue: dataState.reviewComplaintData.id != null ? dataState.reviewComplaintData : null,
      onChanged: (value) {
        BlocProvider.of<AddAcknowledgeComplaintBloc>(context).add(
            AddAcknowledgeComplaintSelectReviewComplaintEvent(reviewComplaintData: value));
      },
      items: dataState.reviewComplaintList.map<DropdownMenuItem<ReviewComplaintModel>>((ReviewComplaintModel reviewComplaintData) {
        return DropdownMenuItem<ReviewComplaintModel>(
          value: reviewComplaintData,
          child: Text(reviewComplaintData.complaintDescription.toString()),
        );
      }).toList(),
    );
  }

  Widget _complaintDropDown({required FetchAddAcknowledgeComplaintState dataState}) {
    return dataState.isComplaintLoader == false ?
    DropdownWidget(
      hint: AppString.selectComplaint,
      dropdownValue: dataState.complaintData.complaintTypeId != null ? dataState.complaintData : null,
      onChanged: (value) {
        BlocProvider.of<AddAcknowledgeComplaintBloc>(context).add(
            AddAcknowledgeComplaintSelectComplaintEvent(complaintData: value));
      },
      items: dataState.complaintList.map<DropdownMenuItem<ComplaintModel>>((ComplaintModel complaintData) {
        return DropdownMenuItem<ComplaintModel>(
          value: complaintData,
          child: Text(complaintData.complaintDescription.toString()),
        );
      }).toList(),
    ): const DottedLoaderWidget();
  }

  Widget _acknowledgeDropDown({required FetchAddAcknowledgeComplaintState dataState}) {
    return DropdownWidget(
      hint: AppString.selectAcknowledge,
      dropdownValue: dataState.acknowledgeData.id != null ? dataState.acknowledgeData : null,
      onChanged: (value) {
        BlocProvider.of<AddAcknowledgeComplaintBloc>(context).add(
            AddAcknowledgeComplaintSelectAcknowledgeComplaintEvent(acknowledgeData: value));
      },
      items: dataState.acknowledgeList.map<DropdownMenuItem<AcknowledgeModel>>((AcknowledgeModel acknowledgeData) {
        return DropdownMenuItem<AcknowledgeModel>(
          value: acknowledgeData,
          child: Text(acknowledgeData.complaintDescription.toString()),
        );
      }).toList(),
    );
  }

  Widget _departmentDropDown({required FetchAddAcknowledgeComplaintState dataState}) {
    return DropdownWidget(
      hint: AppString.selectDepartment,
      dropdownValue: dataState.departmentData.id != null ? dataState.departmentData : null,
      onChanged: (value) {
        BlocProvider.of<AddAcknowledgeComplaintBloc>(context).add(
            AddAcknowledgeComplaintSelectDepartmentEvent(departmentData: value));
      },
      items: dataState.departmentList.map<DropdownMenuItem<DepartmentModel>>((DepartmentModel departmentData) {
        return DropdownMenuItem<DepartmentModel>(
          value: departmentData,
          child: Text(departmentData.name.toString()),
        );
      }).toList(),
    );
  }

  Widget _radioButton({required FetchAddAcknowledgeComplaintState dataState}) {
     return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       mainAxisAlignment: MainAxisAlignment.start,
       children: [
         Row(
           children: [
             Radio(
               value: "1",
               groupValue: dataState.breakDownvalue,
               onChanged: (val) {
                 BlocProvider.of<AddAcknowledgeComplaintBloc>(context).add(
                     AddAcknowledgeComplaintSelectBreakDownEvent(breakeDown: val.toString()));
               },
             ),
             const TextWidget("Breakdown"),
           ],
         ),
         Row(
           children: [
             Radio(
               value: "2",
               groupValue: dataState.breakDownvalue,
               onChanged: (val) {
                 BlocProvider.of<AddAcknowledgeComplaintBloc>(context).add(
                     AddAcknowledgeComplaintSelectBreakDownEvent(breakeDown: val.toString()));
               },
             ),
             const TextWidget("No Breakdown"),
           ],
         ),
       ],
     );
}

  Widget _dateController({required FetchAddAcknowledgeComplaintState dataState}) {
    return TextFieldWidget(
      enabled: false,
      isRequired: true,
      labelText: "Edit Date",
      controller: dataState.dateController,
      onTap:  () {
        BlocProvider.of<AddAcknowledgeComplaintBloc>(context).add(
            AddAcknowledgeComplaintSelectDateData(context: context));
      },
    );
  }

  Widget _timeController({required FetchAddAcknowledgeComplaintState dataState}) {
    return TextFieldWidget(
      enabled: false,
      isRequired: true,
      labelText: "Edit Time",
      controller: dataState.timeController,
      onTap: () {
        BlocProvider.of<AddAcknowledgeComplaintBloc>(context).add(
            AddAcknowledgeComplaintSelectTimeData(context: context));
      },
    );
  }

  Widget _descriptionRemark({required FetchAddAcknowledgeComplaintState dataState}) {
    return TextFieldWidget(
      labelText: AppString.editDescription,
      controller: dataState.descriptionController,
    );
  }


  Widget _remark({required FetchAddAcknowledgeComplaintState dataState}) {
    return TextFieldWidget(
      labelText: AppString.remark,
      controller: dataState.remarkController,
    );
  }



  Widget _photo({required FetchAddAcknowledgeComplaintState dataState}) {
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
                BlocProvider.of<AddAcknowledgeComplaintBloc>(context).add(AddAcknowledgeComplaintAddImageEvent(context: context, mediaType: 1));
              }, child: TextWidget("Camera", fontSize: AppFont.font_16,)),
              const Divider(),
              TextButton(onPressed: () {
                BlocProvider.of<AddAcknowledgeComplaintBloc>(context).add(AddAcknowledgeComplaintAddImageEvent(context: context, mediaType: 2));
              }, child: TextWidget("Gallery",fontSize: AppFont.font_16,)),
            ],
          ),
        );
      },
    );
  }


  Widget _button({required FetchAddAcknowledgeComplaintState dataState}) {
    return dataState.isLoader == false ?
    ButtonWidget(text: AppString.submit,
        height: AppConfig.getDeviceType(context: context) == DeviceType.tablet ? MediaQuery.of(context).size.height * 0.13 : null,
        onPressed: () {
          BlocProvider.of<AddAcknowledgeComplaintBloc>(context).add(AddAcknowledgeComplaintSubmitEvent(context: context));
        }
    ): const DottedLoaderWidget();
  }


  Widget _verticalSpace() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }


}