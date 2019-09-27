import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:social_test_app/controllers/user_controller.dart';
import 'package:social_test_app/models/user.dart';
import 'package:path/path.dart' as Path;  


class OpenChatRoom extends StatefulWidget {
  @override
  _OpenChatRoomState createState() => _OpenChatRoomState();
}

class _OpenChatRoomState extends State<OpenChatRoom> {

  ScrollController _controller = ScrollController();

 
  var time ;
  var id = "";
  var name = "";
  var _image;
  String  _uploadedFileURL = "";

  void getUser() async{
    user = await UserController.getCurrentUser();
    setState(() {
      id = user.id;
      name = user.name;
    });
  }
  

 bool _keyboardIsVisible() {
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }
  @override
  void initState() { 
    super.initState();

   // if(_keyboardIsVisible())     Timer(Duration(milliseconds: 1000), () => _controller.jumpTo(_controller.position.maxScrollExtent));


    getUser();
  }

  TextEditingController commentController = TextEditingController();
  User user ;

  @override
  Widget build(BuildContext context) {

    Timer(Duration(milliseconds: 1000), () => _controller.jumpTo(_controller.position.maxScrollExtent));

    return  Scaffold(
        body: Stack(children: <Widget>[

        Center(child: Container(
              child: Column(
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        height: 100,
                        child: ListView(
                          controller: _controller,
                          children: <Widget>[
                          StreamBuilder<QuerySnapshot>(
                              stream: Firestore.instance.collection('/publicRoom').orderBy("time", descending: false).snapshots(),
                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (!snapshot.hasData) return new Text('Loading...');
                                return new Padding(child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: snapshot.data.documents.map((document) {
                                    return new  Padding(child: Card(
                                        child : Row(children: <Widget>[
                                         // Icon(Icons.account_circle, size: 40,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Padding(padding:EdgeInsets.only(left: 8), child:new Text(document['name'], style: TextStyle(fontSize: 18),),),
                                              Padding(padding:EdgeInsets.only(left: 8), child:new Text(document['message'], style: TextStyle(fontSize: 14),),),
                                              document['image'] != "dummy" ? Padding(padding:EdgeInsets.only(left: 8, bottom: 10, top: 10), child: FittedBox(child: Image( height: 200, width: 200,image: NetworkImage(document['image']),), fit: BoxFit.fill,) ,):Text(" "),
                                             // Padding(padding:EdgeInsets.only(left: 8), child:new Text(_convertStamp(document['time']).toString().split(" ")[1].split(".")[0]  , style: TextStyle(fontSize: 14), textAlign: prefix0.TextAlign.end),),

                                            ],)
                                        ],)

                                    ), padding: document['uid'] == id ?  EdgeInsets.only(left: 120) : EdgeInsets.only(right: 120));
                                  }).toList(),
                                ), padding:  EdgeInsets.only(bottom: 60));
                              }
                          )

                        ],),
                      ),
                    ),

                  ])
          )
          ),
          Positioned(

            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child : Container(
              color: Colors.grey,
              child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: <Widget>[

              Expanded(child: Padding(child: TextField(controller: commentController,style: TextStyle(color:Colors.black), decoration: InputDecoration(
                hintText: "Write something... ",
                filled: true,
                fillColor: Colors.white,
                hintStyle: TextStyle(color: Colors.grey),
              ),),padding: EdgeInsets.only(right: 10, left: 10, top: 5, bottom: 5),)),

              Padding(child:InkWell(child:Icon(Icons.send), onTap: (){sendMessage();},), padding: EdgeInsets.all(10),),
              Padding(child:InkWell(child:Icon(Icons.attach_file), onTap: (){chooseFile();},), padding: EdgeInsets.all(10),),
              
            ],)
    ,)
          )

          ])
        );
  }


void sendMessage() async{
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  if(_image == null){
Firestore.instance.collection("publicRoom").add({
    "message" : commentController.text,
    "name" : name,
    "image" : "dummy",
    "uid" : id,
    "time" : FieldValue.serverTimestamp()
  }).then((v){
        Timer(Duration(milliseconds: 1000), () => _controller.jumpTo(_controller.position.maxScrollExtent));

    commentController.text = "";
  }).catchError((e){
     Fluttertoast.showToast(
        msg: "Something went wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  });
  }
  else{
   await uploadFile().then((v){
Firestore.instance.collection("publicRoom").add({
    "message" : commentController.text,
    "name" : name,
    "image" : _uploadedFileURL,
    "uid" : id,
    "time" : FieldValue.serverTimestamp()
  }).then((v){
        Timer(Duration(milliseconds: 1000), () => _controller.jumpTo(_controller.position.maxScrollExtent));

    print(_uploadedFileURL + " sent");
    Firestore.instance.collection("publicRoom").document(v.documentID).updateData({
      "image" : _uploadedFileURL
    });
    commentController.text = "";
  }).catchError((e){
     Fluttertoast.showToast(
        msg: "Something went wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  });
    });

  }
  
}



Future chooseFile() async {    
   await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {    
     setState(() {    
       _image = image;    
     });    
     print(_image);
   });    
 }


 Future uploadFile() async {    
   StorageReference storageReference = FirebaseStorage.instance    
       .ref()    
       .child('publicRoom/${Path.basename(_image.path)}}');    
   StorageUploadTask uploadTask = storageReference.putFile(_image);    
   await uploadTask.onComplete;    
   print('File Uploaded');    
   storageReference.getDownloadURL().then((fileURL) {    
     setState(() {    
       _uploadedFileURL = fileURL;    
     });    
     print(_uploadedFileURL);
   });    
 }  

DateTime _convertStamp(Timestamp _stamp) {

  if (_stamp != null) {

    return Timestamp(_stamp.seconds, _stamp.nanoseconds).toDate();

    /*
    if (Platform.isIOS) {
      return _stamp.toDate();
    } else {
      return Timestamp(_stamp.seconds, _stamp.nanoseconds).toDate();
    }
    */

  } else {
    return null;
  }
}

}