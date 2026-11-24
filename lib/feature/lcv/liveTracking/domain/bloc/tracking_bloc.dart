import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/addAssignment/domain/model/mother_station_model.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/addAssignment/helper/add_assignment_helper.dart';
import 'package:flutter_igl_cng/feature/lcv/cngStation/viewCNGStation/domain/model/cng_stattion_model.dart';
import 'package:flutter_igl_cng/feature/lcv/cngStation/viewCNGStation/helper/cng_station_helper.dart';
import 'package:flutter_igl_cng/feature/lcv/lcvTruckLiveRoute/presentation/page/lcv_truck_live_route_page.dart';
import 'package:flutter_igl_cng/feature/lcv/liveTracking/domain/model/tracking_model.dart';
import 'package:flutter_igl_cng/feature/lcv/liveTracking/helper/tracking_helper.dart';
import 'package:flutter_igl_cng/feature/lcv/request/helper/request_helper.dart';
import 'package:flutter_igl_cng/services/location/location_helper.dart';
import 'package:flutter_igl_cng/services/location/location_model.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'tracking_event.dart';
part 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  Set<Marker> _markerTrackingPoints = {};

  Set<Marker> get markerTrackingPoints => _markerTrackingPoints;

  bool _isLoader = false;

  bool get isLoader => _isLoader;

  List<TrackingModel> _trackingList = [];

  List<TrackingModel> get trackingList => _trackingList;

  LatLng _latLng = const LatLng(0.0, 0.0);

  LatLng get latLng => _latLng;

  LoginDataModel _userData = UserInfo.instance!.userData!;

  LoginDataModel get userData => _userData;

  List<MotherStationModel> _motherStationList = [];

  List<MotherStationModel> get motherStationList => _motherStationList;

  List<CngStationModel> _cngStationList = [];

  List<CngStationModel> get cngStationList => _cngStationList;

  TrackingBloc() : super(TrackingInitial()) {
    on<TrackingPageLoadEvent>(_pageLoad);
  }

  _pageLoad(TrackingPageLoadEvent event, emit) async {
    emit(TrackingPageLoadState());
    _userData = UserInfo.instance!.userData!;
    _trackingList = [];
    _isLoader = false;
    _markerTrackingPoints = {};
    _latLng = const LatLng(0.0, 0.0);
    var location = await LocationHelper
        .getLocationOfflineMode(context: event.context); // await isConnected() == true ? await LocationHelper.getLocation() :
    if (location != null) {
      LocationModel locationData = location;
      _latLng = LatLng(locationData.lat!, locationData.long!);
    }

    int j = 0;
    var motherStationRes = await AddAssignmentHelper.fetchMotherStationData(
        context: event.context, userData: userData);
    if (motherStationRes != null) {
      _motherStationList = motherStationRes;
      for (var motherStation in motherStationList) {
        if (motherStation.lat.toString().isNotEmpty &&
            motherStation.long.toString().isNotEmpty) {
          final Uint8List? markerIcon = await RequestHelper.getBytesFromAsset(
              AppIcon.motherStationIcon, 70);

          _markerTrackingPoints.add(Marker(
            markerId: MarkerId("${j++}Id"),
            position: LatLng(double.parse(motherStation.lat.toString()),
                double.parse(motherStation.long.toString())),
            infoWindow: InfoWindow(
              title: motherStation.stationName.toString(),
              snippet: "Mother Station",
              /*          onTap: (){

                }*/
            ),
            icon: BitmapDescriptor.fromBytes(markerIcon!),
          ));
        }
      }
    }

    var cngStationRes = await CNGStationHelper.fetchCNGStationData(
        context: event.context, userData: userData);
    if (cngStationRes != null) {
      _cngStationList = cngStationRes;
      for (var cngStation in cngStationList) {
        if (cngStation.lat.toString().isNotEmpty &&
            cngStation.long.toString().isNotEmpty) {
          final Uint8List? markerIcon =
              await RequestHelper.getBytesFromAsset(AppIcon.cngStationIcon, 60);
          _markerTrackingPoints.add(Marker(
            markerId: MarkerId("${j++}Id"),
            position: LatLng(double.parse(cngStation.lat.toString()),
                double.parse(cngStation.long.toString())),
            infoWindow: InfoWindow(
                title: cngStation.stationName.toString(),
                snippet: "CNG Station",
                onTap: () {
                  print("sdlsdlsd ==============");
                }),
            icon: BitmapDescriptor.fromBytes(markerIcon!),
          ));
        }
      }
    }
    String currentDate = DateTime.now().toString();
    var res = await TrackingHelper.fetchLiveTrackingData(
        context: event.context,
        userData: userData,
        fromDate: currentDate,
        toDate: currentDate,
        isAllLocation: false);
    if (res != null) {
      _trackingList = res;
      for (int i = 0; i < trackingList.length; i++) {
        if (trackingList[i].lat.toString().isNotEmpty &&
            trackingList[i].long.toString().isNotEmpty) {
          final Uint8List? markerIcon = await RequestHelper.getBytesFromAsset(
              trackingList[i].status.toString() == "1"
                  ? AppIcon.runningIcon
                  : AppIcon.notRunningIcon,
              100);

          _markerTrackingPoints.add(Marker(
            markerId: MarkerId("${j++}Id"),
            position: LatLng(double.parse(trackingList[i].lat.toString()),
                double.parse(trackingList[i].long.toString())),
            infoWindow: InfoWindow(
                title: trackingList[i].driverName.toString(),
                onTap: () {
                  print(
                      "User Id === ---- ${trackingList[i].loginId.toString()}");
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

    if (markerTrackingPoints.isNotEmpty) {
      Marker markerData = markerTrackingPoints.last;
      _latLng = markerData.position;
    }

    _eventCompleted(emit);
  }

  _eventCompleted(Emitter<TrackingState> emit) {
    emit(FetchTrackingDataState(
      isLoader: isLoader,
      trackingList: trackingList,
      markerTrackingPoints: markerTrackingPoints,
      latLng: latLng,
    ));
  }
}
