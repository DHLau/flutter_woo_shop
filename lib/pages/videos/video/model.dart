class VideoModel {
  final String id;
  final String name;
  final String path;
  final DateTime addedTime;
  final int size;

  VideoModel({
    required this.id,
    required this.name,
    required this.path,
    required this.addedTime,
    required this.size,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'path': path,
        'addedTime': addedTime.toIso8601String(),
        'size': size,
      };

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
        id: json['id'],
        name: json['name'],
        path: json['path'],
        addedTime: DateTime.parse(json['addedTime']),
        size: json['size'],
      );
}
