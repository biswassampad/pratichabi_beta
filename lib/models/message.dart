import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderId;
  String recieverId;
  String type;
  String message;
  Timestamp timestamp;
  String photoUrl;
  bool status = true;

  Message({
    this.senderId,
    this.recieverId,
    this.type,
    this.message,
    this.timestamp,
    this.status
  });
  // will be called only in messages contain images 
  Message.imageMessage({
    this.senderId,
    this.recieverId,
    this.message,
    this.type,
    this.timestamp,
    this.photoUrl,
    this.status
  });

  Map toMap(){
    var map =   Map<String,dynamic>();
    map['senderId'] = this.senderId;
    map['recieverId'] = this.recieverId;
    map['type'] = this.type;
    map['message'] = this.message;
    map['timestamp'] = this.timestamp;
    map['status'] = this.status;
    return map;
  }

  Map toImageMap(){
     var map =   Map<String,dynamic>();
    map['senderId'] = this.senderId;
    map['recieverId'] = this.recieverId;
    map['type'] = this.type;
    map['message'] = this.message;
    map['timestamp'] = this.timestamp;
    map['photoUrl'] = this.photoUrl;
    map['status'] = this.status;
    return map;
  }

  Message.fromMap(Map<String,dynamic> map){
      this.senderId = map['senderId'];
      this.recieverId = map['recieverId'];
      this.type = map['type'];
      this.message = map['message'];
      this.timestamp = map['timeStamp'];
      this.photoUrl = map['photoUrl'];
      this.status = map['status'];
  }

}