import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  ImageInput(this.pickImage);

  final void Function(File image) pickImage;

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File chosenImage;
  void _setImage() async {
    final picker = ImagePicker();
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Pick image Input'),
              content:
                  Text('Do you want to choose form galler or take a picture?'),
              actions: [
                FlatButton(
                  child: Text('Take image'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    final pickedImage = await picker.getImage(
                      source: ImageSource.camera,
                      imageQuality: 50,
                      maxWidth: 150,
                    );
                    setState(() {
                      chosenImage = File(pickedImage.path);
                    });
                    widget.pickImage(chosenImage);
                  },
                ),
                FlatButton(
                  child: Text('Chose from gallery'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    final pickedImage = await picker.getImage(
                      source: ImageSource.gallery,
                      imageQuality: 50,
                      maxWidth: 150,
                    );
                    setState(() {
                      chosenImage = File(pickedImage.path);
                    });
                    widget.pickImage(chosenImage);
                  },
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundImage: chosenImage != null ? FileImage(chosenImage) : null,
        ),
        FlatButton.icon(
          onPressed: _setImage,
          icon: Icon(Icons.image),
          label: Text('Add Image'),
          color: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}
