class VideoFileModel {
  VideoFileModel({
    required this.files,
    required this.folderName,
  });
  late final List<Files> files;
  late final String folderName;

  VideoFileModel.fromJson(Map<String, dynamic> json) {
    files = List.from(json['files']).map((e) => Files.fromJson(e)).toList();
    folderName = json['folderName'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['files'] = files.map((e) => e.toJson()).toList();
    data['folderName'] = folderName;
    return data;
  }
}

class Files {
  Files({
    required this.album,
    required this.artist,
    required this.path,
    required this.dateAdded,
    required this.displayName,
    required this.duration,
    required this.size,
  });
  late final String album;
  late final String artist;
  late final String path;
  late final String dateAdded;
  late final String displayName;
  late final String duration;
  late final String size;

  Files.fromJson(Map<String, dynamic> json) {
    album = json['album'] ?? 'No Data';
    artist = json['artist'] ?? 'No Data';
    path = json['path'];
    dateAdded = json['dateAdded'] ?? 'No data';
    displayName = json['displayName'] ?? 'Video';
    duration = json['duration'] ?? 'No Data';
    size = json['size'] ?? 'No data';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['album'] = album;
    data['artist'] = artist;
    data['path'] = path;
    data['dateAdded'] = dateAdded;
    data['displayName'] = displayName;
    data['duration'] = duration;
    data['size'] = size;
    return data;
  }
}
