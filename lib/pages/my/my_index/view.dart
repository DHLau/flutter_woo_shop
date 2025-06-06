import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class MyIndexPage extends GetView<MyIndexController> {
  const MyIndexPage({super.key});

  // 主视图
  Widget _buildView() {
    return const Center(
      child: Text("MyIndexPage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyIndexController>(
      init: MyIndexController(),
      id: "my_index",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("Profile")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
