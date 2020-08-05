
import 'package:cloud_firestore/cloud_firestore.dart';


class Contact{
  String uid;
  bool status;
  Timestamp addedOn;

  Contact({
    this.uid,
    this.status,
    this.addedOn
  });

  // up
  Map toMap(Contact contact){
    var data = Map<String,dynamic>();
    data['contact_id'] = contact.uid;
    data['added_on'] = contact.addedOn;
    data['status'] = 'Requested';
     return data;
  }

// down
  Contact.fromMap(Map<String, dynamic> mapData){
    this.uid = mapData['contact_id'];
    this.addedOn = mapData['added_on'];
    this.status = mapData['status'];
  }
}