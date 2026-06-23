import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/lcvTrack/addLcvTrack/domain/bloc/add_lcv_track_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/lcvTrack/addLcvTrack/presentation/page/add_lcv_track_page.dart';

class ViewLcvTrackPage extends StatefulWidget {
  const ViewLcvTrackPage({super.key});

  @override
  State<ViewLcvTrackPage> createState() => _ViewLcvTrackPageState();
}

class _ViewLcvTrackPageState extends State<ViewLcvTrackPage> {
  final LoginDataModel _userData = UserInfo.instance!.userData!;

  LoginDataModel get userData => _userData;

  @override
  void initState() {
    BlocProvider.of<ViewLcvTrackBloc>(context)
        .add(ViewLcvTruckPageLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: TextWidget(
          AppString.lcvTruck,
          color: AppColor.white,
          fontSize: AppFont.font_16,
        ),
        actions: [
          userData.roleType == RoleType.admin ||
                  userData.roleType == RoleType.lcvManager
              ? IconButton(
                  onPressed: () {
                    BlocProvider.of<AddLcvTrackBloc>(context).add(
                        AddLcvTruckEditEvent(
                            lcvTruckData: LcvTruckModel(), isEdit: false));
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AddLcvTrackPage()));
                  },
                  icon: Icon(
                    Icons.add,
                    color: AppColor.white,
                  ))
              : const SizedBox.shrink(),
        ],
      ),
      body: BlocBuilder<ViewLcvTrackBloc, ViewLcvTrackState>(
        builder: (context, state) {
          if (state is ViewLcvTrackPageLoadState) {
            return const Center(
              child: CenterLoaderWidget(),
            );
          } else if (state is FetchViewLcvTrackDataState) {
            return _listBuilder(dataState: state);
          } else {
            return const Center(
              child: CenterLoaderWidget(),
            );
          }
        },
      ),
    );
  }

  Widget _listBuilder({required FetchViewLcvTrackDataState dataState}) {
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
      child: dataState.lcvTruckList.isNotEmpty
          ? ListView.builder(
              itemCount: dataState.lcvTruckList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return _itemBuilder(
                    index: index, lcvTruckData: dataState.lcvTruckList[index]);
              })
          : const Center(
              child: TextWidget("No Lcv Track Found"),
            ),
    );
  }

  Widget _itemBuilder(
      {required int index, required LcvTruckModel lcvTruckData}) {
    return Card(
      elevation: 2,
      shadowColor: EnvironmentConfig.of(context)!.secondaryTheme,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _truckNumber(truckNumber: lcvTruckData.vehicleNo.toString()),
            const Divider(),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            _vehicleName(vehicleName: lcvTruckData.vehicleName.toString()),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            _engineNumber(engineNumber: lcvTruckData.engineNumber.toString()),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            _chassisNumber(
                chassisNumber: lcvTruckData.chassisNumber.toString()),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            _average(average: lcvTruckData.average.toString()),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            _fuelType(fuelType: lcvTruckData.fuelType.toString()),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            _userStatus(status: lcvTruckData.deletedAt.toString()),
            lcvTruckData.deletedAt.toString().isEmpty
                ? Align(
                    alignment: Alignment.centerRight,
                    child: lcvTruckData.isSelected == false
                        ? _actionButtons(
                            lcvTruckData: lcvTruckData, index: index)
                        : const DottedLoaderWidget(),
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  Widget _truckNumber({required String truckNumber}) {
    return TextWidget(truckNumber,
        color: EnvironmentConfig.of(context)!.primaryTheme,
        fontSize: AppFont.font_16,
        fontWeight: FontWeight.w700);
  }

  Widget _vehicleName({required String vehicleName}) {
    return Row(
      children: [
        TextWidget("Vehicle name : ",
            color: EnvironmentConfig.of(context)!.primaryTheme,
            fontSize: AppFont.font_14,
            fontWeight: FontWeight.w400),
        Expanded(
          child: TextWidget(vehicleName,
              color: AppColor.black,
              fontSize: AppFont.font_14,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _engineNumber({required String engineNumber}) {
    return Row(
      children: [
        TextWidget("Engine No. : ",
            color: EnvironmentConfig.of(context)!.primaryTheme,
            fontSize: AppFont.font_14,
            fontWeight: FontWeight.w400),
        Expanded(
          child: TextWidget(engineNumber,
              color: AppColor.black,
              fontSize: AppFont.font_14,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _chassisNumber({required String chassisNumber}) {
    return Row(
      children: [
        TextWidget("Chassis No. : ",
            color: EnvironmentConfig.of(context)!.primaryTheme,
            fontSize: AppFont.font_14,
            fontWeight: FontWeight.w400),
        Expanded(
          child: TextWidget(chassisNumber,
              color: AppColor.black,
              fontSize: AppFont.font_14,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _average({required String average}) {
    return Row(
      children: [
        TextWidget("Vehicle Aver. : ",
            color: EnvironmentConfig.of(context)!.primaryTheme,
            fontSize: AppFont.font_14,
            fontWeight: FontWeight.w400),
        Expanded(
          child: TextWidget(average,
              color: AppColor.black,
              fontSize: AppFont.font_14,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _fuelType({required String fuelType}) {
    //
    return Row(
      children: [
        TextWidget("Fuel Type : ",
            color: EnvironmentConfig.of(context)!.primaryTheme,
            fontSize: AppFont.font_14,
            fontWeight: FontWeight.w400),
        Expanded(
          child: TextWidget(
              fuelType == "1"
                  ? "Diesel"
                  : fuelType == "2"
                      ? "Petrol"
                      : fuelType == "3"
                          ? "CNG"
                          : "",
              color: AppColor.black,
              fontSize: AppFont.font_14,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _userStatus({required String status}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget("Status : ",
            color: AppColor.black,
            fontSize: AppFont.font_14,
            fontWeight: FontWeight.w400),
        Expanded(
          child: TextWidget(status.isEmpty ? "Active" : "Deactivate",
              color: status.isEmpty ? EnvironmentConfig.of(context)!.primaryTheme : AppColor.red,
              fontSize: AppFont.font_14,
              fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _actionButtons(
      {required LcvTruckModel lcvTruckData, required int index}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
/*        IconButton(onPressed: () {
          BlocProvider.of<AddLcvTrackBloc>(context).add(
              AddLcvTruckEditEvent(lcvTruckData: lcvTruckData, isEdit:  true));
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddLcvTrackPage()));
        },
            icon: Icon(Icons.edit_note_outlined, color: EnvironmentConfig.of(context)!.primaryTheme,)),*/

        IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext mContext) =>
                      MessageBoxTwoButtonPopWidget(
                          message: "Do you want to Deactivate this Lcv Truck?",
                          onPressed: () {
                            Navigator.pop(context);
                            BlocProvider.of<ViewLcvTrackBloc>(context).add(
                                ViewLcvTruckDeleteStationEvent(
                                    context: context, index: index));
                          }));
            },
            icon: Icon(
              Icons.delete_forever_outlined,
              color: AppColor.red,
            )),
      ],
    );
  }
}
