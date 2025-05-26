import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class VideoPage extends GetView<VideoController> {
  const VideoPage({super.key});

  // 主视图
  Widget _buildView() {
    return const Center(
      child: Text("VideoPage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoController>(
      init: VideoController(),
      id: "video",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("video")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
