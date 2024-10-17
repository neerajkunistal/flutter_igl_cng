import 'dart:math' as math show pow;
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/request/domain/bloc/request_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/request/domain/model/cng_station_route_model.dart';
import 'package:flutter_igl_cng/feature/lcv/request/domain/model/request_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_polyline/google_maps_polyline.dart';
import 'package:google_maps_polyline/src/point_latlng.dart';
import 'package:google_maps_polyline/src/utils/my_request_enums.dart';
import 'package:google_maps_polyline/src/utils/result_polyline.dart';

class RequestHelper {
  static Future<dynamic> textFieldValidation(
      {required BuildContext context,
      required File uploadPhotoImage,
      required File uploadTruckImage,
      required File uploadSlipImage,
      required String scmQuantity,
      required AssignmentStatus assignmentStatus}) async {
    try {
      if (assignmentStatus != AssignmentStatus.pending) {
        if (scmQuantity.isEmpty &&
            assignmentStatus != AssignmentStatus.startRoute) {
          SnackBarErrorWidget(context)
              .show(message: "Please enter scm quantity");
          return false;
        } else if (uploadTruckImage.path.isEmpty) {
          SnackBarErrorWidget(context)
              .show(message: "Please upload truck photo");
          return false;
        } else if (uploadPhotoImage.path.isEmpty) {
          SnackBarErrorWidget(context)
              .show(message: "Please upload self photo");
          return false;
        } else if (assignmentStatus == AssignmentStatus.confirm &&
            uploadSlipImage.path.isEmpty) {
          SnackBarErrorWidget(context)
              .show(message: "Please upload slip photo");
          return false;
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<dynamic> fetchRoute(
      {required BuildContext context,
      required LoginDataModel userData,
      String? sourceStationId,
      String? destinationStationId,
      String? routeId}) async {
    try {
      String url = APIs.getRouteApi;
      var json = {
        "login_id": userData.userId.toString(),
        "source_station_id": sourceStationId ?? "",
        "destination_station_id": destinationStationId ?? "",
        "route_id": routeId ?? ""
      };
      var res = await ServerRequest.postData(urlEndPoint: url, body: json);
      if (res != null) {
        if (res["status"] != null &&
            res['status'] == 200 &&
            res['response'] != null) {
          return cngStationRouteListResponse(res['response']);
        } else {
          SnackBarErrorWidget(context).show(message: res['error'].toString());
          return null;
        }
      } else {
        SnackBarErrorWidget(context)
            .show(message: "Internal Server Error ${APIs.getDriverApi}");
        return null;
      }
    } catch (e) {
      SnackBarErrorWidget(context).show(message: "Internal server error");
      return null;
    }
  }

  static Future<dynamic> fetchRequestData(
      {required BuildContext context}) async {
    try {
      List<RequestModel> requestList = [];
      List<RoutesModel> routesList = [];

      routesList.add(RoutesModel(
        isSelectedRoute: true,
        id: "567",
        polyLines:
            "gdpmDazfwM?d@yD?gGUeEEwKQoLQyKU}LUoMQj@cQj@}RlAa_@@q@_GSiG]R{EX@",
      ));

/*      routesList.add(RoutesModel(
          isSelectedRoute: false,
          id: "6887",
          polyLines: "ekpmDkwfwMsAAsACe@H}@D{@AmJOg@?EDMLK\\WzH@lBHx@R|@j@jBbAlBnF`IjJbN|CtEzA|B|H`L`CnD|G|JfErGpNfT~C|EVDTPrAjBhGbJt@bARb@LEZK~@u@fGsFtAsARCFBtAoApBgBnB{B|@o@\\M@?HBBJILOLSXCHy@j@_BtAgCrB_CrB{EfEuChCyJjJ}MhMQJgDxCiDzCeL~KhCpDhCtDdD~E|A|Bt@bAZr@f@x@d@t@|AzBlBlCpAzAp@dAhAtBjC~Df@z@tAnBpHzKbBdCQVcBiCyBaDwD{FwAmBkBmC"
      ));*/

      requestList.add(RequestModel(
          stationName: "Unistal Pvt, Ltd",
          stationLocation:
              " C-20, C Block, Sector 65, Noida, Uttar Pradesh 201301",
          dateTime: "02Hr:23 Mints: 00",
          status: "0",
          distance: "12 Km",
          lat: 28.607235,
          long: 77.379623,
          isSelected: false,
          routesList: routesList));
      return requestList;
    } catch (e) {
      SnackBarErrorWidget(context).show(message: "Internal server error");
      return null;
    }
  }

  static Future<dynamic> getPolyline(
      {required BuildContext context,
      required MyPointLatLng origin,
      required MyPointLatLng destination}) async {
    try {
      Set<Polyline> polylines = {};
      GoogleMapsPolyline polylinePoints = GoogleMapsPolyline();
      String googleApiKey = AppString.googleApiKey;
      ResultPolyline result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey,
        origin,
        destination,
        travelMode: MyTravelMode.driving,
        optimizeWaypoints: true,
        avoidFerries: false,
      );
      if (result.status.toString().toLowerCase() == "ok" &&
          result.points.isNotEmpty) {
        List<LatLng> polylineCoordinates = [];
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude!, point.longitude!));
        }
        polylines.add(Polyline(
          polylineId: const PolylineId("7788878"),
          points: polylineCoordinates,
          color: Colors.red,
          width: 5,
          consumeTapEvents: true,
          jointType: JointType.mitered,
          onTap: () {
            print("sdsdsdsdsdsdsdsdsdsd");
          },
        ));
      }
      return polylines;
    } catch (e) {
      SnackBarErrorWidget(context).show(message: "Internal Server error");
      return null;
    }
  }

  static Future<dynamic> createPolylineWithPoints(
      {required BuildContext context,
      required List<CngStationRouteModel> cngStationRouteList,
      required int selectedIndex}) async {
    try {
      Set<Polyline> polylines = {};
      for (int i = 0; i < cngStationRouteList.length; i++) {
        if (cngStationRouteList[i].encodeRoute.toString().isNotEmpty) {
          List<LatLng> polylineCoordinates = [];
          List<MyPointLatLng> pointsList =
              decodePolyline(cngStationRouteList[i].encodeRoute.toString())
                  .cast<MyPointLatLng>();
          for (var point in pointsList) {
            polylineCoordinates.add(LatLng(point.latitude!, point.longitude!));
          }

/*            final icon = await BitmapDescriptor.fromAssetImage(
                ImageConfiguration(
                    size: Size(3, 3), devicePixelRatio: 10),AppIcon.mapIcon);*/
          polylines.add(Polyline(
              polylineId: PolylineId("${i}"),
              points: polylineCoordinates,
              color: i == selectedIndex ? Colors.blue : Colors.black26,
              width: 5,
              consumeTapEvents: true,
              jointType: JointType.mitered,
              // startCap: Cap.customCapFromBitmap(BitmapDescriptor.defaultMarker),
              endCap: Cap.customCapFromBitmap(
                  BitmapDescriptor.defaultMarkerWithHue(40)),
              onTap: () {
                BlocProvider.of<RequestBloc>(context)
                    .add(RequestSetRoutesEvent(index: i, context: context));
              }));
        }
      }
      return polylines;
    } catch (e) {
      SnackBarErrorWidget(context).show(message: "Internal Server error");
      return null;
    }
  }

  static List<MyPointLatLng> decodePolyline(String polyline,
      {int accuracyExponent = 5}) {
    final accuracyMultiplier = math.pow(10, accuracyExponent);

    List<MyPointLatLng> coordinates = [];

    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < polyline.length) {
      int char;
      int shift = 0;
      int result = 0;

      /// Method for getting **only** `1` coorditane `latitude` or `longitude` at a time
      int getCoordinate() {
        /// Iterating while value is grater or equal of `32-bits` size
        do {
          /// Substract `63` from `codeUnit`.
          char = polyline.codeUnitAt(index++) - 63;

          /// `AND` each `char` with `0x1f` to get 5-bit chunks.
          /// Then `OR` each `char` with `result`.
          /// Then left-shift for `shift` bits
          result |= (char & 0x1f) << shift;
          shift += 5;
        } while (char >= 0x20);

        /// Inversion of both:
        ///
        ///  * Left-shift the `value` for one bit
        ///  * Inversion `value` if it is negative
        final value = result >> 1;
        final coordinateChange =
            (result & 1) != 0 ? (~BigInt.from(value)).toInt() : value;

        /// It is needed to clear `shift` and `result` for next coordinate.
        shift = result = 0;

        return coordinateChange;
      }

      lat += getCoordinate();
      lng += getCoordinate();

      /// coordinates.add([lat / accuracyMultiplier, lng / accuracyMultiplier]);
      coordinates.add(
          MyPointLatLng(lat / accuracyMultiplier, lng / accuracyMultiplier));
    }

    return coordinates;
  }

  static Future<Uint8List?> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        ?.buffer
        .asUint8List();
  }

  static double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
