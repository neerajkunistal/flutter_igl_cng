import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/domain/model/assginment_model.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/helper/view_assignment_helper.dart';
import 'package:flutter_igl_cng/feature/lcv/lcvTruckLiveRoute/presentation/page/lcv_truck_live_route_page.dart';
import 'package:flutter_igl_cng/feature/lcv/liveTracking/domain/model/tracking_model.dart';
import 'package:flutter_igl_cng/feature/lcv/liveTracking/helper/tracking_helper.dart';
import 'package:flutter_igl_cng/feature/lcv/request/helper/request_helper.dart';
import 'package:flutter_igl_cng/services/location/location_helper.dart';
import 'package:flutter_igl_cng/services/location/location_model.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'running_truck_event.dart';
part 'running_truck_state.dart';

class RunningTruckBloc extends Bloc<RunningTruckEvent, RunningTruckState> {
  LoginDataModel _userData = UserInfo.instance!.userData!;

  LoginDataModel get userData => _userData;

  List<AssignmentModel> _assignmentList = [];

  List<AssignmentModel> get assignmentList => _assignmentList;

  AssignmentModel _assignmentData = AssignmentModel();

  AssignmentModel get assignmentData => _assignmentData;

  LatLng _latLng = const LatLng(0.0, 0.0);

  LatLng get latLng => _latLng;

  bool _isLoader = false;

  bool get isLoader => _isLoader;

  Set<Marker> _markerRunningTruckPoints = {};

  Set<Marker> get markerRunningTruckPoints => _markerRunningTruckPoints;

  List<TrackingModel> _trackingList = [];

  List<TrackingModel> get trackingList => _trackingList;

  RunningTruckBloc() : super(RunningTruckInitial()) {
    on<RunningTruckPageLoadEvent>(_pageLoad);
  }

  _pageLoad(RunningTruckPageLoadEvent event, emit) async {
    emit(RunningTruckPageLoadState());
    _isLoader = false;
    _userData = UserInfo.instance!.userData!;
    var location = await LocationHelper
        .getLocationOfflineMode(context: event.context); // await isConnected() == true ? await LocationHelper.getLocation() :
    if (location != null) {
      LocationModel locationData = location;
      _latLng = LatLng(locationData.lat!, locationData.long!);
    }

    String currentDate = DateTime.now().toString();
    var runningTackingRes = await TrackingHelper.fetchLiveTrackingData(
        context: event.context,
        userData: userData,
        fromDate: currentDate,
        toDate: currentDate,
        isAllLocation: false);
    if (runningTackingRes != null) {
      _trackingList = runningTackingRes;
      for (int i = 0; i < trackingList.length; i++) {
        if (trackingList[i].lat.toString().isNotEmpty &&
            trackingList[i].long.toString().isNotEmpty) {
          final Uint8List? markerIcon = await RequestHelper.getBytesFromAsset(
              trackingList[i].status.toString() == "1"
                  ? AppIcon.runningIcon
                  : AppIcon.notRunningIcon,
              100);

          _markerRunningTruckPoints.add(Marker(
            markerId: MarkerId("${1 + i}Id"),
            position: LatLng(double.parse(trackingList[i].lat.toString()),
                double.parse(trackingList[i].long.toString())),
            infoWindow: InfoWindow(
                title: trackingList[i].driverName.toString(),
                onTap: () {
                  print("User Id === ----");
                  Navigator.push(
                    event.context,
                    MaterialPageRoute(
                        builder: (context) => LcvTruckLiveRoutePage(
                              driverUserId: trackingList[i].loginId.toString(),
                              routeId: trackingList[i].routeId.toString(),
                            )),
                  );
                }),
            icon: BitmapDescriptor.fromBytes(markerIcon!),
          ));
        }
      }
    }
    if (markerRunningTruckPoints.isNotEmpty) {
      Marker markerData = markerRunningTruckPoints.first;
      _latLng = markerData.position;
    }

    _assignmentData = AssignmentModel();
    _assignmentList = [];
    var res = await ViewAssignmentHelper.fetchAssignment(
        context: event.context, userData: userData);
    if (res != null) {
      _assignmentList = res;
      _assignmentList = assignmentList
          .where(
              (element) => element.assignmentStatus != AssignmentStatus.pending)
          .toList();

      List<AssignmentModel> _tempList = assignmentList
          .where((element) => element.outPressure.toString().isEmpty)
          .toList();
      _assignmentList = _tempList;
    }
    _eventComplete(emit);
  }

  _eventComplete(Emitter<RunningTruckState> emit) {
    emit(FetchRunningTruckDataState(
      assignmentList: assignmentList,
      isLoader: isLoader,
      latLng: latLng,
      markerRunningTruckPoints: markerRunningTruckPoints,
    ));
  }
}
