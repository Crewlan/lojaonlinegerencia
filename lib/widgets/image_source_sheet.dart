import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatefulWidget {
  final Function(File) onImageSelected;

  ImageSourceSheet({this.onImageSelected});

  @override
  _ImageSourceSheetState createState() => _ImageSourceSheetState();
}

class _ImageSourceSheetState extends State<ImageSourceSheet> {
  // ignore: unused_field
  File _image;

  final picker = ImagePicker();

  File foto;

  Future getImage(String modo) async {
    final pickedFile = await picker.getImage(
        source: modo == "camera" ? ImageSource.camera : ImageSource.gallery);

    return _image = File(pickedFile.path);
  }

  void imageSelected(File image) async {
    if (image != null) {
      File croppedImage = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0));
      widget.onImageSelected(croppedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        onClosing: () {},
        builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FlatButton(
                    onPressed: () async {
                      foto = await getImage("camera");
                      imageSelected(foto);
                    },
                    child: Text("Câmera")),
                FlatButton(
                    onPressed: () async {
                      foto = await getImage("galeria");
                      imageSelected(foto);
                    },
                    child: Text("Galeria")),
              ],
            ));
  }
}
