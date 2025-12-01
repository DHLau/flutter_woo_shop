import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class UploadPage extends GetView<UploadController> {
  const UploadPage({super.key});

  // 主视图
  Widget _buildView() {
    return controller.uploadedFiles.isEmpty
        ? const Center(child: Text("暂时没有上传文件"))
        : ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.uploadedFiles.length,
            itemBuilder: (context, index) {
              final file = controller.uploadedFiles[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.insert_drive_file),
                  title: Text(file.path.split("/").last),
                  subtitle: Text(file.path),
                  onTap: () {
                    // 未来可以预览或打开
                  },
                ),
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UploadController>(
      init: UploadController(),
      id: "upload",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("upload")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
