import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_test_app/controllers/user_controller.dart';
import 'package:social_test_app/models/user.dart';
import 'package:social_test_app/pages/DetailScreen.dart';
import 'package:social_test_app/pages/saved_posts.dart';
import 'package:social_test_app/pages/splash_screen.dart';
import 'package:social_test_app/widgets/common/roundbutton.dart';


class TabBarProfile extends StatefulWidget{
  @override
    TabProfileState createState() => TabProfileState();
 
}

class TabProfileState extends State<TabBarProfile> {
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
    return MaterialApp(
      color: Colors.black,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.directions_transit)),
                Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
            title: Container(child:
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
            ),
          ),
          body: TabBarView(
            children: [
              SavedPosts(),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
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