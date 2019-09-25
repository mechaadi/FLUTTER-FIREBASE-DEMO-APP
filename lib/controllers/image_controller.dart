import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageController{

  static Future<Uint8List> compressImage(File file) async {
    try{
      File compressedFile = await FlutterNativeImage.compressImage(file.path,
          quality: 75, percentage: 50);
      print("Size ${compressedFile.statSync().size}");
      return compressedFile.readAsBytesSync();
    }
    catch(e){
      print("Excpetion $e");
      return null;
    }
  }
  static Future<List<String>> addFiles(imageFiles) async {
    List<String> images = [];
    for (var image in imageFiles) {
      String path = await storeImage(image);
      images.add(path);
    }
    return images;
  }

  static Future<String> storeImage(File file,{bool compress=true}) async {
    try {
      Uint8List data ;
      if(compress){
        data=await compressImage(file);
      }
      else{
        data=file.readAsBytesSync();
      }
      StorageReference reference =
      FirebaseStorage.instance.ref().child(DateTime.now().toString());
      StorageUploadTask uploadTask = reference.putData(data);
      StorageTaskSnapshot snapshot = await uploadTask.onComplete;

      String imagePath =
          "https://firebasestorage.googleapis.com/v0/b/a7atestdatabase.appspot.com/o/" +
              snapshot.storageMetadata.path +
              "?alt=media";
      return imagePath;
    } catch (e) {
      return null;
    }
  }

}