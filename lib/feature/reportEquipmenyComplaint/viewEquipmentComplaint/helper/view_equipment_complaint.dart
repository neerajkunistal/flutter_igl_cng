import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

class ViewEquipmentComplaintHelper {

  static Future<dynamic> fetchReviewAndSelfComplaint() async {

    try{
       String url =  APIs.getReviewSelfComplaintApi;
       var res =  await ServerRequest.getData(urlEndPoint: url);
       if(res != null && res['status'] != null
           && res['status'] == true
           && res['data'] != null) {
         return reviewComplaintListResponse(res['data']);
       }
       return null;
    }catch(e){
      return null;
    }
  }
}
