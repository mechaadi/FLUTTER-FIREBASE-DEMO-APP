import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_test_app/controllers/user_controller.dart';
import 'package:social_test_app/models/user.dart';
import 'package:fluttertoast/fluttertoast.dart';


void main() {
  runApp(MaterialApp(
    home: DetailScreen(),
    theme: ThemeData.dark(),
  ));
}

class DetailScreen extends StatefulWidget{
  StateKeeper createState() => new StateKeeper();

  final String text;
  DetailScreen({Key key, @required this.text}) : super(key: key);

}

TextEditingController commentController = TextEditingController();
User user ;


class StateKeeper extends State<DetailScreen>{
  var title = "";
  var desc = "";
  var image = "";
  var author = "";
  var time = "T.";


  void getUser() async{
    user = await UserController.getCurrentUser();
    setState(() {
      
    });
  }

  @override
  void initState() { 
    super.initState();
    getUser();
  }

  Widget build(BuildContext context){
    Firestore.instance
        .collection('posts')
        .document(widget.text)
        .get()
        .then((DocumentSnapshot ds) {
      setState(() {
        this.title = ds['title'];
        this.image = ds['image'];
        this.author = ds['author'];
        this.desc = ds['body'];
        this.time = ds['timestamp'];
      });

    });

    // use ds as a snapshot

    return Scaffold(

        appBar: AppBar(title: Text("READ MORE", style: TextStyle(color: Colors.white),)),
        body: Stack(children: <Widget>[

        Center(child: Container(
              child: Column(
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        height: 100,
                        child: ListView(children: <Widget>[
                          new Card(
                              elevation: 10,
                              child : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[

                                  Padding(padding : EdgeInsets.only(left: 10, top: 10),child:Text(this.title,style: TextStyle(fontSize: 30, fontFamily: 'Roboto', letterSpacing: 2), textAlign: TextAlign.start,)),

                                  Row(children: <Widget>[
                                    Padding(padding: EdgeInsets.all(10), child: Icon(Icons.account_circle),),
                                    Padding(padding: EdgeInsets.all(10), child: Text(this.author, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),),
                                    Padding(padding: EdgeInsets.all(10), child: Icon(Icons.calendar_today)),
                                    Text((this.time).toString().split("T")[0] + " @ " + (this.time).toString().split("T")[1].split(".")[0] , style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                                  ],),


                                  FittedBox(
                                    child: Image.network(this.image),
                                    fit: BoxFit.fill,
                                  ),
                                  Padding(padding : EdgeInsets.only(left: 13, top: 4, bottom: 10),child:Text(this.desc, style: TextStyle(fontSize: 14), textAlign: TextAlign.start,)),


                                  Container(
                                    height: 1,
                                    margin: EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
                                    decoration: BoxDecoration(shape: BoxShape.rectangle, color: Colors.black),
                                  ),

                                  Row(
                                    children: <Widget>[

                                      Padding(padding:EdgeInsets.only(top:10, left: 30, bottom: 10),child: Icon(FontAwesomeIcons.thumbsUp, color: Colors.blue,),),
                                      Padding(padding:EdgeInsets.all(10),child: Icon(FontAwesomeIcons.shareAlt, color: Colors.blue,),),

                                    ],)


                                ],)

                          ),


                          StreamBuilder<QuerySnapshot>(
                              stream: Firestore.instance.collection('/posts').document(widget.text).collection('comments/').orderBy("time", descending: true).snapshots(),
                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (!snapshot.hasData) return new Text('Loading...');
                                return new Padding(child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: snapshot.data.documents.map((document) {
                                    return new Card(
                                        child : Row(children: <Widget>[
                                          Icon(Icons.account_circle, size: 40,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(padding:EdgeInsets.only(left: 8), child:new Text(document['name'], style: TextStyle(fontSize: 18),),),
                                              Padding(padding:EdgeInsets.only(left: 8), child:new Text(document['comment'], style: TextStyle(fontSize: 14),),),

                                            ],)
                                        ],)

                                    );
                                  }).toList(),
                                ), padding: EdgeInsets.only(bottom: 60),);
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
              color: Colors.black,
              child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: <Widget>[

              Expanded(child: Padding(child: TextField(controller: commentController,style: TextStyle(color:Colors.white), decoration: InputDecoration(
                hintText: "Leave a comment ...",
                filled: true,
                fillColor: Colors.black,
              ),),padding: EdgeInsets.only(right: 10, left: 10, top: 5, bottom: 5),)),

              Padding(child:InkWell(child:Icon(Icons.send), onTap: (){comment(widget.text);},), padding: EdgeInsets.all(10),),
            ],)
    ,)
          )

          ])
        );


  }
}



void comment(String id) async{
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  Firestore.instance.collection("posts").document(id).collection("comments").add({
    "comment" : commentController.text,
    "name" : user.email.split('@')[0],
    "uid" : user.uid,
    "time" : FieldValue.serverTimestamp()
  }).then((v){
    commentController.text = "";
    Fluttertoast.showToast(
        msg: "Comment saved",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );
    
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
