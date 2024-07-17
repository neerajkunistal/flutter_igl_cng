import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

class HeaderWidget extends StatelessWidget {
  final String title;
  const HeaderWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return _header(context: context);
  }
  Widget _header({required BuildContext context}) {
    return Column(
      children: [
        Platform.isIOS ? SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ) : const SizedBox.shrink(),
        Row(children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.02,
          ),
          Expanded(
            child: TextWidget(
              title,
              color: AppColor.white,
              fontSize: AppFont.font_15,
              fontWeight: FontWeight.w600,
            ),
          ),
          Image.asset(
            AppConfig.instanceInit()!.client == Client.iglcng
                ? AppIcon.appLogoIgl
                : AppIcon.appLogoIgl,
            height: MediaQuery.of(context).size.width * 0.13,
            width: MediaQuery.of(context).size.width * 0.13,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.02,
          ),
        ]),
      ],
    );
  }

}
