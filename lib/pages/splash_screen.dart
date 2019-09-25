//import 'package:social_test_app/controllers/payment_controller.dart';
import 'dart:io';

import 'package:flutter_android_lifecycle/flutter_android_lifecycle.dart';
import 'package:flutter_branch_io_plugin/flutter_branch_io_plugin.dart';
import 'package:social_test_app/controllers/user_controller.dart';
//import 'package:a7a/pages/Music.dart';
//import 'package:a7a/pages/offlinemode.dart';
import 'package:flutter/material.dart';
//import 'package:connectivity/connectivity.dart';


class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoading;


  @override
  void initState() {
    super.initState();

    
  //  initBranch();

  
    isLoading=true;
    refresh();
  //   check().then((intenet) {
  //     if (intenet != null && intenet) {
  //       refresh();
  //     }
  //     else{
  //  Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                           builder: (context) => offlinemode(
                           
  //                           ),
  //                         ));
  //     }
    

  //   });
    
  }

  Future refresh()async{
    var checkUser=await UserController.getCurrentUser();
    if(checkUser==null){
      Navigator.of(context).pushNamed('/signIn');
      return;
    }
   // bool checkPayment=await PaymentController.checkPayment();
    setState(() {
      isLoading=false;
    });
    Navigator.of(context).pushNamed('/');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }


// Future<bool> check() async {
//         var connectivityResult = await (Connectivity().checkConnectivity());
//         if (connectivityResult == ConnectivityResult.mobile) {
//           return true;
//         } else if (connectivityResult == ConnectivityResult.wifi) {
//           return true;
//         }
//         return false;
//       }
}