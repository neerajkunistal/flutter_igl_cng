import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/geoLocation/domain/bloc/geo_location_event.dart';

class CNGStationPage extends StatefulWidget {
  const CNGStationPage({super.key});

  @override
  State<CNGStationPage> createState() => _CNGStationPageState();
}

class _CNGStationPageState extends State<CNGStationPage> {
  final LoginDataModel _userData = UserInfo.instance!.userData!;

  LoginDataModel get userData => _userData;

  @override
  void initState() {
    BlocProvider.of<CngStationBloc>(context)
        .add(CngStationPageLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: TextWidget(
          AppString.cngStations,
          color: AppColor.white,
          fontSize: AppFont.font_16,
        ),
        actions: [
          userData.roleType == RoleType.admin ||
                  userData.roleType == RoleType.lcvManager
              ? IconButton(
                  onPressed: () {
                    BlocProvider.of<AddCngStationBloc>(context).add(
                        AddCngStationEditEvent(
                            isEdit: false, cngStationData: CngStationModel()));
                    BlocProvider.of<AddCngStationBloc>(context)
                        .add(AddCngStationSetAddressEvent(address: ""));
                    BlocProvider.of<GeoLocationBloc>(context)
                        .add(PageLoadingEvent(address: ""));
                    BlocProvider.of<AddCngStationBloc>(context)
                        .add(AddCngStationPageLoadEvent(context: context));
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AddCngStationPage()));
                  },
                  icon: Icon(
                    Icons.add,
                    color: AppColor.white,
                  ))
              : const SizedBox.shrink(),
        ],
      ),
      body: BlocBuilder<CngStationBloc, CngStationState>(
        builder: (context, state) {
          if (state is CngStationPageLoadState) {
            return const Center(
              child: CenterLoaderWidget(),
            );
          } else if (state is FetchCngStationDataState) {
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

  Widget _listBuilder({required FetchCngStationDataState dataState}) {
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
      child: dataState.cngStationList.isNotEmpty
          ? ListView.builder(
              itemCount: dataState.cngStationList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return _itemBuilder(
                    index: index,
                    cngStationData: dataState.cngStationList[index]);
              })
          : const Center(
              child: TextWidget("No CNG Station Found"),
            ),
    );
  }

  Widget _itemBuilder(
      {required int index, required CngStationModel cngStationData}) {
    return Card(
      elevation: 2,
      shadowColor: EnvironmentConfig.of(context)!.secondaryTheme,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
        child: Column(
          children: [
            _stationName(stationName: cngStationData.stationName.toString()),
            const Divider(),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            _officerName(stationName: cngStationData.officerName.toString()),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            _number(stationName: cngStationData.phoneNumber.toString()),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            _email(email: cngStationData.companyEmail.toString()),
            const Divider(),
            _cngStationAddress(
                cngStationAddress: cngStationData.address.toString()),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            _userStatus(status: cngStationData.deletedAt.toString()),
            cngStationData.deletedAt.toString().isEmpty
                ? Align(
                    alignment: Alignment.centerRight,
                    child: cngStationData.isSelected == false
                        ? _actionButtons(
                            cngStationData: cngStationData, index: index)
                        : const DottedLoaderWidget(),
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  Widget _stationName({required String stationName}) {
    return Row(
      children: [
        TextWidget("",
            color: EnvironmentConfig.of(context)!.primaryTheme,
            fontSize: AppFont.font_14,
            fontWeight: FontWeight.w700),
        Expanded(
          child: TextWidget(stationName,
              color: EnvironmentConfig.of(context)!.primaryTheme,
              fontSize: AppFont.font_16,
              fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _officerName({required String stationName}) {
    return Row(
      children: [
        TextWidget("Officer Name : ",
            color: EnvironmentConfig.of(context)!.primaryTheme,
            fontSize: AppFont.font_14,
            fontWeight: FontWeight.w400),
        Expanded(
          child: TextWidget(stationName,
              color: AppColor.black,
              fontSize: AppFont.font_14,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _number({required String stationName}) {
    return Row(
      children: [
        TextWidget("Mobile No. : ",
            color: EnvironmentConfig.of(context)!.primaryTheme,
            fontSize: AppFont.font_14,
            fontWeight: FontWeight.w400),
        Expanded(
          child: TextWidget(stationName,
              color: AppColor.black,
              fontSize: AppFont.font_14,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _email({required String email}) {
    return Row(
      children: [
        TextWidget("Email Id : ",
            color: EnvironmentConfig.of(context)!.primaryTheme,
            fontSize: AppFont.font_14,
            fontWeight: FontWeight.w400),
        Expanded(
          child: TextWidget(email,
              color: AppColor.black,
              fontSize: AppFont.font_14,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _cngStationAddress({required String cngStationAddress}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget("Address : ",
            color: AppColor.grey,
            fontSize: AppFont.font_12,
            fontWeight: FontWeight.w700),
        Expanded(
          child: TextWidget(cngStationAddress,
              color: AppColor.grey,
              fontSize: AppFont.font_12,
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
      {required CngStationModel cngStationData, required int index}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
            onPressed: () {
              BlocProvider.of<AddCngStationBloc>(context).add(
                  AddCngStationEditEvent(
                      isEdit: true, cngStationData: cngStationData));
              BlocProvider.of<AddCngStationBloc>(context)
                  .add(AddCngStationPageLoadEvent(context: context));
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AddCngStationPage()));
            },
            icon: Icon(
              Icons.edit_note_outlined,
              color: EnvironmentConfig.of(context)!.primaryTheme,
            )),
        IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext mContext) =>
                      MessageBoxTwoButtonPopWidget(
                          message:
                              "Do you want to Deactivate this CNG Station?",
                          onPressed: () {
                            Navigator.pop(context);
                            BlocProvider.of<CngStationBloc>(context).add(
                                CngStationDeleteStationEvent(
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
