class ImageFileModel {
  late List<String> files;
  late String folder;

  ImageFileModel({required this.files, required this.folder});

  ImageFileModel.fromJson(Map<String, dynamic> json) {
    files = json['files'].cast<String>();
    folder = json['folderName'];
  }
}
