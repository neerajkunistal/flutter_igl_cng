import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/driver/registration/domain/bloc/registration_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/driver/registration/presentation/pages/registration_page.dart';
import 'package:flutter_igl_cng/feature/lcv/driver/viewDriver/domain/bloc/driver_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/driver/viewDriver/domain/model/driver_model.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/message_box_two_button_pop.dart';

class DriverItemBoxWidget extends StatelessWidget {
  final DriverModel driverData;
  final int index;

  const DriverItemBoxWidget(
      {super.key, required this.driverData, required this.index});

  @override
  Widget build(BuildContext context) {
    return _itemBuilder(index: index, driverData: driverData, context: context);
  }

  Widget _itemBuilder(
      {required int index,
      required DriverModel driverData,
      required BuildContext context}) {
    return Card(
      elevation: 2,
      shadowColor: AppColor.themeLightColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _driverName(driverName: driverData.driverName.toString()),
            _licenceNumber(
                licenseNumber: driverData.driverLicenseId.toString()),
            const Divider(),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            _number(mobileNumber: driverData.phoneNumber.toString()),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            _address(address: driverData.address.toString()),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            _driverStatus(status: driverData.deletedAt.toString()),
            driverData.deletedAt.toString().isEmpty
                ? Align(
                    alignment: Alignment.centerRight,
                    child: driverData.isSelected == false
                        ? _actionButtons(
                            driverData: driverData,
                            index: index,
                            context: context)
                        : const DottedLoaderWidget(),
                  )
                : const SizedBox.shrink(),
            Row(
              children: [
                _certificatePhoto(
                    pictureUrl: driverData.certificatePhoto.toString(),
                    context: context,
                    driverData: driverData),
                _licencePhoto(
                    pictureUrl: driverData.licencePhoto.toString(),
                    context: context,
                    driverData: driverData),
                _driverPhoto(
                    pictureUrl: driverData.driverPhoto.toString(),
                    context: context,
                    driverData: driverData),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _driverName({required String driverName}) {
    return TextWidget(driverName,
        color: AppColor.themeColor,
        fontSize: AppFont.font_16,
        fontWeight: FontWeight.w700);
  }

  Widget _licenceNumber({required String licenseNumber}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget("License No : ",
            color: AppColor.grey,
            fontSize: AppFont.font_12,
            fontWeight: FontWeight.w700),
        Expanded(
          child: TextWidget(licenseNumber,
              color: AppColor.grey,
              fontSize: AppFont.font_12,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _number({required String mobileNumber}) {
    return Row(
      children: [
        TextWidget("Mobile No. : ",
            color: AppColor.themeColor,
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

  Widget _driverStatus({required String status}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget("Status : ",
            color: AppColor.black,
            fontSize: AppFont.font_14,
            fontWeight: FontWeight.w400),
        Expanded(
          child: TextWidget(status.isEmpty ? "Active" : "Deactivate",
              color: status.isEmpty ? AppColor.themeColor : AppColor.red,
              fontSize: AppFont.font_14,
              fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _actionButtons(
      {required DriverModel driverData,
      required int index,
      required BuildContext context}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
            onPressed: () {
              BlocProvider.of<RegistrationBloc>(context).add(
                  RegistrationEditEvent(driverData: driverData, isEdit: true));
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const RegistrationPage()));
            },
            icon: Icon(
              Icons.edit_note_outlined,
              color: AppColor.themeColor,
            )),
        IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext mContext) =>
                      MessageBoxTwoButtonPopWidget(
                          message: "Do you want to Deactivate  this user?",
                          onPressed: () {
                            Navigator.pop(context);
                            BlocProvider.of<DriverBloc>(context).add(
                                DriverDeactivateEvent(
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

  Widget _certificatePhoto(
      {required String pictureUrl,
      required BuildContext context,
      required DriverModel driverData}) {
    return pictureUrl.isNotEmpty
        ? SizedBox.fromSize(
            size: Size.fromRadius(MediaQuery.of(context).size.width * 0.08),
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => Container(
                          height: MediaQuery.of(context).size.height / 1.5,
                          width: MediaQuery.of(context).size.width / 0.6,
                          child: Image.network(
                            pictureUrl,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, exception, stackTrace) {
                              return const SizedBox.shrink();
                            },
                          ),
                        ));
              },
              child: CircleAvatar(
                backgroundColor: AppColor.white,
                radius: MediaQuery.of(context).size.width * 0.15,
                child: Image.network(
                  pictureUrl,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, exception, stackTrace) {
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _licencePhoto(
      {required String pictureUrl,
      required BuildContext context,
      required DriverModel driverData}) {
    return pictureUrl.isNotEmpty
        ? SizedBox.fromSize(
            size: Size.fromRadius(MediaQuery.of(context).size.width * 0.08),
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => Container(
                          height: MediaQuery.of(context).size.height / 1.5,
                          width: MediaQuery.of(context).size.width / 0.6,
                          child: Image.network(
                            pictureUrl,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, exception, stackTrace) {
                              return const SizedBox.shrink();
                            },
                          ),
                        ));
              },
              child: CircleAvatar(
                backgroundColor: AppColor.white,
                radius: MediaQuery.of(context).size.width * 0.15,
                child: Image.network(
                  pictureUrl,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, exception, stackTrace) {
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _driverPhoto(
      {required String pictureUrl,
      required BuildContext context,
      required DriverModel driverData}) {
    return pictureUrl.isNotEmpty
        ? SizedBox.fromSize(
            size: Size.fromRadius(MediaQuery.of(context).size.width * 0.08),
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => Container(
                          height: MediaQuery.of(context).size.height / 1.5,
                          width: MediaQuery.of(context).size.width / 0.6,
                          child: Image.network(
                            pictureUrl,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, exception, stackTrace) {
                              return const SizedBox.shrink();
                            },
                          ),
                        ));
              },
              child: CircleAvatar(
                backgroundColor: AppColor.white,
                radius: MediaQuery.of(context).size.width * 0.15,
                child: Image.network(
                  pictureUrl,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, exception, stackTrace) {
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
