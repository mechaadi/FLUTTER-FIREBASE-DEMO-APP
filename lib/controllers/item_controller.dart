


import 'dart:io';

import 'package:social_test_app/controllers/id_controller.dart';
import 'package:social_test_app/controllers/image_controller.dart';
import 'package:social_test_app/models/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemController{

  static const String ITEMS="posts";

  static Firestore _fireStore=Firestore.instance;


  static Future getItem(String id) async{
    DocumentSnapshot documentSnapshot=await Firestore.instance.collection("posts").document(id).get();
   return Item.fromJson(documentSnapshot.data);

  }

  static Future saveItem(Item item,File image) async{

    item.id=IDController.hash(DateTime.now().toString());
    String thumbnailUrl=await ImageController.storeImage(image);
    String imageUrl=await ImageController.storeImage(image,compress: false);
    item.thumbnail=thumbnailUrl;
    item.image=imageUrl;
    await _fireStore.collection(ITEMS).document(item.id).setData(item.toJson());
  }

  static Future LikeItem(String id, String uid) async{
    final DocumentReference postRef = Firestore.instance.collection('posts').document(id);
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        await tx.update(postRef, <String, dynamic>{'likesCount': postSnapshot.data['likesCount'] + 1});
      }
    });

    Firestore.instance.collection('posts').document(id).collection("likedby").document(uid).setData({
      "uid" : uid,
      "liked" : true
    }
    );



  }

  static Future DislikeItem(String id, String uid) async{
    final DocumentReference postRef = Firestore.instance.collection('posts').document(id);
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        await tx.update(postRef, <String, dynamic>{'likesCount': postSnapshot.data['likesCount'] - 1});
      }
    });

    Firestore.instance.collection('posts').document(id).collection("likedby").document(uid).delete().then((v){
      print("deleted");
    }).catchError((v){
      print(v);
    });
  }

  static Future checkLiked(String id) async{
    Firestore.instance
        .collection('posts')
        .document('id')
        .get()
        .then((DocumentSnapshot ds) {
      // use ds as a snapshot
    });
  }

}