import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_test_app/controllers/item_controller.dart';
import 'package:social_test_app/controllers/user_controller.dart';
import 'package:social_test_app/models/item.dart';
import 'package:social_test_app/models/user.dart';
import 'package:social_test_app/widgets/common/custom_drop_down_widget.dart';
import 'package:social_test_app/widgets/common/custom_text_input_widget.dart';
import 'package:social_test_app/widgets/common/image_input_widget.dart';
import 'package:social_test_app/widgets/common/rounded_button.dart';
//import 'package:social_test_app/widgets/location/location_input_widget.dart';
import 'package:flutter/material.dart';
//import 'package:google_places_picker/google_places_picker.dart';

class AddItemScreen extends StatefulWidget {
  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  File image;
  String id, name;
  User user;
  Item item = Item.named();
  List<String> categories = ["Electronics", "Cars", "Clothes"];


  void getInitUser() async {
    user = await UserController.getCurrentUser();
    setState(() {
      id = user.id;
      name = user.name;
    });

    item = Item.named(author: name, timestamp: DateTime.now(), uid:id);

  }

  @override
  void initState() {
    super.initState();
    getInitUser();

  }

  bool submitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CustomTextInputWidget(
                label: "Enter Title",
                onChanged: (val) {
                  item.title = val;
                  setState(() {});
                },
                readOnly: false,
              ),
              CustomTextInputWidget(
                label: "Enter Description",
                onChanged: (val) {
                  item.body = val;
                  setState(() {});
                },
                minLines: 2,
                maxLength: 200,
                readOnly: false,
              ),
              SizedBox(
                height: 8.0,
              ),
              
             
            
             
              ImageInputWidget(
                onImagesAdded: (val) {
                  if (val.length == 0) {
                    image = null;
                  } else {
                    image = val[0];
                  }
                  setState(() {});
                },
                max: 1,
              ),
              SizedBox(
                height: 8.0,
              ),

              // LocationInputWidget(
              //   onLocationSelected: (val) {
              //     item.fullAddress = val.fullAddress;
              //     item.longitude = val.position.longitude;
              //     item.latitude = val.position.latitude;
              //   },
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: RoundedButton(
        
        "Submit",
        onTap: !canSubmit
            ? null
            : () async {
                setState(() {
                  submitting = true;
                });
                await ItemController.saveItem(item, image);
                setState(() {
                  submitting = false;
                });
              },
        isLoading: submitting,
      ),
    );
  }

  bool get canSubmit => (image != null &&
      item.title != null &&
      item.body != null);

}
