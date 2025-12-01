String buildFileManagerPage(List<String> files) {
  final buffer = StringBuffer();

  buffer.write('''
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8" />
  <title>文件管理</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    h1 { color: #333; }
    ul { list-style: none; padding: 0; }
    li { margin-bottom: 8px; }
    .upload-area { margin-top: 20px; }
  </style>
</head>
<body>
  <h1>文件列表</h1>
  <ul>
''');

  for (var file in files) {
    buffer.write('<li><a href="/files/$file" target="_blank">$file</a></li>');
  }

  buffer.write('''
  </ul>

  <div class="upload-area">
    <h2>上传文件</h2>
    <form method="POST" enctype="multipart/form-data" action="/upload">
      <input type="file" name="file" />
      <button type="submit">上传</button>
    </form>
  </div>
</body>
</html>
''');

  return buffer.toString();
}
