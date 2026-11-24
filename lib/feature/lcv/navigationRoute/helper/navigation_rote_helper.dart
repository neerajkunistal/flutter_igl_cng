import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NavigationRouteHelper {
  static Future<dynamic> createRadiusPath(
      {required Set<Polyline> polyline}) async {
    try {
      double _long = 0.0;
      Set<Polyline> polylines = {};
      for (var polylineData in polyline) {
        List<LatLng> polylineCoordinates = [];
        for (int i = 0; i < polylineData.points.length; i++) {
          if (i == 0) {
            polylineCoordinates.add(LatLng(polylineData.points[i].latitude,
                polylineData.points[i].longitude + 00.00020));
          } else {
            if (_long < polylineData.points[i].longitude) {
              polylineCoordinates.add(LatLng(
                  polylineData.points[i].latitude + 00.00020,
                  polylineData.points[i].longitude + 00.00020));
            } else {
              polylineCoordinates.add(LatLng(
                  polylineData.points[i].latitude - 00.00020,
                  polylineData.points[i].longitude + 00.00020));
            }
          }
          _long = polylineData.points[i].longitude;
        }

        polylines.add(Polyline(
          polylineId: const PolylineId("6555555"),
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

      // List<LatLng> polylineCoordinates = [];
      // polylineCoordinates.add(LatLng(28.61656, 77.37365+00.00020));
      // polylineCoordinates.add(LatLng(28.61-00.00020, 77.37305+00.00020));
      // polylines.add(Polyline(
      //   polylineId: const PolylineId("6555555"),
      //   points: polylineCoordinates,
      //   color: Colors.red,
      //   width: 5,
      //   consumeTapEvents: true,
      //   jointType: JointType.mitered,
      //   onTap: () {
      //     print("sdsdsdsdsdsdsdsdsdsd");
      //   },
      // ));

/*       polylineCoordinates = [];
       polylineCoordinates.add(LatLng(28.61-00.00020, 77.37305+00.00020));
       polylineCoordinates.add(LatLng(28.61113-00.00020, 77.35545+00.00020));

       polylines.add(Polyline(
         polylineId: const PolylineId("6555555"),
         points: polylineCoordinates,
         color: Colors.red,
         width: 5,
         consumeTapEvents: true,
         jointType: JointType.mitered,
         onTap: () {
           print("sdsdsdsdsdsdsdsdsdsd");
         },
       ));*/

      // polylineCoordinates = [];
      // polylineCoordinates.add(LatLng(28.61113-00.00020, 77.35545+00.00020));
      // polylineCoordinates.add(LatLng( 28.60849-00.00020, 77.35013+00.00020));
      //
      // polylines.add(Polyline(
      //   polylineId: const PolylineId("6555555"),
      //   points: polylineCoordinates,
      //   color: Colors.red,
      //   width: 5,
      //   consumeTapEvents: true,
      //   jointType: JointType.mitered,
      //   onTap: () {
      //     print("sdsdsdsdsdsdsdsdsdsd");
      //   },
      // ));

/*       polylineCoordinates = [];
       polylineCoordinates.add(LatLng(28.60849-00.00020, 77.35013+00.00020));
       polylineCoordinates.add(LatLng(28.60027+00.00020, 77.35168+00.00020));

       polylines.add(Polyline(
         polylineId: const PolylineId("6555555"),
         points: polylineCoordinates,
         color: Colors.red,
         width: 5,
         consumeTapEvents: true,
         jointType: JointType.mitered,
         onTap: () {
           print("sdsdsdsdsdsdsdsdsdsd");
         },
       ));*/

      // polylineCoordinates = [];
      // polylineCoordinates.add(LatLng(28.60027+00.00020, 77.35168+00.00020));
      // polylineCoordinates.add(LatLng(28.60155+00.00020, 77.36137+00.00020));
      //
      // polylines.add(Polyline(
      //   polylineId: const PolylineId("6555555"),
      //   points: polylineCoordinates,
      //   color: Colors.red,
      //   width: 5,
      //   consumeTapEvents: true,
      //   jointType: JointType.mitered,
      //   onTap: () {
      //     print("sdsdsdsdsdsdsdsdsdsd");
      //   },
      // ));

/*       polylineCoordinates = [];
       polylineCoordinates.add(LatLng(28.59861+00.00020, 77.36558+00.00020));
       polylineCoordinates.add(LatLng(28.60125+00.00020, 77.36944+00.00020));

       polylines.add(Polyline(
         polylineId: const PolylineId("6555555"),
         points: polylineCoordinates,
         color: Colors.red,
         width: 5,
         consumeTapEvents: true,
         jointType: JointType.mitered,
         onTap: () {
           print("sdsdsdsdsdsdsdsdsdsd");
         },
       ));*/

      // polylineCoordinates = [];
      // polylineCoordinates.add(LatLng(28.6011+00.00020, 77.3727+00.00020));
      // polylineCoordinates.add(LatLng(28.59507+00.00020, 77.3727+00.00020));
      //
      // polylines.add(Polyline(
      //   polylineId: const PolylineId("6555555"),
      //   points: polylineCoordinates,
      //   color: Colors.red,
      //   width: 5,
      //   consumeTapEvents: true,
      //   jointType: JointType.mitered,
      //   onTap: () {
      //     print("sdsdsdsdsdsdsdsdsdsd");
      //   },
      // ));

/*       polylineCoordinates = [];
       polylineCoordinates.add(LatLng(28.6011-00.00020, 77.3727-00.00020));
       polylineCoordinates.add(LatLng(28.59507+00.00020, 77.3727-00.00020));

       polylines.add(Polyline(
         polylineId: const PolylineId("6555555"),
         points: polylineCoordinates,
         color: Colors.red,
         width: 5,
         consumeTapEvents: true,
         jointType: JointType.mitered,
         onTap: () {
           print("sdsdsdsdsdsdsdsdsdsd");
         },
       ));*/

      return polylines;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> createRadiusPath1(
      {required Set<Polyline> polyline}) async {
    try {
      double _long = 0.0;
      Set<Polyline> polylines = {};
      for (var polylineData in polyline) {
        List<LatLng> polylineCoordinates = [];
        for (int i = 0; i < polylineData.points.length; i++) {
          if (i == 0) {
            polylineCoordinates.add(LatLng(polylineData.points[i].latitude,
                polylineData.points[i].longitude - 00.00020));
          } else {
            if (_long < polylineData.points[i].longitude) {
              polylineCoordinates.add(LatLng(
                  polylineData.points[i].latitude - 00.00020,
                  polylineData.points[i].longitude - 00.00020));
            } else {
              polylineCoordinates.add(LatLng(
                  polylineData.points[i].latitude + 00.00020,
                  polylineData.points[i].longitude - 00.00020));
            }
          }
          _long = polylineData.points[i].longitude;
        }

        polylines.add(Polyline(
          polylineId: const PolylineId("3434333333"),
          points: polylineCoordinates,
          color: Colors.red,
          width: 5,
          consumeTapEvents: true,
          jointType: JointType.mitered,
        ));
      }
      return polylines;
    } catch (e) {
      return null;
    }
  }
}
