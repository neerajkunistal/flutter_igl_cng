import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/lcvTruckLiveRoute/helper/lcv_truck_live_route_helper.dart';
import 'package:flutter_igl_cng/feature/lcv/liveTracking/domain/model/tracking_model.dart';
import 'package:flutter_igl_cng/feature/lcv/liveTracking/helper/tracking_helper.dart';
import 'package:flutter_igl_cng/feature/lcv/request/domain/model/cng_station_route_model.dart';
import 'package:flutter_igl_cng/feature/lcv/request/helper/request_helper.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'lcv_truck_live_route_event.dart';
part 'lcv_truck_live_route_state.dart';

class LcvTruckLiveRouteBloc
    extends Bloc<LcvTruckLiveRouteEvent, LcvTruckLiveRouteState> {
  Set<Marker> _markerTrackingPoints = {};

  Set<Marker> get markerTrackingPoints => _markerTrackingPoints;

  bool _isLoader = false;

  bool get isLoader => _isLoader;

  LatLng _latLng = const LatLng(0.0, 0.0);

  LatLng get latLng => _latLng;

  Set<Polyline> _polyline = {};

  Set<Polyline> get polyline => _polyline;

  List<TrackingModel> _trackingList = [];

  List<TrackingModel> get trackingList => _trackingList;

  LoginDataModel _userData = UserInfo.instance!.userData!;

  LoginDataModel get userData => _userData;

  List<CngStationRouteModel> _cngStationRouteList = [];

  List<CngStationRouteModel> get cngStationRouteList => _cngStationRouteList;

  LcvTruckLiveRouteBloc() : super(LcvTruckLiveRouteInitial()) {
    on<LcvTruckLiveRoutePageLoadEvent>(_pageLoad);
  }

  _pageLoad(LcvTruckLiveRoutePageLoadEvent event, emit) async {
    emit(LcvTruckLiveRoutePageLoadState());
    _markerTrackingPoints = {};
    _isLoader = false;
    _polyline = {};
    _userData = UserInfo.instance!.userData!;
    String currentDate = DateTime.now().toString();
    var runningTackingRes = await TrackingHelper.fetchLiveTrackingData(
        context: event.context,
        userData: userData,
        fromDate: currentDate,
        toDate: currentDate,
        isAllLocation: true,
        driverUserId: event.driverUserId);
    if (runningTackingRes != null) {
      _trackingList = runningTackingRes;

      int j = 1;
      List<LatLng> polylineCoordinates = [];
      for (var trackingData in trackingList) {
        if (trackingData.lat.toString().isNotEmpty &&
            trackingData.long.toString().isNotEmpty) {
          polylineCoordinates.add(LatLng(
              double.parse(trackingData.lat.toString()),
              double.parse(trackingData.long.toString())));
          _polyline.add(Polyline(
            polylineId: PolylineId("${j++}"),
            points: polylineCoordinates,
            color: Colors.blue,
            width: 5,
            consumeTapEvents: true,
            jointType: JointType.mitered,
            // startCap: Cap.customCapFromBitmap(BitmapDescriptor.defaultMarker),
            /*         endCap: Cap.customCapFromBitmap(BitmapDescriptor.defaultMarkerWithHue(40)),*/
          ));
        }
      }
    }

    if (trackingList.isNotEmpty) {
      TrackingModel trackingData = trackingList.last;
      if (trackingData.lat.toString().isNotEmpty &&
          trackingData.long.toString().isNotEmpty) {
        _latLng = LatLng(double.parse(trackingData.lat.toString()),
            double.parse(trackingData.long.toString()));

        final Uint8List? markerIcon = await RequestHelper.getBytesFromAsset(
            trackingData.status.toString() == "1"
                ? AppIcon.runningIcon
                : AppIcon.notRunningIcon,
            100);
        markerTrackingPoints.add(Marker(
          markerId: const MarkerId("${3334}Id"),
          position: latLng,
          icon: BitmapDescriptor.fromBytes(markerIcon!),
        ));
      }
    }
    var res = await RequestHelper.fetchRoute(
        context: event.context, userData: userData, routeId: event.routeId);
    if (res != null) {
      _cngStationRouteList = res;
      for (var cngStationRoute in cngStationRouteList) {
        var polylineRes =
            await LcvTruckLiveRouteHelper.createPolylineWithPoints(
                context: event.context,
                polyline: cngStationRoute.encodeRoute.toString(),
                selectedIndex: 0);
        _polyline.addAll(polylineRes);
      }
    }

    _eventComplete(emit);
  }

  _eventComplete(Emitter<LcvTruckLiveRouteState> emit) {
    emit(FetchLcvTruckLiveRouteDataState(
        isLoader: isLoader,
        polyline: polyline,
        markerTrackingPoints: markerTrackingPoints,
        latLng: latLng));
  }
}
