import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatelessWidget {
  final Function onImagePicked;

  const ImagePickerWidget({Key key, this.onImagePicked}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: ()=>getImage(context),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.black26, style: BorderStyle.solid, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Icon(Icons.add),
          ),
        ),
    );
  }

  void getImage(BuildContext context) async {
    showDialog(
      context:context,
      builder: (context){
        return SimpleDialog(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.camera),
              title: Text("Camera"),
              onTap: (){
                Navigator.of(context).pop();
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo),
              title: Text("Gallery"),
              onTap: (){
                Navigator.of(context).pop();
                pickImage(ImageSource.gallery);
              },
            )
          ],
        );
      }
    );

  }
  void pickImage(ImageSource source)async{
    var image = await ImagePicker.pickImage(source: source);
    if (image != null) {
      onImagePicked(image);
    }
  }
  Widget createImage(var file, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
            onTap: () {},
            child: Container(
              child: Icon(
                Icons.clear,
                size: 18.0,
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: Colors.black26,
                      style: BorderStyle.solid,
                      width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(36.0))),
              padding: EdgeInsets.all(8.0),
            ),
          )
        ],
      ),
    );
  }
}
