import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/request/domain/bloc/request_bloc.dart';

class CompleteTaskWidget extends StatelessWidget {
  final int index;
  final BuildContext mContext;

  const CompleteTaskWidget(
      {super.key, required this.index, required this.mContext});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestBloc, RequestState>(
      builder: (context, state) {
        if (state is FetchRequestDataState) {
          return _itemBuilder(dataState: state, context: context);
        } else {
          return const Center(
            child: CenterLoaderWidget(),
          );
        }
      },
    );
  }

  Widget _itemBuilder(
      {required FetchRequestDataState dataState,
      required BuildContext context}) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        height: MediaQuery.of(context).size.height / 2,
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            dataState.isStartRoute == false
                ? Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                    ),
                  )
                : const SizedBox.shrink(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _selectTruckPhoto(context: context, dataState: dataState),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                _selfieePhoto(context: context, dataState: dataState),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            _startButton(dataState: dataState, context: context),
          ],
        ),
      ),
    );
  }

  Widget _selectTruckPhoto(
      {required BuildContext context,
      required FetchRequestDataState dataState}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.width / 3,
      child: InkWell(
        onTap: () {
          BlocProvider.of<RequestBloc>(context)
              .add(RequestUploadPhotoEvent(photoIndex: 1, context: context));
        },
        child: DottedBorder(
          color: AppColor.grey,
          strokeWidth: 1,
          child: dataState.uploadTruckImage.path.isEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                      child: Icon(Icons.fire_truck),
                    ),
                    Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.02),
                      child: TextWidget(
                        "Truck Photo",
                        fontSize: AppFont.font_12,
                        color: AppColor.grey,
                      ),
                    ),
                  ],
                )
              : Stack(
                  children: [
                    Image.file(
                      dataState.uploadTruckImage,
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
                          color: AppColor.themeColor,
                        ))),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _selfieePhoto(
      {required BuildContext context,
      required FetchRequestDataState dataState}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.width / 3,
      child: InkWell(
        onTap: () {
          BlocProvider.of<RequestBloc>(context)
              .add(RequestUploadPhotoEvent(photoIndex: 2, context: context));
        },
        child: DottedBorder(
          color: AppColor.grey,
          strokeWidth: 1,
          child: dataState.uploadPhotoImage.path.isEmpty
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
                        "Self Photo",
                        fontSize: AppFont.font_12,
                        color: AppColor.grey,
                      ),
                    ),
                  ],
                )
              : Stack(
                  children: [
                    Image.file(
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
                          color: AppColor.themeColor,
                        ))),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _startButton(
      {required FetchRequestDataState dataState,
      required BuildContext context}) {
    return dataState.isStartRoute == false
        ? ButtonWidget(
            text: AppString.complete,
            onPressed: () {
              BlocProvider.of<RequestBloc>(context).add(
                  RequestUpdateStatusEvent(index: index, context: mContext));
            })
        : const DottedLoaderWidget();
  }
}
