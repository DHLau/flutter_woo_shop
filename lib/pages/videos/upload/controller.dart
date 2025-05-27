import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../file_server/file_server.dart';

class UploadController extends GetxController {
  UploadController();

  late FileServer _fileServer;

  final List<File> uploadedFiles = [];

  @override
  void onReady() async {
    super.onReady();
    final appDocDir = await getApplicationDocumentsDirectory();

    // ① 初始化已存在的文件
    final existingFiles =
        Directory(appDocDir.path).listSync().whereType<File>().toList();

    uploadedFiles.addAll(existingFiles);
    update(["upload"]);

    _fileServer = FileServer(
      port: 8080,
      directory: appDocDir.path,
      onUpload: (filename) {
        final file = File('${appDocDir.path}/$filename');
        uploadedFiles.add(file);
        update(["upload"]);
      },
    );

    await _fileServer.start();
  }

  @override
  void onClose() {
    _fileServer.stop();
    super.onClose();
  }
}
