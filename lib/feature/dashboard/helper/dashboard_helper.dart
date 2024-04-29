import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:file_picker/file_picker.dart';

class DashboardHelper {

  static Future<dynamic> imagePiker({required BuildContext context}) async {
    try{
      final ImagePicker _picker = ImagePicker();
      final XFile? photo = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 60,
          maxHeight: 1200,
          maxWidth: 950,
          preferredCameraDevice: CameraDevice.rear);
      if(photo != null){
        return File(photo.path);
      } else{
        return null;
      }
    }catch(e){
      return null;
    }
  }

  static Future<dynamic> filePiker({required BuildContext context}) async {
    try{
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'doc'],
      );
      if(result != null){
        List<File> files = result.paths.map((path) => File(path!)).toList();
        return files[0];
      } else{
        return null;
      }
    }catch(e){
      return null;
    }
  }

  void mediaType({required BuildContext context}) {
    showModalBottomSheet(
      context: context, // Also default
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.18,
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextButton(onPressed: () {

              }, child: TextWidget("Camera", fontSize: AppFont.font_16,)),
              const Divider(),
              TextButton(onPressed: () {

              }, child: TextWidget("Gallery",fontSize: AppFont.font_16,)),
            ],
          ),
        );
      },
    );
  }
}