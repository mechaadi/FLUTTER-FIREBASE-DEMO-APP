import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_branch_io_plugin/flutter_branch_io_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_test_app/controllers/item_controller.dart';
import 'package:social_test_app/controllers/user_controller.dart';
import 'package:social_test_app/models/user.dart';

class PostWidget extends StatefulWidget {
  @override
  _PostWidgetState createState() => new _PostWidgetState();
  String text, uid, likes, title, body, image, author, timestamp, thumbnail;
  PostWidget(
      {Key key, @required this.text, @required this.uid, @required this.likes, @required this.title, @required this.body, @required this.image, @required this.author, @required this.timestamp, @required this.thumbnail})
      : super(key: key);
}

class _PostWidgetState extends State<PostWidget> {
  bool liked = false;
  String id = " ", name = " ", image = " ";
  User user;
  bool canLike = false;
  String generatedLink = "";
  int commentsCount = 0;

  void getInitUser() async {
    user = await UserController.getCurrentUser();
    if (this.mounted)
    setState(() {
      this.id = user.id;
      this.name = user.name;
      this.image = user.image;
    });
  }

  @override
  void initState() {
    super.initState();
    getInitUser();
    checkCanLike();
    getCommentsCount();
  }


  Future getCommentsCount() async{
    Firestore.instance.collection('posts').document(widget.text).collection('comments').getDocuments().then((v){
      if(this.mounted){
        setState(() {
          commentsCount = v.documents.length;
        });
      }
    });
  }

  Future checkCanLike() async {
    await Firestore.instance
        .collection("posts")
        .document(widget.text)
        .collection("likedby")
        .getDocuments()
        .then((v) {
      //print("Priting list:"+ m.elementAt(1).data.toString());
      if (v.documents.length == 0) {
    if (this.mounted)
        setState(() {
          this.canLike = true;
        });
        print("it's empty");
      } else {
        for (int i = 0; i < v.documents.length; i++) {
          print(v.documents.elementAt(i).data);

          if (v.documents.elementAt(i).documentID == id) {
    if (this.mounted)
            setState(() {
              this.canLike = false;
            });
            break;
          } else {
    if (this.mounted)
            setState(() {
              this.canLike = true;
            });
            print("not exists");
            break;
          }
        }
      }
    }).catchError((v) {});
  }

 @override
  void dispose() {
    super.dispose();}


  @override
  Widget build(BuildContext context) {
    return  
     Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(width: 1,),
            Padding(
                padding: EdgeInsets.only(top: 10, left: 30, bottom: 10),
                child: canLike
                    ? InkWell(
                        child: Icon(
                          FontAwesomeIcons.heart,
                          color: Colors.red,
                          size: 20.0,
                        ),
                        onTap: () async {
                          //  _openIt;
                          checkCanLike();
                          ItemController.LikeItem(widget.text, widget.uid);
                        },
                      )
                    : InkWell(
                        child: Icon(
                          FontAwesomeIcons.solidHeart,
                          color: Colors.red,
                          size: 20.0,
                        ),
                        onTap: () async {
                          //  _openIt;
                          checkCanLike();

                          ItemController.DislikeItem(widget.text, widget.uid);
                        },
                      )),
            Padding(
              child: Text(widget.likes),
              padding: EdgeInsets.all(4),
            )
          ],
        ),

        Row(children: <Widget>[
  Padding(
          padding: EdgeInsets.only(left: 20, right: 4, top: 10, bottom: 10),
          child: Icon(
            FontAwesomeIcons.commentAlt,
            color: Colors.lightBlue,
            size: 20.0,
          ),
        ),
         Padding(
              child: Text(this.commentsCount.toString()),
              padding: EdgeInsets.only(left: 2, right: 4, top: 4, bottom: 4),
            )
        ],),
      
        Padding(
            padding: EdgeInsets.only(top: 10, right: 30, bottom: 10 ,left: 20),
            child: InkWell(
              child: Icon(
                FontAwesomeIcons.shareAlt,
                color: Colors.blueAccent,
                size: 20.0,
              ),
              onTap: () {
                share(widget.image,
                    widget.title, widget.body);
              },
            )),

            Spacer(),
             Padding(
            padding: EdgeInsets.only(top: 10, right: 30, bottom: 10 ,left: 20),
            child: InkWell(
              child: Icon(
                FontAwesomeIcons.bookmark,
                color: Colors.blueAccent,
                size: 20.0,
              ),
              onTap: () async{
                Firestore.instance.collection("bookmarks").document(id).collection("saved").document(widget.text).setData({
                  "title" : widget.title,
                  "image" : widget.image,
                  "body" : widget.body,
                  "likesCount" : widget.likes,
                  "author" : widget.author,
                  "thumbnail" : widget.thumbnail,
                  "id" : widget.text,
                  "uid" : widget.uid,
                  "timestamp" : widget.timestamp,
                }).then((v){
                   Fluttertoast.showToast(
        msg: "Bookmarked successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );
                }); 
              },
            )),
      ],
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

      /// HAVING SOME ISSUES WITH BRANCH IO CODE..
      //Share.text('my text title', v, 'text/plain');
      
    });

     Share.text('my text title', title + "\n\n" + body + "\n\nimage : " + url, 'text/plain');

// var request = await HttpClient().getUrl(Uri.parse(url));
// var response = await request.close();
// Uint8List bytes = await consolidateHttpClientResponseBytes(response);
// await Share.file('ESYS AMLOG', 'amlog.jpg', bytes, 'image/jpg');
  }
}
