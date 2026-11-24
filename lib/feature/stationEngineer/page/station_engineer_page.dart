import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/viewEquipmentComplaint/presentaion/page/view_equipment_complaint_page.dart';

class StationEngineerPage extends StatefulWidget {
  const StationEngineerPage({super.key});

  @override
  State<StationEngineerPage> createState() => _StationEngineerPageState();
}

class _StationEngineerPageState extends State<StationEngineerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
          "Station Engineer",
          color: AppColor.white,
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.white),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AcknowledgePage(equipmentComplaintType: EquipmentComplaintType.normal)),
                      );
                    },
                    icon: Icon(
                      Icons.report_gmailerrorred,
                      color: AppColor.themeColor,
                    ),
                    label: const TextWidget("Ack Complaint"),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.white),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ViewEquipmentComplaintPage(equipmentComplaintType: EquipmentComplaintType.normal)),
                      );
                    },
                    icon: Icon(
                      Icons.report_gmailerrorred,
                      color: AppColor.themeColor,
                    ),
                    label: const TextWidget("Review Complaint"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
