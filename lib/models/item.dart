import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'item.g.dart';

@JsonSerializable()
class Item{

  String id;
  String title;
  String body;
  String image;
  String thumbnail;
  String author;
  DateTime timestamp;
  String uid;
  int likesCount;
 

  Item(this.id,this.title, this.body, this.image,this.thumbnail, this.author, this.timestamp, this.uid, this.likesCount);

  Item.named({this.id, this.title, this.body, this.image, this.thumbnail, this.author, this.timestamp, this.uid, this.likesCount});


  Map<String,dynamic> toJson()=>_$ItemToJson(this);

  factory Item.fromJson(json)=>_$ItemFromJson(json);
} 