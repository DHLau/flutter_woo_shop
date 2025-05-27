import 'dart:io';
import 'package:mime/mime.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:http_parser/http_parser.dart'; // 用于解析Content-Type
import 'file_manager_html.dart';

typedef UploadCallback = void Function(String filename);

class FileServer {
  final int port;
  HttpServer? _server;
  final String directory;
  final UploadCallback? onUpload;

  FileServer({this.port = 8080, required this.directory, this.onUpload});

  Future<String?> _getLocalIpAddress() async {
    final info = NetworkInfo();
    return await info.getWifiIP(); // 例如 192.168.1.105
  }

  Future<void> start() async {
    // 启动服务器
    _server = await HttpServer.bind(InternetAddress.anyIPv4, port);
    final localIp = await _getLocalIpAddress();
    print('服务器启动，访问地址: http://localhost:$port');
    if (localIp != null) {
      print('局域网访问地址: http://$localIp:$port');
    } else {
      print('获取局域网IP失败,请检查Wi-Fi连接');
    }

    // 确保目录存在
    final dir = Directory(directory);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
      print('创建存储目录: $directory');
    }

    // 循环监听请求
    await for (HttpRequest request in _server!) {
      try {
        if (request.method == 'GET' && request.uri.path == '/') {
          await _handleIndex(request);
        } else if (request.method == 'POST' && request.uri.path == '/upload') {
          await _handleFileUpload(request);
        } else if (request.method == 'GET' &&
            request.uri.path.startsWith('/files/')) {
          await _handleFileDownload(request);
        } else {
          _notFound(request);
        }
      } catch (e, st) {
        print('请求处理异常: $e\n$st');
        try {
          request.response.statusCode = HttpStatus.internalServerError;
          request.response.write('服务器内部错误');
          await request.response.close();
        } catch (e) {
          // 如果响应已经关闭，捕获异常并忽略
        }
      }
    }
  }

  Future<void> _handleIndex(HttpRequest request) async {
    final files = Directory(directory)
        .listSync()
        .whereType<File>()
        .map((f) => f.uri.pathSegments.last)
        .toList();

    final html = buildFileManagerPage(files);
    request.response
      ..statusCode = HttpStatus.ok
      ..headers.contentType = ContentType.html
      ..write(html);
    await request.response.close();
  }

  Future<void> _handleFileUpload(HttpRequest request) async {
    try {
      final contentTypeHeader = request.headers.contentType;
      if (contentTypeHeader == null ||
          contentTypeHeader.primaryType != 'multipart' ||
          contentTypeHeader.subType != 'form-data' ||
          !contentTypeHeader.parameters.containsKey('boundary')) {
        request.response
          ..statusCode = HttpStatus.badRequest
          ..write('错误的请求类型，需 multipart/form-data');
        await request.response.close();
        return;
      }

      final boundary = contentTypeHeader.parameters['boundary']!;
      final transformer = MimeMultipartTransformer(boundary);
      final parts = transformer.bind(request);

      await for (var part in parts) {
        final contentDisposition = part.headers['content-disposition'];
        if (contentDisposition == null) continue;

        final disposition = HeaderValue.parse(contentDisposition);
        final filename = disposition.parameters['filename'];
        if (filename == null || filename.isEmpty) continue;

        final saveFile = File('$directory/$filename');
        final sink = saveFile.openWrite();
        await part.pipe(sink);
        await sink.close();

        print('上传成功: $filename');
      }

      request.response
        ..statusCode = HttpStatus.ok
        ..write('上传成功');
      await request.response.close();
    } catch (e) {
      print('上传异常: $e');
      request.response
        ..statusCode = HttpStatus.internalServerError
        ..write('上传失败: $e');
      await request.response.close();
    }
  }

  Future<void> _handleFileDownload(HttpRequest request) async {
    final filename = request.uri.pathSegments.last;
    final file = File('$directory/$filename');

    if (await file.exists()) {
      final mimeType = lookupMimeType(filename) ?? 'application/octet-stream';
      request.response.headers.contentType = ContentType.parse(mimeType);
      await request.response.addStream(file.openRead());
      await request.response.close();
    } else {
      _notFound(request);
    }
  }

  void _notFound(HttpRequest request) {
    request.response
      ..statusCode = HttpStatus.notFound
      ..write('404 Not Found')
      ..close();
  }

  Future<void> stop() async {
    await _server?.close(force: true);
  }
}
