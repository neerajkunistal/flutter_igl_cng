import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/utils/hive/hive_dataTypes.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class HiveDataBase {

/*  static Box<InsertLiveLocalData>? liveLocationBox;*/


  Future<void> init()  async {
    Directory tempDir = await getApplicationDocumentsDirectory();
    Directory filesDir = Directory(tempDir.path)..createSync(recursive: true);
    Hive.init(filesDir.path);

/*    Hive.registerAdapter(InsertLiveLocalDataAdapter());
    liveLocationBox =  await Hive.openBox<InsertLiveLocalData>(HiveBoxName.liveLocationBoxName);*/
  }
}