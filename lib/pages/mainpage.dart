import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_android_lifecycle/flutter_android_lifecycle.dart';
import 'package:flutter_branch_io_plugin/flutter_branch_io_plugin.dart';
import 'package:social_test_app/pages/Profile.dart';
import 'package:social_test_app/pages/saved_posts.dart';
import 'package:social_test_app/pages/signup_screen.dart';
import 'package:social_test_app/widgets/posts.dart';



import 'add_item_screen.dart';

class Mainpage extends StatefulWidget {
  @override
  _MainpageState createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {

 @override
  void initState() {
    super.initState();
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
  Profile(),
  
];

static List<String> _widgetnames = <String>[
  "HOME",
  "CREATE NEW POST",
  
  "SAVED POSTS",
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
          icon: Icon(Icons.home),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          title: Text('New post'),
        ),
         BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          title: Text('Bookmarked'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          title: Text('Profile'),
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    ),
    ) ,
    ));
      
  }
}