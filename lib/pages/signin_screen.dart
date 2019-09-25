//import 'package:social_test_app/controllers/payment_controller.dart';
//import 'package:social_test_app/controllers/payment_controller.dart';
import 'dart:io';

import 'package:flutter_android_lifecycle/flutter_android_lifecycle.dart';
import 'package:flutter_branch_io_plugin/flutter_branch_io_plugin.dart';
import 'package:social_test_app/controllers/user_controller.dart';
import 'package:social_test_app/pages/signup_screen.dart';
import 'package:social_test_app/widgets/custom_text_field.dart';
import 'package:social_test_app/widgets/common/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SigninScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String email,password;
  bool isLoading;
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
  
    email="";
    password="";
    isLoading=false;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                                fontSize: 48.0, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: Text(
                            "Pick a theme that works for you. You can always change themes in your app settings.",
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w400),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      "images/logo.png",
                      width: MediaQuery.of(context).size.width / 3.5,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        CustomTextField(
                          iconData: Icons.email,
                          label: "Email",
                          onSubmitted: (val) {
                            email=val;
                          },
                        ),
                        CustomTextField(
                          iconData: Icons.lock,
                          label: "Password",
                          onSubmitted: (val) {
                            password=val;
                          },
                          obsecure: true,
                        ),

                        SizedBox(
                          height: 16.0,
                        ),
                        RoundedButton(
                          "Sign In",
                          onTap: () async{
                            setState((){
                              isLoading=true;
                            });
                           String message= await UserController.signIn(email,password);
                            setState((){
                              isLoading=false;
                            });
                            if(message!=null){
                              _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
                            }
                            else{

                              Navigator.of(context).pushNamed('/');
                            }
                          },
                          isLoading: isLoading,
                          //nextIcon: true,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12.0,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Don't have an account? ",
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => SignupScreen()));
                          },
                          child: Text(
                            "Sign up",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle
                                .copyWith(color: Colors.blueAccent),
                          )),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 16.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
