import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/request/helper/request_helper.dart';
import 'package:google_maps_polyline/src/point_latlng.dart';

class LcvTruckLiveRouteHelper {
  static Future<dynamic> createPolylineWithPoints(
      {required BuildContext context,
      required String polyline,
      required int selectedIndex}) async {
    try {
      Set<Polyline> polylines = {};
      List<LatLng> polylineCoordinates = [];
      List<MyPointLatLng> pointsList =
          RequestHelper.decodePolyline(polyline).cast<MyPointLatLng>();
      for (var point in pointsList) {
        polylineCoordinates.add(LatLng(point.latitude!, point.longitude!));
        polylines.add(Polyline(
          polylineId: const PolylineId("${9999}"),
          points: polylineCoordinates,
          color: EnvironmentConfig.of(context)!.primaryTheme,
          width: 5,
          consumeTapEvents: true,
          jointType: JointType.mitered,
          startCap: Cap.customCapFromBitmap(
              BitmapDescriptor.defaultMarkerWithHue(40)),
          endCap: Cap.customCapFromBitmap(BitmapDescriptor.defaultMarker),
        ));
      }
      return polylines;
    } catch (e) {
      SnackBarErrorWidget(context).show(message: "Internal Server error");
      return null;
    }
  }
}
