import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

class TabBarWidget extends StatelessWidget {

  final TabController? controller;
  final Decoration? decoration;
  final List<Widget> tabs;
  final ValueChanged<int>? onTap;

  const TabBarWidget({super.key,
  required this.tabs,
  this.controller,
  this.decoration,
  this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return  Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        height: 40,
        child: TabBar(
          controller: controller,
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          indicator:  decoration ?? BoxDecoration(
            color: AppColor.themeColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black54,
          tabs:  tabs,
          onTap: onTap,
        ),),
    );
  }
}
