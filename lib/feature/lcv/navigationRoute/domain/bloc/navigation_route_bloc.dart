import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/navigationRoute/helper/navigation_rote_helper.dart';
import 'package:flutter_igl_cng/feature/lcv/request/helper/request_helper.dart';
import 'package:flutter_igl_cng/services/location/location_helper.dart';
import 'package:flutter_igl_cng/services/location/location_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'navigation_route_event.dart';
part 'navigation_route_state.dart';

class NavigationRouteBloc
    extends Bloc<NavigationRouteEvent, NavigationRouteState> {
  LatLng _latLng = const LatLng(0.0, 0.0);

  LatLng get latLng => _latLng;

  Set<Marker> _currentLocationMarker = {};

  Set<Marker> get currentLocationMarker => _currentLocationMarker;

  Set<Polyline> _polyline = {};

  Set<Polyline> get polyline => _polyline;

  Set<Polyline> _routePolyLine = {};

  Set<Polyline> get routePolyLine => _routePolyLine;

  Set<Polyline> _tempPolyline = {};

  Set<Polyline> get tempPolyline => _tempPolyline;

  bool _isLoader = false;

  bool get isLoader => _isLoader;

  double _totalDistance = 0.0;

  double get totalDistance => _totalDistance;

  String _totalTime = "0";

  String get totalTime => _totalTime;

  CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(0.0, 0.0),
    zoom: 18.4746,
  );

  CameraPosition get cameraPosition => _cameraPosition;
  Completer<GoogleMapController> _controller = Completer();

  Completer<GoogleMapController> get controller => _controller;

  NavigationRouteBloc() : super(NavigationRouteInitial()) {
    on<NavigationRoutePageLoadEvent>(_pageLoad);
    on<NavigationRouteSetPolyLineEvent>(_setPolyline);
    on<NavigationRouteRefreshPageEvent>(_pageRefresh);
  }

  _pageLoad(NavigationRoutePageLoadEvent event, emit) async {
    emit(NavigationRoutePageLoadState());
    _isLoader = true;
    _currentLocationMarker = {};
    _totalDistance = 0.0;
    _totalTime = "0";
    _polyline = {};
    _controller = Completer();
    _eventCompleted(emit);
    _isLoader = false;
    _polyline = tempPolyline;
    _routePolyLine.clear();
    var location = await LocationHelper
        .getLocationOfflineMode(context: event.context); // await isConnected() == true ? await LocationHelper.getLocation() :
    if (location != null) {
      LocationModel locationData = location;
      _latLng = LatLng(locationData.lat!, locationData.long!);
    }
    final Uint8List? markerIcon =
        await RequestHelper.getBytesFromAsset(AppIcon.pumpIcon, 100);
    _currentLocationMarker.add(Marker(
      markerId: const MarkerId("currentLocation9890"),
      position: LatLng(
        latLng.latitude,
        latLng.longitude,
      ),
      icon: BitmapDescriptor.fromBytes(markerIcon!),
    ));
    _cameraPosition = CameraPosition(
      target: latLng,
      zoom: 18.4746,
    );

    int i = 0;
    for (var element in polyline) {
      for (var points in element.points) {
        if (element.points.length - 1 != i) {
          double _distance = await RequestHelper.calculateDistance(
              element.points[i].latitude,
              element.points[i].longitude,
              element.points[1 + i].latitude,
              element.points[1 + i].longitude);
          _totalDistance += _distance;
          i++;
        }
      }
    }
    double time = totalDistance * 2.6;
    _totalTime = durationToString(int.parse(time.toInt().toString()));
    _eventCompleted(emit);

    Set<Polyline> createPathPolyline = _polyline;

    var createRadiusRes =
        await NavigationRouteHelper.createRadiusPath(polyline: polyline);
    if (createRadiusRes != null) {
      _routePolyLine.addAll(createRadiusRes);
    }
    _eventCompleted(emit);

    var createRadiusRes1 = await NavigationRouteHelper.createRadiusPath1(
        polyline: createPathPolyline);
    if (createRadiusRes1 != null) {
      _routePolyLine.addAll(createRadiusRes1);
    }

    _routePolyLine.addAll(polyline);

    _eventCompleted(emit);
  }

  String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')} Hr : ${parts[1].padLeft(2, '0')} Mn';
  }

  _setPolyline(NavigationRouteSetPolyLineEvent event, emit) async {
    _polyline = event.polyline;
    _tempPolyline = event.polyline;
  }

  _pageRefresh(NavigationRouteRefreshPageEvent event, emit) async {
    /* _currentLocationMarker = {};
   var location =  await LocationHelper.getLocationOfflineMode(); // await isConnected() == true ? await LocationHelper.getLocation() :
    if(location != null){
      LocationModel locationData =  location;
      _latLng =  LatLng(locationData.lat!, locationData.long!);
    }
    // _latLng =   LatLng(28.601111, 77.370241);
    final Uint8List? markerIcon = await RequestHelper.getBytesFromAsset(
        AppIcon.mapIcon, 100);
    _currentLocationMarker.add(Marker(
      markerId: const MarkerId("currentLocation9890"),
      position:  latLng,
      icon: BitmapDescriptor.fromBytes(markerIcon!),)
    );
    _cameraPosition =   CameraPosition(
      target: latLng,
      zoom: 18.4746,
    );
    _isLoader =  false;
    _eventCompleted(emit);

    bool isInLocation = false;
    _totalDistance = 0.0;
    _polyline =  tempPolyline;
    for (var element in polyline) {
        for(int i = 0; i < element.points.length; i++){
          double kl = RequestHelper.calculateDistance(latLng.latitude, latLng.longitude,
              element.points[i].latitude, element.points[i].longitude);
          if(isInLocation == true){
            if(i != element.points.length -1){
              double _distance = await RequestHelper.calculateDistance(element.points[i].latitude,
                  element.points[i].longitude,
                  element.points[1+i].latitude, element.points[1+i].longitude);
              _totalDistance += _distance;
            }
          }
          if(kl*1000 > 100){
            // out Location
            isInLocation =  false;
            if(isInLocation == false){
              if(i != element.points.length -1){
                double _distance = await RequestHelper.calculateDistance(element.points[i].latitude,
                    element.points[i].longitude,
                    element.points[1+i].latitude, element.points[1+i].longitude);
                _totalDistance += _distance;
              }
            }
          } else {
            // in Location
            isInLocation =  true;
            if(isInLocation == true){
              if(i != element.points.length -1){
                double _distance = await RequestHelper.calculateDistance(element.points[i].latitude,
                    element.points[i].longitude,
                    element.points[1+i].latitude, element.points[1+i].longitude);
                _totalDistance += _distance;
              }
            }
          }
        }
      }
    double time = totalDistance * 2.6;
    _totalTime =  durationToString(int.parse(time.toInt().toString()));
    _eventCompleted(emit);

    var createRadiusRes =  await NavigationRouteHelper.createRadiusPath(polyline: polyline);
    if(createRadiusRes != null){
      _polyline.addAll(createRadiusRes);
    }
    _eventCompleted(emit);*/
  }

  _eventCompleted(Emitter<NavigationRouteState> emit) {
    emit(FetchNavigationRouteDataState(
        latLng: latLng,
        isLoader: isLoader,
        polyline: _routePolyLine,
        currentLocationMarker: currentLocationMarker,
        cameraPosition: cameraPosition,
        controller: controller,
        totalDistance: totalDistance,
        totalTime: totalTime));
  }
}
