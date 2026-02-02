import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/text_widget.dart';
import 'package:flutter_igl_cng/utils/res/app_color.dart';
import 'package:flutter_igl_cng/utils/res/app_font.dart';

class FullImageViewWidget extends StatelessWidget {
  final String imageUrl;

  const FullImageViewWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar:AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: TextWidget(
            "Image",
            color: AppColor.white,
            fontSize: AppFont.font_15,
            fontWeight: FontWeight.w600,
          ),
        ),),
      body: Center(
        child: InteractiveViewer(
          minScale: 1,
          maxScale: 4,
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}
