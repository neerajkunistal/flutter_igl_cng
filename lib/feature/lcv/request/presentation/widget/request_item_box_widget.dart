import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

class RequestItemBoxWidget extends StatelessWidget {
  final List<AssignmentModel> assignmentList;
  final AssignmentModel assignmentData;
  final int index;

  const RequestItemBoxWidget(
      {super.key,
      required this.index,
      required this.assignmentData,
      required this.assignmentList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.05,
      child: Card(
        color: AppColor.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextWidget(
                assignmentData.dbStationName.toString(),
                maxLines: 1,
                fontSize: AppFont.font_16,
                fontWeight: FontWeight.w600,
                color: EnvironmentConfig.of(context)!.primaryTheme,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ),
              TextWidget(
                "assignmentData.cngStationAddress.toString()",
                maxLines: 2,
                fontSize: AppFont.font_14,
                color: AppColor.black,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ),
              TextWidget(
                "${assignmentData.createdAt.toString()}",
                fontSize: AppFont.font_14,
                color: AppColor.grey,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ),
              _actionButton(
                context: context,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _delayTime({required String delay}) {
    return Row(
      children: [
        TextWidget("You are delay : ",
            color: AppColor.black,
            fontSize: AppFont.font_14,
            fontWeight: FontWeight.w500),
        Expanded(
          child: TextWidget(delay,
              color: AppColor.red,
              fontSize: AppFont.font_14,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _actionButton({required BuildContext context}) {
    return assignmentData.isSelected == false
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              assignmentData.assignmentStatus == AssignmentStatus.pending
                  ? TextButton(
                      onPressed: () {},
                      child: TextWidget(AppString.cancel, color: AppColor.red))
                  : const SizedBox.shrink(),
              assignmentData.assignmentStatus == AssignmentStatus.pending
                  ? TextButton(
                      onPressed: () {
                        BlocProvider.of<RequestBloc>(context).add(
                            RequestUpdateStatusEvent(
                                index: index, context: context));
                      },
                      child: TextWidget(AppString.confirm,
                          fontWeight: FontWeight.w700,
                          color: assignmentData.assignmentStatusColor))
                  : assignmentData.assignmentStatus == AssignmentStatus.confirm
                      ? TextButton(
                          onPressed: () async {
                            for (var assignment in assignmentList) {
                              if (assignment.assignmentStatus ==
                                      AssignmentStatus.startRoute &&
                                  assignmentList[index].assignmentStatus ==
                                      AssignmentStatus.confirm) {
                                SnackBarErrorWidget(context).show(
                                    message:
                                        "Your are already start route. Please complete work then you can start route.");
                                return;
                              }
                            }

                            BlocProvider.of<RequestBloc>(context).add(
                                RequestUploadPhotoEvent(
                                    photoIndex: 0, context: context));
                            showModalBottomSheet(
                                routeSettings: RouteSettings(
                                  name: PopRouteName.startRoute.toString(),
                                ),
                                isDismissible: false,
                                context: context,
                                builder: (context) => StartRouteWidget(
                                      index: index,
                                      mContext: context,
                                    ));
                          },
                          child: TextWidget(AppString.startRoute,
                              color: EnvironmentConfig.of(context)!.primaryTheme))
                      : assignmentData.assignmentStatus ==
                              AssignmentStatus.startRoute
                          ? Row(
                              children: [
                                TextButton(
                                    onPressed: () async {
                                      BlocProvider.of<NavigationRouteBloc>(
                                              context)
                                          .add(NavigationRoutePageLoadEvent(
                                              context: context));
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const NavigationRoutePage()),
                                      );
                                    },
                                    child: TextWidget("View Route",
                                        color: EnvironmentConfig.of(context)!.primaryTheme)),
                                TextButton(
                                    onPressed: () async {
                                      BlocProvider.of<RequestBloc>(context).add(
                                          RequestUploadPhotoEvent(
                                              photoIndex: 0, context: context));
                                      showModalBottomSheet(
                                          routeSettings: RouteSettings(
                                            name: PopRouteName.completeTask
                                                .toString(),
                                          ),
                                          isDismissible: false,
                                          context: context,
                                          builder: (context) =>
                                              CompleteTaskWidget(
                                                index: index,
                                                mContext: context,
                                              ));
                                    },
                                    child: TextWidget(AppString.complete,
                                        color: AppColor.red)),
                              ],
                            )
                          : const SizedBox.shrink(),
            ],
          )
        : const DottedLoaderWidget();
  }

  notificationDetails(
      {required String notificationTitle,
      required String notificationMessage}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(channel.id, channel.name,
            importance: Importance.high,
            icon: "@mipmap/launcher_icon",
            priority: Priority.high,
            playSound: false,
            enableLights: true,
            color: const Color(0xff2196f3),
            ledColor: const Color.fromARGB(255, 255, 0, 0),
            ledOnMs: 1000,
            ledOffMs: 500);

    DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      threadIdentifier: "thread1",
    );

    var initializationSettings = new InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings());

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (onDidReceiveNotificationResponse) async {
      //
    });

    flutterLocalNotificationsPlugin.show(
        12345678,
        "$notificationTitle",
        "$notificationMessage",
        NotificationDetails(
          iOS: iosNotificationDetails,
          android: androidPlatformChannelSpecifics,
        ));
  }
}
