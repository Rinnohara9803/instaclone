import 'dart:io';
import 'package:instaclone/presentation/pages/UploadPost/widgets/image_show_widget.dart';
import 'package:flutter/material.dart';
import '../../../models/image_file_model.dart';

class SelectProfilePicture extends StatefulWidget {
  final ImageFileModel selectedModel;
  final String selectedImage;
  final Function setImage;
  const SelectProfilePicture({
    super.key,
    required this.selectedModel,
    required this.selectedImage,
    required this.setImage,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SelectProfilePictureState createState() => _SelectProfilePictureState();
}

class _SelectProfilePictureState extends State<SelectProfilePicture>
    with SingleTickerProviderStateMixin {
  final TransformationController _transformationController =
      TransformationController();
  late AnimationController _animationController;

  bool showGridPaper = false;
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          Stack(
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: double.infinity,
                  child: GestureDetector(
                    onDoubleTap: () {
                      _toggleZoom();
                    },
                    child: InteractiveViewer(
                      transformationController: _transformationController,
                      onInteractionStart: (_) {
                        setState(() {
                          showGridPaper = true;
                        });
                      },
                      onInteractionEnd: (_) {
                        setState(() {
                          showGridPaper = false;
                        });
                      },
                      boundaryMargin: EdgeInsets.all(
                        showGridPaper ? 100 : 0,
                      ),
                      minScale: 0.1,
                      maxScale: 2.0,
                      child: GridPaper(
                        color:
                            showGridPaper ? Colors.black : Colors.transparent,
                        divisions: 1,
                        interval: 1200,
                        subdivisions: 9,
                        child: Image.file(
                          File(widget.selectedImage),
                          height: MediaQuery.of(context).size.height * 0.45,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )),
            ],
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemBuilder: (_, i) {
                var file = widget.selectedModel.files[i];
                bool isSelected = file == widget.selectedImage;

                return ImageShowWidget(
                  file: file,
                  isSelected: isSelected,
                  onTap: widget.setImage,
                );
              },
              itemCount: widget.selectedModel.files.length,
            ),
          )
        ],
      ),
    );
  }

  void _toggleZoom() {
    if (_transformationController.value.isIdentity()) {
      _transformationController.value = Matrix4.identity()..scale(2.0);
    } else {
      _transformationController.value = Matrix4.identity();
    }
  }
}
