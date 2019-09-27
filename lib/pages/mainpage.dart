import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_android_lifecycle/flutter_android_lifecycle.dart';
import 'package:flutter_branch_io_plugin/flutter_branch_io_plugin.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_test_app/controllers/user_controller.dart';
import 'package:social_test_app/pages/DetailScreen.dart';
import 'package:social_test_app/pages/Profile.dart';
import 'package:social_test_app/pages/public_chat_room.dart';
import 'package:social_test_app/pages/saved_posts.dart';
import 'package:social_test_app/pages/signup_screen.dart';
import 'package:social_test_app/pages/testpage.dart';
import 'package:social_test_app/pages/testpage.dart';
import 'package:social_test_app/widgets/posts.dart';



import 'add_item_screen.dart';

class Mainpage extends StatefulWidget {
  @override
  _MainpageState createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {


  var id = "";
  var name = "";

  void getUser() async{
    user = await UserController.getCurrentUser();
    setState(() {
      id = user.id;
      name = user.name;
    });
  }
  

 

 @override
  void initState() {
    super.initState();
    getUser();
      if (Platform.isAndroid) FlutterBranchIoPlugin.setupBranchIO();
      FlutterBranchIoPlugin.listenToDeepLinkStream().listen((string) {
        print("DEEPLINK $string");
        // PROCESS DEEPLINK HERE
      });
      if (Platform.isAndroid) {
        FlutterAndroidLifecycle.listenToOnStartStream().listen((string) {
          print("ONSTART");
          FlutterBranchIoPlugin.setupBranchIO();
        });
      }
  //  initBranch();

  }

int _selectedIndex = 0;

void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
  });
}

static  List<Widget> _widgetOptions = <Widget>[
  
  Posts(),
  AddItemScreen(),
  SavedPosts(),
  OpenChatRoom(),
  Profile(),
  
];

static List<String> _widgetnames = <String>[
  "HOME",
  "CREATE NEW POST",
  "SAVED POSTS",
  "PUBLIC CHAT ROOM",
  "PROFILE",
];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        if(_selectedIndex!=0){
          setState(() {
            _selectedIndex=0;
          });
          return false;
        }
        return true;
      },
      child: WillPopScope(

        onWillPop: ()async{
          exit(0);
          return false;
        },

        child: 
    
      Scaffold(
      appBar: AppBar(title: Center(child:Text(_widgetnames[_selectedIndex])), automaticallyImplyLeading: false,),
      body: Center(
        child: _widgetOptions[_selectedIndex]
      ), 

      bottomNavigationBar: BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: Colors.blueAccent),
          title: Text("HOME",),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_box, color: Colors.blueAccent),
          title: Text('New post'),
        ),
         BottomNavigationBarItem(
          icon: Icon(Icons.bookmark, color: Colors.blueAccent),
          title: Text('Bookmarked'),
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.solidCommentAlt, color: Colors.blueAccent),
          title: Text('Chat'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle, color: Colors.blueAccent,),
          title: Text('Profile'),
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.grey,
      onTap: _onItemTapped,
    ),
    ) ,
    ));
      
  }
}