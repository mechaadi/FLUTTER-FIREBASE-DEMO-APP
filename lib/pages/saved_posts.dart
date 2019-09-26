import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter_branch_io_plugin/flutter_branch_io_plugin.dart';
import 'package:flutter_android_lifecycle/flutter_android_lifecycle.dart';
import 'package:social_test_app/controllers/item_controller.dart';
import 'package:social_test_app/controllers/user_controller.dart';
import 'package:social_test_app/models/user.dart';
import 'package:social_test_app/pages/DetailScreen.dart';
import 'package:social_test_app/widgets/common/post_widgets.dart';

class SavedPosts extends StatefulWidget {
  @override
  SavedPostsState createState() => new SavedPostsState();
}

class SavedPostsState extends State<SavedPosts> {
  String id, name, image;
  User user;
  String generatedLink = " ";
  bool canLike = true;
  List<DocumentSnapshot> m;


  @override
  void initState() {
    super.initState();

     getInitUser();
  }

  void getInitUser() async {
    user = await UserController.getCurrentUser();
    setState(() {
      id = user.id;
      name = user.name;
      image = user.image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('bookmarks').document(id).collection("saved").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new CircularProgressIndicator();
          default:
            return new ListView(
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                return GestureDetector(
                  child: Card(
                      elevation: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.account_circle,
                                    size: 40,
                                  )),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      document['author'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    child: Text(
                                        document['timestamp']
                                                .toString()
                                                .split('T')[0] +
                                            " @ " +
                                            document['timestamp']
                                                .toString()
                                                .split('T')[1]
                                                .split('.')[0],
                                        style: TextStyle(
                                          fontSize: 12,
                                        )),
                                    padding: EdgeInsets.all(5),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Image(
                            image: NetworkImage(document['image']),
                          ),
                          Padding(
                              padding:
                                  EdgeInsets.only(left: 10, top: 10, bottom: 5),
                              child: Text(
                                document['title'],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'Roboto',
                                    letterSpacing: 2),
                                textAlign: TextAlign.start,
                              )),
                          Padding(
                              padding:
                                  EdgeInsets.only(left: 13, top: 4, bottom: 10),
                              child: Text(
                                document['body'],
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.start,
                              )),
                          SizedBox(
                              height: 2.0,
                              child: Padding(
                                child: Container(
                                  color: Colors.grey,
                                ),
                                padding: EdgeInsets.only(left: 20, right: 20),
                              )),
                            PostWidget(text: document['id'], uid: document['uid'],
                             likes : document['likesCount'].toString(), 
                             image : document['image'],
                             title: document['title'],
                             body : document['body'],
                             author : document['author'],
                             timestamp : document['timestamp'].toString(),
                             thumbnail : document['thumbnail'],)
                        ],
                      )),
                  onTap: () {
                    String text;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailScreen(text: document['id']),
                      ),
                    );
                  },
                );
              }).toList(),
            );
        }
      },
    ));
  }



  String _convertStamp(String _stamp) {
//    if (_stamp != null) {
//      return Timestamp(_stamp.seconds, _stamp.nanoseconds).toDate();
//    } else {
//      return null;
//    }

    print(_stamp);

    return _stamp.split('T')[0];
  }
}
