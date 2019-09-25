import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String image;
  String name;
  String email;
  
  String id;
  String mobileNumber;
  double latitude, longitude;
  bool isArtist;
  User(this.name, this.email, this.image, this.id, this.mobileNumber,
      this.isArtist, this.latitude, this.longitude);

  User.named(
      {this.name,
      this.email,
      this.image,
      this.id,
      this.mobileNumber,
      this.isArtist,
      this.latitude,
      this.longitude});

  Map<String, dynamic> toJson() => _$UserToJson(this);

  factory User.fromJson(json) => _$UserFromJson(json);

  String get profilePic =>
      image ??
      "https://media.gettyimages.com/photos/khalid-performs-onstage-at-sony-event-during-sxsw-at-trinity-on-15-picture-id932685892?s=2048x2048";
}
