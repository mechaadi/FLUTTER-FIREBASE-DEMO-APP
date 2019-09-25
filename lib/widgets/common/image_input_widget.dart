import 'dart:io';

import 'package:social_test_app/widgets/common/image_picker_widget.dart';
import 'package:flutter/material.dart';


class ImageInputWidget extends StatefulWidget {
  final Function(List<File>)onImagesAdded;
  final int max;
  const ImageInputWidget({Key key,@required this.onImagesAdded, this.max}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ImageInputWidgetState();
}

class _ImageInputWidgetState extends State<ImageInputWidget> {
  List<Widget> images;
  List<File> files;
  @override
  void initState() {
    super.initState();
    images = [];
      files = [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            "Add image ",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 8.0),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: getImages(),
          ),
        ),
      ],
    );
  }
List<Widget> getImages() {
    List<Widget> widgets = [];
    int max=widget.max??10;
    for (int i = 0; i < files.length; i++) {
      widgets.add(createImage(files[i], i));
    }
    if(files.length<max)
    widgets.add(ImagePickerWidget(
      onImagePicked: (file) {
        setState(() {
          files.add(file);
        });
        widget.onImagesAdded(files);
      },
    ));
    return widgets;
  }
  Widget createImage(var file, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              child: Image.file(
                file,
                width: 78.0,
                height: 78.0,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                this.files.removeAt(index);
                widget.onImagesAdded(files);
              });
            },
            child: Container(
              child: Icon(
                Icons.clear,
                size: 18.0,
                color: Colors.white,
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: Colors.white,
                      style: BorderStyle.solid,
                      width: 5.0),
                  borderRadius: BorderRadius.all(Radius.circular(36.0))),
              padding: EdgeInsets.all(8.0),
            ),
          )
        ],
      ),
    );
  }
}
