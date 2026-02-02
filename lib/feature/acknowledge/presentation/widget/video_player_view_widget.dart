import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/text_widget.dart';
import 'package:flutter_igl_cng/utils/res/app_color.dart';
import 'package:flutter_igl_cng/utils/res/app_font.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerViewWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerViewWidget({super.key, required this.videoUrl});

  @override
  State<VideoPlayerViewWidget> createState() => _VideoPlayerViewWidgetState();
}

class _VideoPlayerViewWidgetState extends State<VideoPlayerViewWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: TextWidget(
            "Video",
            color: AppColor.white,
            fontSize: AppFont.font_15,
            fontWeight: FontWeight.w600,
          ),
        ),),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
