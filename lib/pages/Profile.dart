import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_test_app/controllers/user_controller.dart';
import 'package:social_test_app/models/user.dart';
import 'package:social_test_app/pages/splash_screen.dart';
import 'package:social_test_app/widgets/common/roundbutton.dart';
import 'package:social_test_app/widgets/common/rounded_button.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User user;
  String name = "";
  String dp = "";
  String id = "";

  void getUser() async {
    user = await UserController.getCurrentUser();
    name = user.name;
    dp = user.image;
    id = user.id;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            child: Row(
              children: <Widget>[
                Image(
                  image: NetworkImage(dp, scale: 10.0),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      child: Text(
                        name,
                        style: TextStyle(fontSize: 18),
                      ),
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Padding(
                      child: Text(
                          "Here there, I am using this test social media app"),
                      padding: EdgeInsets.only(left: 10),
                    ),

                    SizedBox(height: 10.0,),
                    Row(children: <Widget>[
                    Padding(child:RoundButton("Edit Profile", onTap: (){notImpl();},), padding: EdgeInsets.all(6),),
                    Padding(child:RoundButton("Friends", onTap: (){notImpl();}), padding: EdgeInsets.all(6),),
                     Padding(child:RoundButton("Logout", onTap: (){UserController.logOut();  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SplashScreen()
                      ),
                    );}), padding: EdgeInsets.all(6),),
                    ],)
                  ],
                )
              ],
            ),
            padding: EdgeInsets.all(10),
          ),

          Padding(child:Container(
            color: Colors.white,
            height: 1,
          ),padding:EdgeInsets.only(left: 10, right: 10)),
          SizedBox(height: 20),
          Text("RECENT POSTS", style: TextStyle(fontSize: 22.0),),
          SizedBox(height: 10),
          StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('/posts')
                  .where("uid", isEqualTo: id)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return new Text('Loading...');
                return new Padding(
                  child: Column(
                    children: snapshot.data.documents.map((document) {
                      return new Card(
                          child: Column(
                        children: <Widget>[
                         Padding(child: Row(children: <Widget>[
                             FittedBox(
                              child: Image.network(
                            user.image,
                            scale: 10.0,
                          )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                              Padding(child:Text(user.name),padding: EdgeInsets.only(left: 10.0, bottom: 2.0),),
                              Padding(child:Text(document['timestamp']), padding: EdgeInsets.only(left: 10.0),)
                            ],)
                          ],),padding: EdgeInsets.all(10),),
                          FittedBox(
                              child: Image.network(
                            document['image'],
                            fit: BoxFit.fill,
                          )),

                          Padding(child:Text(document['title'], style: TextStyle(fontSize: 20.0),), padding: EdgeInsets.only(left: 10, right: 10, bottom: 4),),
                          Padding(child:Text(document['body'], style: TextStyle(fontSize: 14.0),), padding: EdgeInsets.only(left: 10, right: 10, bottom: 4),),
                        ],
                      ));
                    }).toList(),
                  ),
                  padding: EdgeInsets.only(bottom: 60),
                );
              })
        ],
      ),
    ));
  }

  void notImpl(){
        Fluttertoast.showToast(
        msg: "Not implemented yet",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
