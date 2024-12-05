import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/acknowledge/domain/model/vendor_model.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/model/action_model.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/model/spares_model.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/presentation/widget/review_complaint_item_box.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/presentation/page/add_scrap_page.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/presentation/widget/scrap_common_item_widget.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/presentation/widget/scrap_item_widget.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/domain/bloc/add_spare_part_bloc.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/presentation/page/add_spare_part_page.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/presentation/widget/add_spare_part_widget.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/presentation/widget/spare_part_common_item_widget.dart';
import 'package:flutter_igl_cng/utils/commonClass/fade_route.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/dotted_line_widget.dart';

class MiComplaintPage extends StatefulWidget {
  const MiComplaintPage({super.key});

  @override
  State<MiComplaintPage> createState() => _MiComplaintPageState();
}

class _MiComplaintPageState extends State<MiComplaintPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: _widgetBuilder(),
    );
  }

  Widget _widgetBuilder() {
    return appBackGround(
        child:Column(
          children: [
            _appBar(),
            const DottedDividerLine(color: Colors.white),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Colors.white,
                ),
                child: BlocBuilder<MiComplaintBloc, MiComplaintState>(
                  builder: (context, state) {
                    if (state is FetchMiComplaintDataState) {
                      return _itemBuilder(dataState: state);
                    } else {
                      return const Center(
                        child: CenterLoaderWidget(),
                      );
                    }
                  },
                ),
              ),
            )
          ],
        ),
        context: context
    );
  }

  Widget _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Align(
        alignment: Alignment.centerLeft,
        child: TextWidget(
          "MI Complaint",
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
        ),
      ],
    );
  }

  Widget _itemBuilder({required FetchMiComplaintDataState dataState}) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ReviewComplaintItemBox(
                index: 0,
                reviewComplaintData: dataState.reviewComplaintData),
            _scrapList(dataState: dataState),
            _sparePartList(dataState: dataState),

            _verticalSpace(),
            _amcStatusDate(dataState: dataState),
            _verticalSpace(),
            _actionDropDown(dataState: dataState),
            _verticalSpace(),

            dataState.actionData.id.toString() == "3" ||
             dataState.actionData.id.toString() == "4"
                ? AddSparePartWidget()
                : const SizedBox.shrink(),
            dataState.actionData.id.toString() == "3"||
                dataState.actionData.id.toString() == "4"
                ? _verticalSpace()
                : const SizedBox.shrink(),
            dataState.actionData.id.toString() == "3"||
                dataState.actionData.id.toString() == "4"
                ? _addSparesPartButton(dataState: dataState)
                : const SizedBox.shrink(),
            dataState.actionData.id.toString() == "3"||
                dataState.actionData.id.toString() == "4"
                ? _verticalSpace()
                : const SizedBox.shrink(),

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
            dataState.actionData.id.toString() == "4"
                ? _vendorDropDown(dataState: dataState)
                : const SizedBox.shrink(),
            dataState.actionData.id.toString() == "4"
                ? _verticalSpace()
                : const SizedBox.shrink(),
            _descriptionController(dataState: dataState),
            _verticalSpace(),
            _rectifyByController(dataState: dataState),
            _verticalSpace(),
            _observationController(dataState: dataState),
            _verticalSpace(),
            _photo(dataState: dataState),

            dataState.actionData.id.toString() == "3"
                ? _verticalSpace()
                : const SizedBox.shrink(),
            dataState.actionData.id.toString() == "3"
                ?_scrapCheckBoxWidget(dataState: dataState)
                : const SizedBox.shrink(),


            dataState.isNoScrap == false
                ? _verticalSpace()
                : const SizedBox.shrink(),
            dataState.isNoScrap == false
                ? const ScrapItemWidget()
                : const SizedBox.shrink(),

            dataState.isNoScrap == false
                ? _verticalSpace()
                : const SizedBox.shrink(),
            dataState.isNoScrap == false
                ?_addScarpButton(dataState: dataState)
                : const SizedBox.shrink(),

            _verticalSpace(),
            _verticalSpace(),
            _button(dataState: dataState),
            _verticalSpace(),
            _verticalSpace(),

          ],
        ),
      ),
    );
  }

  Widget _scrapList({required FetchMiComplaintDataState dataState}) {
    return  dataState.reviewComplaintData.scrapList!.isNotEmpty
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DottedDividerLine(),
        TextWidget("Scarp", fontWeight: FontWeight.w700,),
        ListView.builder(
            itemCount: dataState.reviewComplaintData.scrapList!.length,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return ScrapCommonItemWidget(
                index: index,
                scrapData: dataState.reviewComplaintData.scrapList![index],
              );
            }),
        _verticalSpace(),
        const DottedDividerLine(),
        _verticalSpace(),
      ],
    ) : const SizedBox.shrink();
  }

  Widget _sparePartList({required FetchMiComplaintDataState dataState}) {
    return  dataState.reviewComplaintData.partList!.isNotEmpty
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DottedDividerLine(),
        TextWidget("Spare Part", fontWeight: FontWeight.w700,),
        ListView.builder(
            itemCount: dataState.reviewComplaintData.partList!.length,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return SparePartCommonItemWidget(
                index: index,
                partModel: dataState.reviewComplaintData.partList![index],
              );
            }),
        _verticalSpace(),
        const DottedDividerLine(),
        _verticalSpace(),
      ],
    ) : const SizedBox.shrink();
  }

  Widget _amcStatusDate({required FetchMiComplaintDataState dataState}) {
    return Card(
      shadowColor: AppColor.themeColor,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                const TextWidget("AMC Status : "),
                TextWidget(dataState.reviewComplaintData.id != null
                    ? dataState.reviewComplaintData.amcStatus.toString()
                    : ""),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            Row(
              children: [
                const TextWidget("AMC Date : "),
                TextWidget(dataState.reviewComplaintData.id != null
                    ? dataState.reviewComplaintData.amcDate.toString()
                    : ""),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sparesPartList({required FetchMiComplaintDataState dataState}) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: dataState.sparesPartList.length,
        itemBuilder: (context, index) {
          return Card(
            shadowColor: AppColor.themeColor,
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _sparesDropDown(
                      dataState: dataState,
                      sparesData: dataState.sparesPartList[index].sparesData!,
                      index: index),
                  _verticalSpace(),
                  _qtyController(
                    dataState: dataState,
                    index: index,
                    qtyController:
                        dataState.sparesPartList[index].qtyController!,
                    sparesData: dataState.sparesPartList[index].sparesData!,
                  ),
                  _verticalSpace(),
/*                  _vendorDropDown(dataState: dataState),
                  _verticalSpace(),*/
                  _materialCodeController(dataState: dataState, index: index,
                      materialCodeController: dataState.sparesPartList[index].materialCodeController!),
                  _verticalSpace(),
                  _remarkController(dataState: dataState, index: index,
                      remarkController: dataState.sparesPartList[index].remarkCodeController!),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: () {
                          BlocProvider.of<MiComplaintBloc>(context).add(
                              MiComplaintDeleteSparesPartData(index: index));
                        },
                        icon: const Icon(Icons.delete_forever_outlined)),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _sparesDropDown(
      {required FetchMiComplaintDataState dataState,
      required SparesModel sparesData,
      required int index}) {
    return DropDownSearchWidget(
      selectedItem: sparesData.id != null ? sparesData : null,
      hint: AppString.selectSpares,
      items:dataState.sparesList,
      itemAsString: (sparesData) => sparesData.spareName.toString(),
      onChanged: (value) {
        BlocProvider.of<MiComplaintBloc>(context)
            .add(MiComplaintSelectSpareData(sparesData: value, index: index));
      },
    );
  }

  Widget _qtyController(
      {required FetchMiComplaintDataState dataState,
      required int index,
      required TextEditingController qtyController,
      required SparesModel sparesData}) {
    return TextFieldWidget(
      textInputType: TextInputType.number,
      isRequired: false,
      labelText: sparesData.id != null
          ? sparesData.spareUom.toString()
          : AppString.qty,
      controller: qtyController,
    );
  }

  Widget _materialCodeController(
      {required FetchMiComplaintDataState dataState,
        required int index,
        required TextEditingController materialCodeController}) {
    return TextFieldWidget(
      textInputType: TextInputType.text,
      isRequired: false,
      labelText: AppString.materialCode,
      controller: materialCodeController,
    );
  }

  Widget _remarkController(
      {required FetchMiComplaintDataState dataState,
        required int index,
        required TextEditingController remarkController}) {
    return TextFieldWidget(
      labelText: AppString.remark,
      controller: remarkController,
    );
  }

  Widget _rectifyByController({required FetchMiComplaintDataState dataState}) {
    return TextFieldWidget(
      labelText: AppString.rectifiedBy,
      controller: dataState.rectifyByController,
    );
  }

  Widget _descriptionController(
      {required FetchMiComplaintDataState dataState}) {
    return TextFieldWidget(
      labelText: "Description",
      controller: dataState.descriptionController,
    );
  }

  Widget _actionDropDown({required FetchMiComplaintDataState dataState}) {
    return DropdownWidget(
      hint: AppString.selectAction,
      dropdownValue:
          dataState.actionData.id != null ? dataState.actionData : null,
      onChanged: (value) {
        BlocProvider.of<AddSparePartBloc>(context).add(AddSparePartClearSparePartEvent());
        BlocProvider.of<MiComplaintBloc>(context).add(
            MiComplaintSelectActionData(actionData: value, context: context));
      },
      items: dataState.actionList
          .map<DropdownMenuItem<ActionModel>>((ActionModel actionData) {
        return DropdownMenuItem<ActionModel>(
          value: actionData,
          child: Text(actionData.value.toString()),
        );
      }).toList(),
    );
  }

  Widget _observationController(
      {required FetchMiComplaintDataState dataState}) {
    return TextFieldWidget(
      labelText: dataState.actionData.id == "1"
          ? "Description of Job Start"
          : dataState.actionData.id == "2"
              ? "Description of Job Hold"
              : dataState.actionData.id == "3"
                  ? "Description of Job Done"
                  : "Remark",
      controller: dataState.observationController,
    );
  }

  Widget _dateController({required FetchMiComplaintDataState dataState}) {
    return TextFieldWidget(
      enabled: false,
      isRequired: true,
      labelText: dataState.actionData.id.toString() == "1"
          ? AppString.startDate
          : dataState.actionData.id.toString() == "2"
              ? AppString.holdDate
              : dataState.actionData.id.toString() == "3"
                  ? AppString.closedDate
                  : AppString.date,
      controller: dataState.dateController,
      onTap: () {
        BlocProvider.of<MiComplaintBloc>(context)
            .add(MiComplaintSelectDateData(context: context));
      },
    );
  }

  Widget _timeController({required FetchMiComplaintDataState dataState}) {
    return TextFieldWidget(
      enabled: false,
      isRequired: true,
      labelText: dataState.actionData.id.toString() == "1"
          ? AppString.startTime
          : dataState.actionData.id.toString() == "2"
              ? AppString.holdTime
              : dataState.actionData.id.toString() == "3"
                  ? AppString.closedTime
                  : AppString.time,
      controller: dataState.timeController,
      onTap: () {
        BlocProvider.of<MiComplaintBloc>(context)
            .add(MiComplaintSelectTimeData(context: context));
      },
    );
  }

  Widget _vendorDropDown({required FetchMiComplaintDataState dataState}) {
    return DropdownWidget(
      hint: AppString.vendor,
      dropdownValue:
          dataState.vendorData.id != null ? dataState.vendorData : null,
      onChanged: (value) {
        BlocProvider.of<MiComplaintBloc>(context)
            .add(MiComplaintSelectVendorData(vendorData: value));
      },
      items: dataState.vendorList
          .map<DropdownMenuItem<VendorModel>>((VendorModel vendorData) {
        return DropdownMenuItem<VendorModel>(
          value: vendorData,
          child: TextWidget(
              "${vendorData.name.toString()}-(${vendorData.code.toString()})"),
        );
      }).toList(),
    );
  }

  Widget _photo({required FetchMiComplaintDataState dataState}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.width / 3,
      child: InkWell(
        onTap: () {
          mediaType(context: context);
        },
        child: DottedBorder(
          color: AppColor.grey,
          strokeWidth: 1,
          child: dataState.file.path.isEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                      child: Icon(Icons.photo_camera_back_outlined),
                    ),
                    Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.02),
                      child: TextWidget(
                        "Photo",
                        fontSize: AppFont.font_12,
                        color: AppColor.grey,
                      ),
                    ),
                  ],
                )
              : Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        dataState.file.path
                                    .toString()
                                    .toLowerCase()
                                    .contains(".jpg") ||
                                dataState.file.path
                                    .toString()
                                    .toLowerCase()
                                    .contains(".png") ||
                                dataState.file.path
                                    .toString()
                                    .toLowerCase()
                                    .contains(".jpeg")
                            ? Image.file(
                                dataState.file,
                                fit: BoxFit.fill,
                                width: MediaQuery.of(context).size.width / 3,
                                height: MediaQuery.of(context).size.width / 4.5,
                              )
                            : dataState.file.path
                                    .toString()
                                    .toLowerCase()
                                    .contains(".pdf")
                                ? const Icon(Icons.picture_as_pdf_outlined)
                                : const Icon(Icons.document_scanner_outlined),
                        dataState.file.path
                                .toString()
                                .toLowerCase()
                                .contains(".pdf")
                            ? TextWidget(
                                dataState.file.path.split('/').last.toString(),
                                color: AppColor.themeColor,
                                fontSize: AppFont.font_12,
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.width / 3,
                        color: Colors.white.withOpacity(0.6),
                        child: Center(
                            child: Icon(
                          Icons.refresh,
                          color: AppColor.themeColor,
                        ))),
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
              TextButton(
                  onPressed: () {
                    BlocProvider.of<MiComplaintBloc>(context).add(
                        MiComplaintAddImageEvent(
                            context: context, mediaType: 1));
                    Navigator.pop(context);
                  },
                  child: TextWidget(
                    "Camera",
                    fontSize: AppFont.font_16,
                  )),
              const Divider(),
              TextButton(
                  onPressed: () {
                    BlocProvider.of<MiComplaintBloc>(context).add(
                        MiComplaintAddImageEvent(
                            context: context, mediaType: 2));
                    Navigator.pop(context);
                  },
                  child: TextWidget(
                    "Gallery",
                    fontSize: AppFont.font_16,
                  )),
            ],
          ),
        );
      },
    );
  }

  Widget _addSparesPartButton({required FetchMiComplaintDataState dataState}) {
    return Align(
      alignment: Alignment.topRight,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2.5,
        child: ButtonWidget(
            text: AppString.addPart,
            height:
                AppConfig.getDeviceType(context: context) == DeviceType.tablet
                    ? MediaQuery.of(context).size.height * 0.13
                    : null,
            onPressed: () async {
              BlocProvider.of<AddSparePartBloc>(context)
                  .add(AddSparePartPageLoadEvent(context: context));
              var result = await Navigator.push(context,
                  FadeRoute(page: const AddSparePartPage()));
            }),
      ),
    );
  }

  Widget _scrapCheckBoxWidget({required FetchMiComplaintDataState dataState}) {
    return Row(
      children: [
        Checkbox(
          value: dataState.isNoScrap,
          onChanged: (bool? value) async {
            BlocProvider.of<MiComplaintBloc>(context).add(
              MiComplaintSelectScrapData(isNoScrap: value!)
            );
            if(value == false){
              var result = await Navigator.push(context,
                  FadeRoute(page: const AddScrapPage()));
              if (!context.mounted) result;
              if (result.toString() == "Completed") {

              }
            }
          },
          activeColor: Colors.green,
          checkColor: Colors.white,
        ),
        const TextWidget("No Scrap"),
      ],
    );
  }


  Widget _addScarpButton({required FetchMiComplaintDataState dataState}) {
    return Align(
      alignment: Alignment.topRight,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2.5,
        child: ButtonWidget(
            text: AppString.addScrap,
            height:
            AppConfig.getDeviceType(context: context) == DeviceType.tablet
                ? MediaQuery.of(context).size.height * 0.13
                : null,
            onPressed: () async {
              var result = await Navigator.push(context,
                  FadeRoute(page: const AddScrapPage()));
              if (!context.mounted) result;
              if (result.toString() == "Completed") {

              }
            }),
      ),
    );
  }

  Widget _button({required FetchMiComplaintDataState dataState}) {
    return dataState.isLoader == false
        ? ButtonWidget(
            text: AppString.submit,
            height:
                AppConfig.getDeviceType(context: context) == DeviceType.tablet
                    ? MediaQuery.of(context).size.height * 0.13
                    : null,
            onPressed: () {
              BlocProvider.of<MiComplaintBloc>(context)
                  .add(MiComplaintSubmitData(context: context));
            })
        : const DottedLoaderWidget();
  }

  Widget _verticalSpace() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }
}
