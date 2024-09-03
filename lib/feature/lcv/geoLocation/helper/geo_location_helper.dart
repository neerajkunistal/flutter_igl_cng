import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class GeoLocationHelper {
  static Future<dynamic> fetchPlacesList(
      {required BuildContext context, required String keyWord}) async {
    try {
      var url = Uri.parse(
          "${APIs.googlePlaceAPI}input=${keyWord}&key=${AppString.googleApiKey}");
      return await ServerRequest.getGoogleData(url: url);
    } catch (e) {
      SnackBarErrorWidget(context).show(message: e.toString());
      return null;
    }
  }

  static Future<dynamic> fetchPlaceDetails(
      {required BuildContext context,
      required String placeId,
      required String addrees}) async {
    try {
      var url = Uri.parse(
          "${APIs.googlePlaceDetailsAPI}placeid=${placeId}&key=${AppString.googleApiKey}");
      var res = await ServerRequest.getGoogleData(url: url);
      if (res != null) {
        print(res);
        String totalAddress = res['result']['adr_address'];
        var geometry = res['result']['geometry']['location'];
        String streetAddress = "";
        String extendedAddress = "";
        String locality = "";
        String region = "";
        String postalCode = "";
        String countryName = "";
        var lat = geometry['lat'];
        var long = geometry['lng'];
        totalAddress.split("\</span\>").forEach((element3) {
          if (element3.length > 3) {
            if (element3.contains("street-address")) {
              streetAddress = element3.split(">").last;
            }
            if (element3.contains("extended-address")) {
              extendedAddress = element3.split(">").last;
            }
            if (element3.contains("locality")) {
              locality = element3.split(">").last;
            }
            if (element3.contains("region")) {
              region = element3.split(">").last;
            }
            if (element3.contains("postal-code")) {
              postalCode = element3.split(">").last;
            }
            if (element3.contains("country-name")) {
              countryName = element3.split(">").last;
            }
          }
        });
        Map<String, dynamic> location = {
          "city": locality,
          "state": region,
          "zipcode": postalCode,
          "country": countryName,
          "address": addrees,
          "lat": lat,
          "lng": long
        };
        return location;
      } else {
        return res;
      }
    } catch (e) {
      SnackBarErrorWidget(context).show(message: e.toString());
      return null;
    }
  }

  static Future<dynamic> fetchLatLongLocationData(
      {required BuildContext context,
      required double lat,
      required double long}) async {
    var url = Uri.parse(
        "${APIs.googleLatLongAPI}latlng=${lat},${long}&key=${AppString.googleApiKey}");
    var res = await ServerRequest.getGoogleData(url: url);
    if (res != null) {
      if (res['results'] != null) {
        String address = res['results'][0]['formatted_address'];
        String placeID = res['results'][0]['place_id'];
        return await fetchPlaceDetails(
            context: context, placeId: placeID, addrees: address);
      } else {
        return res;
      }
    }
  }

  static Future<Position> getGeoLocationPosition() async {
    Map<Permission, PermissionStatus> status =
        await [Permission.location].request();
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
