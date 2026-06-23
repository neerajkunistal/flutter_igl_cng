import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/driver/registration/domain/bloc/registration_bloc.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({
    super.key,
  });

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  void initState() {
    BlocProvider.of<RegistrationBloc>(context)
        .add(RegistrationPageLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
          AppString.addDriver,
          color: AppColor.white,
          fontSize: AppFont.font_16,
        ),
      ),
      body: BlocBuilder<RegistrationBloc, RegistrationState>(
        builder: (context, state) {
          if (state is FetchRegistrationDataState) {
            return _itemBuilder(dataState: state);
          } else if (state is RegistrationPageLoadState) {
            return const Center(child: CenterLoaderWidget());
          } else {
            return const Center(child: CenterLoaderWidget());
          }
        },
      ),
    );
  }

  Widget _itemBuilder({required FetchRegistrationDataState dataState}) {
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _verticalSpace(context: context),
            _fullName(dataState: dataState),
            _verticalSpace(context: context),
            _drivingLicence(dataState: dataState),
            _verticalSpace(context: context),
            _email(dataState: dataState),
            _verticalSpace(context: context),
            _phone(dataState: dataState),
            _verticalSpace(context: context),
            _address(dataState: dataState),
            _verticalSpace(context: context),
            _city(dataState: dataState),
            _verticalSpace(context: context),
            _district(dataState: dataState),
            _verticalSpace(context: context),
            _state(dataState: dataState),
            _verticalSpace(context: context),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _uploadCertificatePhoto(context: context, dataState: dataState),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                _uploadLicencePhoto(context: context, dataState: dataState),
              ],
            ),
            _verticalSpace(context: context),
            _uploadDriverPhoto(context: context, dataState: dataState),
            _verticalSpace(context: context),
            _button(dataState: dataState, context: context),
          ],
        ),
      ),
    );
  }

  Widget _fullName({required FetchRegistrationDataState dataState}) {
    return TextFieldWidget(
      labelText: AppString.fullName,
      isRequired: true,
      controller: dataState.fullNameController,
    );
  }

  Widget _drivingLicence({required FetchRegistrationDataState dataState}) {
    return TextFieldWidget(
      labelText: AppString.drivingLicenceNumber,
      isRequired: true,
      controller: dataState.drivingLicenceNumberController,
    );
  }

  Widget _email({required FetchRegistrationDataState dataState}) {
    return TextFieldWidget(
      labelText: AppString.email,
      controller: dataState.emailController,
    );
  }

  Widget _phone({required FetchRegistrationDataState dataState}) {
    return TextFieldWidget(
      labelText: AppString.mobileNumber,
      isRequired: true,
      maxLength: 10,
      textInputType: TextInputType.number,
      controller: dataState.phoneNumberController,
    );
  }

  Widget _address({required FetchRegistrationDataState dataState}) {
    return TextFieldWidget(
      labelText: AppString.address,
      isRequired: true,
      controller: dataState.addressController,
    );
  }

  Widget _city({required FetchRegistrationDataState dataState}) {
    return TextFieldWidget(
      labelText: AppString.cityTown,
      isRequired: true,
      controller: dataState.cityController,
    );
  }

  Widget _district({required FetchRegistrationDataState dataState}) {
    return TextFieldWidget(
      labelText: AppString.district,
      isRequired: true,
      controller: dataState.districtController,
    );
  }

  Widget _state({required FetchRegistrationDataState dataState}) {
    return TextFieldWidget(
      labelText: AppString.state,
      isRequired: true,
      controller: dataState.stateController,
    );
  }

  Widget _button(
      {required FetchRegistrationDataState dataState,
      required BuildContext context}) {
    return dataState.isLoader == false
        ? ButtonWidget(
            text: AppString.submit,
            onPressed: () {
              BlocProvider.of<RegistrationBloc>(context).add(
                  RegistrationSubmitEvent(
                      context: context, roleType: RoleType.driver));
            })
        : const DottedLoaderWidget();
  }

  Widget _uploadCertificatePhoto(
      {required BuildContext context,
      required FetchRegistrationDataState dataState}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.width / 3,
      child: InkWell(
        onTap: () {
          BlocProvider.of<RegistrationBloc>(context).add(
              RegistrationUploadPhotoEvent(photoIndex: 1, context: context));
        },
        child: DottedBorder(
          color: AppColor.grey,
          strokeWidth: 1,
          child: dataState.uploadCertificateImage.path.isEmpty &&
                  (dataState.driverData.certificatePhoto == null ||
                      dataState.driverData.certificatePhoto.toString().isEmpty)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                      child: Icon(Icons.file_copy_outlined),
                    ),
                    Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.02),
                      child: TextWidget(
                        "Certificate",
                        fontSize: AppFont.font_12,
                        color: AppColor.grey,
                      ),
                    ),
                  ],
                )
              : Stack(
                  children: [
                    dataState.uploadCertificateImage.path.isEmpty &&
                            (dataState.driverData.certificatePhoto != null ||
                                dataState.driverData.certificatePhoto
                                    .toString()
                                    .isNotEmpty)
                        ? Image.network(
                            dataState.driverData.certificatePhoto.toString(),
                            fit: BoxFit.fill,
                            width: MediaQuery.of(context).size.width / 3.1,
                          )
                        : Image.file(
                            dataState.uploadCertificateImage,
                            fit: BoxFit.fill,
                            width: MediaQuery.of(context).size.width / 3.1,
                          ),
                    Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.width / 3,
                        color: Colors.white.withOpacity(0.6),
                        child: Center(
                            child: Icon(
                          Icons.refresh,
                          color: EnvironmentConfig.of(context)!.primaryTheme,
                        ))),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _uploadLicencePhoto(
      {required BuildContext context,
      required FetchRegistrationDataState dataState}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.width / 3,
      child: InkWell(
        onTap: () {
          BlocProvider.of<RegistrationBloc>(context).add(
              RegistrationUploadPhotoEvent(photoIndex: 2, context: context));
        },
        child: DottedBorder(
          color: AppColor.grey,
          strokeWidth: 1,
          child: dataState.uploadLicenceImage.path.isEmpty &&
                  (dataState.driverData.licencePhoto == null ||
                      dataState.driverData.licencePhoto.toString().isEmpty)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                      child: Icon(Icons.file_copy_outlined),
                    ),
                    Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.02),
                      child: TextWidget(
                        "Licence",
                        fontSize: AppFont.font_12,
                        color: AppColor.grey,
                      ),
                    ),
                  ],
                )
              : Stack(
                  children: [
                    dataState.uploadLicenceImage.path.isEmpty &&
                            (dataState.driverData.licencePhoto != null ||
                                dataState.driverData.licencePhoto
                                    .toString()
                                    .isNotEmpty)
                        ? Image.network(
                            dataState.driverData.licencePhoto.toString(),
                            fit: BoxFit.fill,
                            width: MediaQuery.of(context).size.width / 3.1,
                          )
                        : Image.file(
                            dataState.uploadLicenceImage,
                            fit: BoxFit.fill,
                            width: MediaQuery.of(context).size.width / 3.1,
                          ),
                    Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.width / 3,
                        color: Colors.white.withOpacity(0.6),
                        child: Center(
                            child: Icon(
                          Icons.refresh,
                          color: EnvironmentConfig.of(context)!.primaryTheme,
                        ))),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _uploadDriverPhoto(
      {required BuildContext context,
      required FetchRegistrationDataState dataState}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.width / 3,
      child: InkWell(
        onTap: () {
          BlocProvider.of<RegistrationBloc>(context).add(
              RegistrationUploadPhotoEvent(photoIndex: 3, context: context));
        },
        child: DottedBorder(
          color: AppColor.grey,
          strokeWidth: 1,
          child: dataState.uploadPhotoImage.path.isEmpty &&
                  (dataState.driverData.driverPhoto == null ||
                      dataState.driverData.driverPhoto.toString().isEmpty)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                      child: Icon(Icons.person),
                    ),
                    Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.02),
                      child: TextWidget(
                        "Driver Photo",
                        fontSize: AppFont.font_12,
                        color: AppColor.grey,
                      ),
                    ),
                  ],
                )
              : Stack(
                  children: [
                    dataState.uploadPhotoImage.path.isEmpty &&
                            (dataState.driverData.driverPhoto != null ||
                                dataState.driverData.driverPhoto
                                    .toString()
                                    .isNotEmpty)
                        ? Image.network(
                            dataState.driverData.driverPhoto.toString(),
                            fit: BoxFit.fill,
                            width: MediaQuery.of(context).size.width / 3.1,
                          )
                        : Image.file(
                            dataState.uploadPhotoImage,
                            fit: BoxFit.fill,
                            width: MediaQuery.of(context).size.width / 3.1,
                          ),
                    Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.width / 3,
                        color: Colors.white.withOpacity(0.6),
                        child: Center(
                            child: Icon(
                          Icons.refresh,
                          color: EnvironmentConfig.of(context)!.primaryTheme,
                        ))),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _verticalSpace({required BuildContext context}) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.03,
    );
  }
}
