import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:network_info_plus/network_info_plus.dart';

class UploadController extends GetxController {
  UploadController();

  HttpServer? _server;
  final List<File> uploadedFiles = []; // ✅ 用于记录上传的文件

  _initData() {
    update(["upload"]);
  }

  void onTap() {}

  @override
  void onReady() {
    super.onReady();
    _initData();
    _startHttpServer();
  }

  Future<String?> _getLocalIpAddress() async {
    final info = NetworkInfo();
    return await info.getWifiIP(); // 例如 192.168.1.105
  }

  Future<void> _startHttpServer() async {
    final router = Router();

    // 上传表单页面
    router.get('/', (shelf.Request request) {
      return shelf.Response.ok(
        '''
        <html>
          <head><meta charset="utf-8"></head>
          <body>
            <h3>文件上传</h3>
            <form method="POST" action="/upload" enctype="multipart/form-data">
              <input type="file" name="file" />
              <input type="submit" value="上传" />
            </form>
          </body>
        </html>
        ''',
        headers: {'Content-Type': 'text/html'},
      );
    });

    // 处理上传逻辑
    router.post('/upload', (shelf.Request request) async {
      final contentType = request.headers['Content-Type'];
      if (contentType == null || !contentType.contains('multipart/form-data')) {
        return shelf.Response(400, body: 'Content-Type 错误');
      }

      final boundary = contentType.split('boundary=')[1];
      final transformer = MimeMultipartTransformer(boundary);
      final bodyBytes = await request.read().expand((e) => e).toList();
      final parts =
          await transformer.bind(Stream.fromIterable([bodyBytes])).toList();

      for (var part in parts) {
        final contentDisp = part.headers['content-disposition'];
        final match = RegExp(r'filename="(.+)"').firstMatch(contentDisp ?? '');
        if (match != null) {
          final fileName = match.group(1)!;
          final bytes =
              await part.fold<List<int>>([], (prev, el) => prev..addAll(el));

          final dir = await getApplicationDocumentsDirectory();
          final file = File('${dir.path}/$fileName');
          await file.writeAsBytes(bytes);

          print('接收到文件: ${file.path}');

          uploadedFiles.add(file); // ✅ 添加到列表
          update(["upload"]); // ✅ 触发页面更新
        }
      }

      return shelf.Response.ok('上传成功');
    });

    try {
      _server = await shelf_io.serve(router, InternetAddress.anyIPv4, 8080);

      final localIp = await _getLocalIpAddress();
      if (localIp != null) {
        print('📡 上传页面地址：http://$localIp:8080');
      } else {
        print('❗️获取本地 IP 失败，请确认连接 Wi-Fi');
      }
    } catch (e) {
      print("服务启动失败: $e");
    }
  }

  List<File> get uploadedFileList => uploadedFiles.reversed.toList();

  @override
  void onClose() {
    _server?.close(force: true);
    super.onClose();
  }
}
