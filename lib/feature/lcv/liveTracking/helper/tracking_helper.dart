import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

class TrackingHelper {
  static Future<dynamic> fetchLiveTrackingData(
      {required BuildContext context,
      required LoginDataModel userData,
      required String fromDate,
      required String toDate,
      required bool isAllLocation,
      String? driverUserId}) async {
    try {
      String url = APIs.getLocationApi;
      var json = {
        "login_id": userData.userId,
        "location_all": isAllLocation == true ? "1" : "0",
        "driver_id": driverUserId ?? "",
        "from_date": fromDate,
        "to_date": toDate
      };
      var res = await ServerRequest.postData(urlEndPoint: url, body: json);
      if (res != null &&
          res['status'] != null &&
          res['status'] == 200 &&
          res['response'] != null) {
        return trackingListResponse(res['response']);
      } else {
        return null;
      }
    } catch (e) {
      SnackBarErrorWidget(context).show(message: e.toString());
      return null;
    }
  }
}
