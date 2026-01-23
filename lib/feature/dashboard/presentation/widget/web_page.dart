import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/dotted_line_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget {
  final String url;
  final String name;

  const WebPage({super.key, required this.url, required this.name});

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    print(widget.url);

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: appBackGround(
        context: context,
        child: Column(
          children: [
          //  _appBar(),
            const DottedDividerLine(color: Colors.white),

            /// IMPORTANT: WebView must be inside Expanded
            Expanded(
              child: WebViewWidget(controller: controller),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Align(
        alignment: Alignment.centerLeft,
        child: TextWidget(
          widget.name,
          color: AppColor.white,
          fontSize: AppFont.font_15,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        Image.asset(
          AppConfig.instanceInit()!.client == Client.iglcng
              ? AppIcon.appLogoIgl
              : AppConfig.instanceInit()!.client == Client.pbgplCNG
              ? AppIcon.appLogoPurvaBharti
              : AppConfig.instanceInit()!.client == Client.mahanagar
              ? AppIcon.appLogoMGL
              : AppIcon.appLogoIgl,
          height: MediaQuery.of(context).size.width * 0.13,
          width: MediaQuery.of(context).size.width * 0.13,
        ),
      ],
    );
  }
}