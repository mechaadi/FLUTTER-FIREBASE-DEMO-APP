import 'package:social_test_app/controllers/user_controller.dart';
import 'package:social_test_app/models/user.dart';
import 'package:social_test_app/pages/signin_screen.dart';
import 'package:social_test_app/widgets/custom_text_field.dart';
import 'package:social_test_app/widgets/common/rounded_button.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignupState();
}

class _SignupState extends State<SignupScreen> {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String email, name, password, mobileNumber;
  bool isArtist;

  @override
  void initState() {
    super.initState();
    email = "";
    name = "";
    password = "";
    mobileNumber = "";
    isArtist=false;
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
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          elevation: 0.0,
          automaticallyImplyLeading: false,
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
                            "Sign Up",
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
              SizedBox(
                height: 12.0,
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        CustomTextField(
                          iconData: Icons.text_fields,
                          label: "Name",
                          onSubmitted: (val) {
                            name = val;
                          },
                        ),
                        CustomTextField(
                          iconData: Icons.email,
                          label: "Email",
                          onSubmitted: (val) {
                            email = val;
                          },
                        ),
                        CustomTextField(
                          iconData: Icons.lock,
                          label: "Password",
                          onSubmitted: (val) {
                            password = val;
                          },
                          obsecure: true,
                        ),
                        CustomTextField(
                          iconData: Icons.call,
                          label: "Mobile No",
                          onSubmitted: (val) {
                            mobileNumber = val;
                          },
                        ),
                        SizedBox(height: 8.0,),
                        // SwitchListTile(title: Text("Is Artist"),value: isArtist,onChanged: (val){
                        //   setState(() {
                        //     isArtist=val;
                        //   });
                        // },),
                        SizedBox(
                          height: 16.0,
                        ),
                        RoundedButton(
                          "Create Account",
                          isLoading: isLoading,
                          onTap: () async{
                            setState((){
                              isLoading=true;
                            });
                            String message=await UserController.createUser(User.named(
                                name: name,
                                email: email,
                                image: "https://firebasestorage.googleapis.com/v0/b/a7amusikk.appspot.com/o/user.png?alt=media&token=2fb37864-77dc-4ed1-b08b-39da28c10cc0",
                                mobileNumber: mobileNumber,isArtist: isArtist),password);
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
                        //  nextIcon: true,
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
                        "Already have an account? ",
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => SigninScreen()));
                          },
                          child: Text(
                            "Login",
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
  bool isLoading=false;
}
