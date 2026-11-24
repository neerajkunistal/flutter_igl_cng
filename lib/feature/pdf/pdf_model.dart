import 'package:flutter/services.dart';

class PdfModel {

  String? complaintId;
  String? stationName;
  String? equipmentId;
  String? complaintData;
  String? description;
  String? complaintStatus;
  Uint8List? image;

  PdfModel({
   this.description,
   this.stationName,
   this.complaintStatus,
   this.complaintData,
   this.complaintId,
   this.equipmentId,
   this.image,
});

}