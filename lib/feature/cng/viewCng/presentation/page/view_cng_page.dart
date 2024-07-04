import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/cng/addCng/presentation/pages/add_cng_page.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/date_range_pop_widget.dart';

class ViewCngPage extends StatefulWidget {
  const ViewCngPage({super.key});

  @override
  State<ViewCngPage> createState() => _ViewCngPageState();
}

class _ViewCngPageState extends State<ViewCngPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: _floatingActionButton(),
      appBar: AppBar(
        title: TextWidget("View Civil Complaint", color: AppColor.white,
          fontSize: AppFont.font_15, fontWeight: FontWeight.w600,),
      ),
    );
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      backgroundColor: AppColor.themeColor,
      onPressed: () async {
        var res = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const AddCngPage()),
        );
        if (res != null && res.toString() == "complete") {
          if (!context.mounted) return;
     /*     BlocProvider.of<ViewEquipmentComplaintBloc>(
              !context.mounted ? context : context)
              .add(ViewEquipmentComplaintPageLoadEvent(
              context: !context.mounted ? context : context));*/
        }
      },
      child: Icon(
        Icons.add,
        color: AppColor.white,
      ),
    );
  }
}
