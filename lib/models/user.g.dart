// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['name'] as String,
    json['email'] as String,
    json['image'] as String,
    json['id'] as String,
    json['mobileNumber'] as String,
    json['isArtist'] as bool,
    (json['latitude'] as num)?.toDouble(),
    (json['longitude'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'image': instance.image,
      'name': instance.name,
      'email': instance.email,
      'id': instance.id,
      'mobileNumber': instance.mobileNumber,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'isArtist': instance.isArtist,
    };
