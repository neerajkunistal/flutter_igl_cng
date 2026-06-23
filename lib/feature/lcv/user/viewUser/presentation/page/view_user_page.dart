import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';


class ViewUserPage extends StatefulWidget {
  const ViewUserPage({super.key});

  @override
  State<ViewUserPage> createState() => _ViewUserPageState();
}

class _ViewUserPageState extends State<ViewUserPage> {
  final LoginDataModel _userData = UserInfo.instance!.userData!;

  LoginDataModel get userData => _userData;

  @override
  void initState() {
    BlocProvider.of<ViewUserBloc>(context)
        .add(ViewUserPageLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: TextWidget(
          AppString.cngUser,
          color: AppColor.white,
          fontSize: AppFont.font_16,
        ),
        actions: [
          userData.roleType == RoleType.admin ||
                  userData.roleType == RoleType.lcvManager
              ? IconButton(
                  onPressed: () {
                    BlocProvider.of<AddUserBloc>(context).add(
                        AddUserEditEvent(userData: UserModel(), isEdit: false));
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AddUserPage()));
                  },
                  icon: Icon(
                    Icons.add,
                    color: AppColor.white,
                  ))
              : const SizedBox.shrink(),
        ],
      ),
      body: BlocBuilder<ViewUserBloc, ViewUserState>(
        builder: (context, state) {
          if (state is ViewUserPageLoadState) {
            return const Center(
              child: CenterLoaderWidget(),
            );
          } else if (state is FetchViewUserDateState) {
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

  Widget _listBuilder({required FetchViewUserDateState dataState}) {
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
      child: dataState.userList.isNotEmpty
          ? ListView.builder(
              itemCount: dataState.userList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return _itemBuilder(
                    index: index, userData: dataState.userList[index]);
              })
          : const Center(
              child: TextWidget("No User Found"),
            ),
    );
  }

  Widget _itemBuilder({required int index, required UserModel userData}) {
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _fullName(driverName: userData.fullName.toString()),
            const Divider(),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            _stationName(stationName: userData.stationName.toString()),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            _number(mobileNumber: userData.phoneNumber.toString()),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            _email(emailId: userData.email.toString()),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            _address(address: userData.address.toString()),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            _userStatus(status: userData.deleteAt.toString()),
            userData.deleteAt.toString().isEmpty
                ? Align(
                    alignment: Alignment.centerRight,
                    child: _actionButtons(userData: userData, index: index),
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  Widget _fullName({required String driverName}) {
    return TextWidget(driverName,
        color: EnvironmentConfig.of(context)!.primaryTheme,
        fontSize: AppFont.font_16,
        fontWeight: FontWeight.w700);
  }

  Widget _stationName({required String stationName}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget("Station Name : ",
            color: EnvironmentConfig.of(context)!.primaryTheme,
            fontSize: AppFont.font_14,
            fontWeight: FontWeight.w400),
        Expanded(
          child: TextWidget(stationName,
              color: AppColor.grey,
              fontSize: AppFont.font_14,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _number({required String mobileNumber}) {
    return Row(
      children: [
        TextWidget("Mobile No. : ",
            color: EnvironmentConfig.of(context)!.primaryTheme,
            fontSize: AppFont.font_14,
            fontWeight: FontWeight.w400),
        Expanded(
          child: TextWidget(mobileNumber,
              color: AppColor.black,
              fontSize: AppFont.font_14,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _email({required String emailId}) {
    return Row(
      children: [
        TextWidget("Email Id. : ",
            color: EnvironmentConfig.of(context)!.primaryTheme,
            fontSize: AppFont.font_14,
            fontWeight: FontWeight.w400),
        Expanded(
          child: TextWidget(emailId,
              color: AppColor.black,
              fontSize: AppFont.font_14,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _address({required String address}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget("Address : ",
            color: AppColor.grey,
            fontSize: AppFont.font_12,
            fontWeight: FontWeight.w700),
        Expanded(
          child: TextWidget(address,
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

  Widget _actionButtons({required UserModel userData, required int index}) {
    return userData.isSelected == false
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    BlocProvider.of<AddUserBloc>(context).add(
                        AddUserEditEvent(userData: userData, isEdit: true));
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AddUserPage()));
                  },
                  icon: Icon(
                    Icons.edit_note_outlined,
                    color: EnvironmentConfig.of(context)!.primaryTheme,
                  )),
              IconButton(
                  onPressed: () {
                    BlocProvider.of<AddUserBloc>(context).add(
                        AddUserEditEvent(userData: userData, isEdit: true));
                    showDialog(
                        context: context,
                        builder: (BuildContext mContext) =>
                            MessageBoxTwoButtonPopWidget(
                                message:
                                    "Do you want to Deactivate  this user?",
                                onPressed: () {
                                  Navigator.pop(context);
                                  BlocProvider.of<ViewUserBloc>(context).add(
                                      ViewUserDeleteEvent(
                                          context: context, index: index));
                                }));
                  },
                  icon: Icon(
                    Icons.delete_forever_outlined,
                    color: AppColor.red,
                  )),
            ],
          )
        : const DottedLoaderWidget();
  }
}
