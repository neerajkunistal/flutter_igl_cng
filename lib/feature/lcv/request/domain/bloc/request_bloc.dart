import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/addAssignment/helper/add_assignment_helper.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/domain/model/assginment_model.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/helper/view_assignment_helper.dart';
import 'package:flutter_igl_cng/feature/lcv/navigationRoute/domain/bloc/navigation_route_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/request/domain/model/cng_station_route_model.dart';
import 'package:flutter_igl_cng/feature/lcv/request/domain/model/request_model.dart';
import 'package:flutter_igl_cng/feature/lcv/request/helper/request_helper.dart';
import 'package:flutter_igl_cng/root.dart';
import 'package:flutter_igl_cng/services/firebase/notification_service.dart';
import 'package:flutter_igl_cng/services/location/location_helper.dart';
import 'package:flutter_igl_cng/services/location/location_model.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';
import 'package:flutter_igl_cng/utils/hive/hive_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'request_event.dart';
part 'request_state.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  bool _isLoader = false;

  bool get isLoader => _isLoader;

  List<RequestModel> _requestList = [];

  List<RequestModel> get requestList => _requestList;

  RequestModel _requestData = RequestModel();

  RequestModel get requestData => _requestData;

  double _currentLat = 28.606447;

  double get currentLat => _currentLat;

  double _currentLong = 77.379984;

  double get currentLong => _currentLong;

  Set<Marker> _currentLocationMarker = {};

  Set<Marker> get currentLocationMarker => _currentLocationMarker;

  Set<Polyline> _polylines = {};

  Set<Polyline> get polylines => _polylines;

  Set<Polyline> _selectedPolyline = {};

  Set<Polyline> get selectedPolyline => _selectedPolyline;

  int _routeIndex = 0;

  int get routeIndex => _routeIndex;

  LoginDataModel _userData = UserInfo.instance!.userData!;

  LoginDataModel get userData => _userData;

  List<AssignmentModel> _assignmentList = [];

  List<AssignmentModel> get assignmentList => _assignmentList;

  AssignmentModel _assignmentData = AssignmentModel();

  AssignmentModel get assignmentData => _assignmentData;

  TextEditingController scmQuantityController = TextEditingController();

  List<CngStationRouteModel> _cngStationRouteList = [];

  List<CngStationRouteModel> get cngStationRouteList => _cngStationRouteList;

  CngStationRouteModel _cngStationRouteData = CngStationRouteModel();

  CngStationRouteModel get cngStationRouteData => _cngStationRouteData;

  LatLng _latLng = const LatLng(0.0, 0.0);

  LatLng get latLng => _latLng;

  int _photoIndex = 0;

  int get photoIndex => _photoIndex;

  late File uploadTruckImage;
  late File uploadPhotoImage;
  late File uploadSlipImage;

  bool _isStartRoute = false;

  bool get isStartRoute => _isStartRoute;

  late Timer _timer;

  RequestBloc() : super(RequestInitial()) {
    on<RequestPageEvent>(_pageLoad);
    on<RequestSetRoutesEvent>(_setRoutes);
    on<RequestConfirmEvent>(_requestConfirm);
    on<RequestUploadPhotoEvent>(_uploadPhoto);
    on<RequestImagePikerEvent>(_uploadImage);
    on<RequestUpdateStatusEvent>(_updateStatus);
  }

  _pageLoad(RequestPageEvent event, emit) async {
    emit(RequestPageLoadState());
    _isLoader = false;
    _currentLat = 28.606447;
    _currentLong = 77.379984;
    _requestList = [];
    _selectedPolyline = {};
    _routeIndex = 0;
    _requestData = RequestModel();
    _assignmentList = [];
    _assignmentData = AssignmentModel();
    _photoIndex = 0;
    uploadPhotoImage = File("");
    uploadTruckImage = File("");
    uploadSlipImage = File("");
    _isStartRoute = false;
    scmQuantityController.text = "";
    _cngStationRouteList = [];
    _polylines = {};
    _cngStationRouteData = CngStationRouteModel();
    _userData = UserInfo.instance!.userData!;
    var location = await LocationHelper
        .getLocationOfflineMode(context: event.context); //// await isConnected() == true ? await LocationHelper.getLocation() :
    if (location != null) {
      LocationModel locationData = location;
      _latLng = LatLng(locationData.lat!, locationData.long!);
    }

    _currentLocationMarker = {};
    final Uint8List? markerIcon =
        await RequestHelper.getBytesFromAsset(AppIcon.mapIcon, 100);
    _currentLocationMarker.add(Marker(
      markerId: const MarkerId("currentLocation9890"),
      position: LatLng(latLng.latitude, latLng.longitude),
      icon: BitmapDescriptor.fromBytes(markerIcon!),
    ));

    var res = await RequestHelper.fetchRequestData(context: event.context);
    if (res != null) {
      _requestList = res;
    }

    var assignmentRes = await ViewAssignmentHelper.fetchAssignment(
        context: event.context, userData: userData);
    if (assignmentRes != null) {
      _assignmentList = assignmentRes;
      List<AssignmentModel> _tempList = assignmentList
          .where((element) =>
              element.assignmentStatus != AssignmentStatus.complete)
          .toList();
      _assignmentList = _tempList;
    }

    for (var assignemnt in assignmentList) {
      if (assignemnt.assignmentStatus == AssignmentStatus.confirm ||
          assignemnt.assignmentStatus == AssignmentStatus.startRoute) {
        var routeRes = await RequestHelper.fetchRoute(
            context: event.context,
            userData: userData,
            routeId: assignemnt.routeId);
        if (routeRes != null) {
          _cngStationRouteList = routeRes;
        }
      }
    }

    if (cngStationRouteList.isNotEmpty) {
      var polyLineRes = await RequestHelper.createPolylineWithPoints(
          context: event.context,
          cngStationRouteList: cngStationRouteList,
          selectedIndex: 0);
      if (polyLineRes != null) {
        _polylines = polyLineRes;
        _requestData = requestList[0];
      }
    }

    int i = 0;
    for (var element in polylines) {
      _selectedPolyline.add(element);
/*      if(element.polylineId.toString() == "PolylineId${i}"){
        _selectedPolyline.add(element);
      }*/
    }

    BlocProvider.of<NavigationRouteBloc>(event.context)
        .add(NavigationRouteSetPolyLineEvent(polyline: selectedPolyline));

    List<AssignmentModel> _tempList = assignmentList
        .where((element) =>
            element.assignmentStatus == AssignmentStatus.confirm ||
            element.assignmentStatus == AssignmentStatus.startRoute)
        .toList();
    if (_tempList.isNotEmpty) {
      SharedPreferencesUtils.setString(
          key: PreferencesName.cngStationId,
          value: _tempList[0].cngStationId.toString());
      SharedPreferencesUtils.setString(
          key: PreferencesName.routeId, value: _tempList[0].routeId.toString());
    }

    _eventComplete(emit);
  }

  _setRoutes(RequestSetRoutesEvent event, emit) async {
    _isLoader = true;
    _polylines = {};
    _eventComplete(emit);

    var polyLineRes = await RequestHelper.createPolylineWithPoints(
        context: event.context,
        cngStationRouteList: cngStationRouteList,
        selectedIndex: event.index);
    if (polyLineRes != null) {
      _polylines = polyLineRes;
      _routeIndex = event.index;
    }

    for (var element in polylines) {
      if (element.polylineId.toString() == "PolylineId(${event.index})") {
        _selectedPolyline.add(element);
        for (int i = 0; i < element.points.length; i++) {
          double kl = RequestHelper.calculateDistance(currentLat, currentLong,
              element.points[i].latitude, element.points[i].longitude);
          if (kl * 1000 > 60) {
            // out Location
          } else {
            // in Location
          }
        }
      }
    }

    BlocProvider.of<NavigationRouteBloc>(event.context)
        .add(NavigationRouteSetPolyLineEvent(polyline: selectedPolyline));

    _isLoader = false;
    _eventComplete(emit);
  }

  _updateStatus(RequestUpdateStatusEvent event, emit) async {
    List<AssignmentModel> tempList = assignmentList;
    _assignmentList = [];
    _eventComplete(emit);
    tempList[event.index].isSelected == true;
    _assignmentList = tempList;
    _assignmentData = assignmentList[event.index];
    _eventComplete(emit);

    var textFieldValidation = await RequestHelper.textFieldValidation(
        context: event.context,
        uploadPhotoImage: uploadPhotoImage,
        uploadTruckImage: uploadTruckImage,
        uploadSlipImage: uploadSlipImage,
        scmQuantity: scmQuantityController.text.toString(),
        assignmentStatus: assignmentData.assignmentStatus!);
    if (textFieldValidation == false) {
      return;
    }

    _isStartRoute = true;
    _eventComplete(emit);
    String statusId = AssignmentModel.getAssignmentChangeStatusId(
        assignmentStatus: assignmentData.assignmentStatus!);
    var res = await AddAssignmentHelper.updateStatus(
      context: event.context,
      statusId: statusId,
      assignmentId: assignmentData.id.toString(),
      userData: userData,
      uploadPhotoImage: uploadPhotoImage,
      uploadTruckImage: uploadTruckImage,
      uploadSlip: uploadSlipImage,
      scmQuantity: scmQuantityController.text.toString(),
      assignmentData: assignmentData,
      assignmentStatus: AssignmentModel.getAssignmentStatus(status: statusId),
    );
    var assignmentRes = await ViewAssignmentHelper.fetchAssignment(
      context: event.context,
      userData: userData,
    );
    if (assignmentRes != null) {
      _assignmentList = assignmentRes;
    }

    _isStartRoute = false;
    _eventComplete(emit);

    if (assignmentData.assignmentStatus != AssignmentStatus.pending) {
      String? currentPath;
      navigatorKey.currentState?.popUntil((route) {
        currentPath = route.settings.name;
        return true;
      });

      if (currentPath == PopRouteName.completeTask.toString() ||
          currentPath == PopRouteName.startRoute.toString()) {
        Navigator.of(event.context, rootNavigator: true).pop();
      } else if (currentPath == PopRouteName.notification.toString()) {
        Navigator.of(event.context, rootNavigator: true).pop();
        Navigator.of(event.context, rootNavigator: true).pop();
      }
    }

    for (var assignemnt in assignmentList) {
      if (assignemnt.assignmentStatus == AssignmentStatus.confirm ||
          assignemnt.assignmentStatus == AssignmentStatus.startRoute) {
        var routeRes = await RequestHelper.fetchRoute(
            context: event.context,
            userData: userData,
            routeId: assignemnt.routeId);
        if (routeRes != null) {
          _cngStationRouteList = routeRes;
        }
      }
    }

    if (cngStationRouteList.isNotEmpty) {
      var polyLineRes = await RequestHelper.createPolylineWithPoints(
          context: event.context,
          cngStationRouteList: cngStationRouteList,
          selectedIndex: 0);
      if (polyLineRes != null) {
        _polylines = polyLineRes;
        _requestData = requestList[0];
      }
    }

    if (res != null) {
      List<AssignmentModel> _tempList = assignmentList
          .where((element) =>
              element.assignmentStatus == AssignmentStatus.confirm ||
              element.assignmentStatus == AssignmentStatus.startRoute)
          .toList();
      if (_tempList.isNotEmpty) {
        SharedPreferencesUtils.setString(
            key: PreferencesName.cngStationId,
            value: _tempList[0].cngStationId.toString());
        SharedPreferencesUtils.setString(
            key: PreferencesName.routeId,
            value: _tempList[0].routeId.toString());
      }
    }
  }

  _uploadPhoto(RequestUploadPhotoEvent event, emit) async {
    if (await LocationHelper.checkImagePermission(context: event.context) ==
        false) {
      return;
    }
    _photoIndex = event.photoIndex;
    List<CameraDescription> _cameras = await availableCameras();
    if (event.photoIndex == 1) {
/*      Navigator.push(
          event.context,
          MaterialPageRoute(
              builder: (context) => SelfieCameraPage(
                    camera: _cameras[0],
                  )));*/
    } else if (event.photoIndex == 2) {
      if (_cameras.length > 1) {
        for (var camera in _cameras) {
          if (camera.lensDirection == CameraLensDirection.front) {
/*            Navigator.push(
                event.context,
                MaterialPageRoute(
                    builder: (context) => SelfieCameraPage(
                          camera: camera,
                        )));*/
            return;
          }
        }
      } else {
/*        Navigator.push(
            event.context,
            MaterialPageRoute(
                builder: (context) => SelfieCameraPage(
                      camera: _cameras[0],
                    )));*/
        return;
      }
    }
    if (event.photoIndex == 3) {
/*      Navigator.push(
          event.context,
          MaterialPageRoute(
              builder: (context) => SelfieCameraPage(
                    camera: _cameras[0],
                  )));*/
    } else {
      _photoIndex = event.photoIndex;
      uploadPhotoImage = File("");
      uploadTruckImage = File("");
      uploadSlipImage = File("");
      _eventComplete(emit);
    }
  }

  _uploadImage(RequestImagePikerEvent event, emit) async {
    String filePath = event.filePath;
    if (filePath.isNotEmpty) {
      if (photoIndex == 1) {
        uploadTruckImage = File(
          event.filePath,
        );
      } else if (photoIndex == 2) {
        uploadPhotoImage = File(
          event.filePath,
        );
      } else if (photoIndex == 3) {
        uploadSlipImage = File(
          event.filePath,
        );
      }
      _eventComplete(emit);
    }
    Navigator.pop(event.context);
    Navigator.pop(event.context);
  }

  _requestConfirm(RequestConfirmEvent event, emit) async {
    _requestData = RequestModel();
    _eventComplete(emit);
    _requestData = requestList[routeIndex];
    _requestList[routeIndex].status = "1";
    _eventComplete(emit);
  }

  _eventComplete(Emitter<RequestState> emit) {
    emit(FetchRequestDataState(
      isLoader: isLoader,
      requestList: requestList,
      currentLat: currentLat,
      currentLong: currentLong,
      polylines: polylines,
      currentLocationMarker: currentLocationMarker,
      requestData: requestData,
      assignmentList: assignmentList,
      uploadTruckImage: uploadTruckImage,
      uploadPhotoImage: uploadPhotoImage,
      uploadSlipImage: uploadSlipImage,
      isStartRoute: isStartRoute,
      scmQuantityController: scmQuantityController,
    ));
  }
}
