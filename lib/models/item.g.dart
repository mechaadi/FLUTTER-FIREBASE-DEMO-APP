// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) {
  return Item(
    json['id'] as String,
    json['title'] as String,
    json['body'] as String,
    json['image'] as String,
    json['thumbnail'] as String,
    json['author'] as String,
    json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String),
    json['uid'] as String,
  );
}

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'image': instance.image,
      'thumbnail': instance.thumbnail,
      'author': instance.author,
      'timestamp': instance.timestamp?.toIso8601String(),
      'uid': instance.uid,
    };
