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

class Posts extends StatefulWidget {
  @override
  PostsState createState() => PostsState();
}

class PostsState extends State<Posts> {
  String id, name, image;
  User user;
  String generatedLink = " ";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // getInitUser();
  }

  void getInitUser(String uid) async {
    user = await UserController.getUserById(uid);
    setState(() {
      id = user.id;
      name = user.name;
      image = user.image;
    });

    //item = Item.named(author: name, timestamp: DateTime.now(), uid:id);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('posts').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new CircularProgressIndicator();
          default:
            return new ListView(
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                //getInitUser(document['uid']);
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: 10, left: 30, bottom: 10),
                                      child: InkWell(
                                        child: Icon(
                                          FontAwesomeIcons.solidHeart,
                                          color: Colors.red,
                                          size: 20.0,
                                        ),
                                        onTap: () {
                                          ItemController.LikeItem(
                                              document['id']);
                                        },
                                      )),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  FontAwesomeIcons.commentAlt,
                                  color: Colors.lightBlue,
                                  size: 20.0,
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: 10, right: 30, bottom: 10),
                                  child: InkWell(
                                    child: Icon(
                                      FontAwesomeIcons.shareAlt,
                                      color: Colors.blueAccent,
                                      size: 20.0,
                                    ),
                                    onTap: () {
                                      share(document['image'],
                                          document['title'], document['body']);
                                    },
                                  )),
                            ],
                          )
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
    );
  }

  void share(String url, String title, String body) async {
    // initState();
    FlutterBranchIoPlugin.generateLink(
        FlutterBranchUniversalObject()
            .setCanonicalIdentifier("content/12345")
            .setTitle(title)
            .setContentDescription(body)
            .setContentImageUrl(url)
            .setContentIndexingMode(BUO_CONTENT_INDEX_MODE.PUBLIC)
            .setLocalIndexMode(BUO_CONTENT_INDEX_MODE.PUBLIC),
        lpChannel: "facebook",
        lpFeature: "sharing",
        lpCampaign: "content 123 launch",
        lpStage: "new user",
        lpControlParams: {"url": "http://www.google.com"});

    FlutterBranchIoPlugin.listenToGeneratedLinkStream().listen((link) {
      print("GET LINK IN FLUTTER");
      print(link);
      setState(() {
        this.generatedLink = link;
      });
    }).onData((v) {
      Share.text('my text title', v, 'text/plain');
    });

// var request = await HttpClient().getUrl(Uri.parse(url));
// var response = await request.close();
// Uint8List bytes = await consolidateHttpClientResponseBytes(response);
// await Share.file('ESYS AMLOG', 'amlog.jpg', bytes, 'image/jpg');
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
