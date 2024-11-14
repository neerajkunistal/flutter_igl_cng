import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/domain/model/assginment_model.dart';
import 'package:flutter_igl_cng/feature/lcv/liveTracking/domain/model/tracking_model.dart';
import 'package:flutter_igl_cng/feature/lcv/request/helper/request_helper.dart';
import 'package:flutter_igl_cng/feature/lcv/runningTruck/domain/model/running_truck_model.dart';
import 'package:flutter_igl_cng/feature/lcv/runningTruck/domain/model/stations_point_model.dart';
import 'package:flutter_igl_cng/feature/lcv/runningTruck/helper/running_truck_helper.dart';
import 'package:flutter_igl_cng/services/location/location_helper.dart';
import 'package:flutter_igl_cng/services/location/location_model.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/message_box_two_button_pop.dart';
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

  List<RunningTruckModel> _runningTruckList  = [];

  List<RunningTruckModel> get runningTruckList  => _runningTruckList;

  List<StationPointModel> stationPointList = [];

  RunningTruckBloc() : super(RunningTruckInitial()) {
    on<RunningTruckPageLoadEvent>(_pageLoad);
  }

  _pageLoad(RunningTruckPageLoadEvent event, emit) async {
    _markerRunningTruckPoints = {};
    emit(RunningTruckPageLoadState());
    _isLoader = false;
    _userData = UserInfo.instance!.userData!;
    var location = await LocationHelper
        .getLocationOfflineMode(context: event.context); // await isConnected() == true ? await LocationHelper.getLocation() :
    if (location != null) {
      LocationModel locationData = location;
      _latLng = LatLng(locationData.lat!, locationData.long!);
    }

    var runningTackingRes = await RunningTruckHelper.fetchRunningTruck(
        context: !event.context.mounted ? event.context : event.context);
    if (runningTackingRes != null) {
      _runningTruckList = runningTackingRes;
      for (int i = 0; i < runningTruckList.length; i++) {
        if (runningTruckList[i].lat.toString().isNotEmpty &&
            runningTruckList[i].long.toString().isNotEmpty) {
          final Uint8List? markerIcon = await RequestHelper.getBytesFromAsset(
              double.parse(runningTruckList[i].speed.toString()) > 7
                  ? AppIcon.runningIcon
                  : AppIcon.notRunningIcon,
              50);

          _markerRunningTruckPoints.add(Marker(
            rotation: double.parse(runningTruckList[i].angle.toString())/2,
            markerId: MarkerId("${1 + i}Id"),
            position: LatLng(double.parse(runningTruckList[i].lat.toString()),
                double.parse(runningTruckList[i].long.toString())),
            infoWindow: InfoWindow(
                title: runningTruckList[i].vehicleNo.toString(),
                onTap: () {

                  showDialog(
                      context: event.context,
                      builder: (BuildContext mContext) => MessageBoxTwoButtonPopWidget(
                          message: "Speed - ${runningTruckList[i].speed.toString()}\n${runningTruckList[i].location}",
                          okButtonText: "Ok",
                          okButtonColour: AppColor.black,
                          onPressed: () => Navigator.of(event.context).pop(true)));
                  /*                 Navigator.push(
                    event.context,
                    MaterialPageRoute(
                        builder: (context) => LcvTruckLiveRoutePage(
                              driverUserId: trackingList[i].loginId.toString(),
                              routeId: trackingList[i].routeId.toString(),
                            )),
                  );*/
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

    stationPointList = [];
    var resStationPoint =  await RunningTruckHelper.fetchStationPointsData(
        context: !event.context.mounted ? event.context :event.context);
    if(resStationPoint != null){
      stationPointList = resStationPoint;
    }

    int j = runningTruckList.length;
    String name = "";

    for(var stationPointData in stationPointList) {

      Uint8List? markerIcon = await RequestHelper.getBytesFromAsset(AppIcon.cngStationIcon, 50);

      if(stationPointData.stationStatus.toString() == "0") // CNG Station
      {
        name = "CNG Station";
        markerIcon = await RequestHelper.getBytesFromAsset(AppIcon.cngStationIcon, 50);
      }
      else if(stationPointData.stationStatus.toString() == "1") // Mother Station
      {
        name = "Mother Station";
        markerIcon = await RequestHelper.getBytesFromAsset(AppIcon.motherStationIcon, 50);
      }
      else if(stationPointData.stationStatus.toString() == "2") // DB Station
      {
        name = "DB Station";
        markerIcon = await RequestHelper.getBytesFromAsset(AppIcon.motherStationIcon, 50);
      }

      var points =  stationPointData.wktPoint.toString().replaceAll("POINT(", "").toString().replaceAll(")", "");
      var pointList =  points.split(" ");
      if(pointList.isNotEmpty){
        double lng =  pointList[0].isNotEmpty ? double.parse(pointList[0].toString()) : 0.0;
        double lat =  pointList[1].isNotEmpty ? double.parse(pointList[1].toString()) : 0.0;
        _markerRunningTruckPoints.add(Marker(
          markerId: MarkerId("${1 + j}Id"),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
              title: "${stationPointData.name}\n$name",
              onTap: () {}),
          icon: BitmapDescriptor.fromBytes(markerIcon!),
        ));
      }
      j++;
    }

    _eventComplete(emit);
  }

  _eventComplete(Emitter<RunningTruckState> emit) {
    emit(FetchRunningTruckDataState(
      assignmentList: assignmentList,
      isLoader: isLoader,
      latLng: latLng,
      markerRunningTruckPoints: markerRunningTruckPoints,
      runningTruckList: runningTruckList,
    ));
  }
}
