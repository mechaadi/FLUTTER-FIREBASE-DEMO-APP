import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_test_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserController{

  static Future<DocumentReference> getUserReference()async{
    FirebaseUser user=await FirebaseAuth.instance.currentUser();
    if(user==null){
      return null;
    }
    return Firestore().collection("users").document(user.uid);
  }
  
  static Future<User> getCurrentUser()async{
    FirebaseUser user=await FirebaseAuth.instance.currentUser();
    if(user==null){
      return null;
    }
    DocumentSnapshot documentSnapshot=await Firestore.instance.collection("users").document(user.uid).get();

    return User.fromJson(documentSnapshot.data);
  }


  static Future<User> getUserById(String id)async{
    FirebaseUser user=await FirebaseAuth.instance.currentUser();
    if(user==null){
      return null;
    }
    DocumentSnapshot documentSnapshot=await Firestore.instance.collection("users").document(id).get();

    return User.fromJson(documentSnapshot.data);
  }



  static Future updateUser(User user)async{
    print("User ${user.email}");
    await Firestore.instance.collection("users").document(user.id).updateData(user.toJson());
  }

  static Future createUser(User user,String password)async{
    FirebaseAuth firebaseAuth=FirebaseAuth.instance;
    try{
      AuthResult auth=await firebaseAuth.createUserWithEmailAndPassword(email: user.email, password:password);
      await firebaseAuth.signInWithEmailAndPassword(email: user.email, password: password);
      DocumentReference reference=await getUserReference();
      user.id=auth.user.uid;
      reference.setData(user.toJson());
      return null;
    }
    catch(e){
      return e.toString();
    }
  }

  static Future logOut()async{
    await FirebaseAuth.instance.signOut();
     
  }

  static Future<String> signIn(String email, String password) async{
     FirebaseAuth firebaseAuth=FirebaseAuth.instance;
     try{
       await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
       return null;
     }
     catch(e){
       return e.toString();
     }
  }

  static Stream<bool> onAuthStateChanged()async*{
    await for(var val in FirebaseAuth.instance.onAuthStateChanged){
      if(val==null){
        yield false;
      }
      yield true;
    }
  }
}