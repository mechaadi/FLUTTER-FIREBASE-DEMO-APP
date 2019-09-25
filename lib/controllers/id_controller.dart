import 'dart:convert';
import 'package:crypto/crypto.dart';

class IDController{

  static String hash(String val){
    var bytes = utf8.encode(val); // data being hashed
    var digest = sha1.convert(bytes);
    return digest.toString();
  }

}