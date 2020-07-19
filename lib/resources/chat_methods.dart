import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:pratichabi/constants/strings.dart';
import 'package:pratichabi/models/contact.dart';
import 'package:pratichabi/models/message.dart';
import 'package:pratichabi/models/user.dart';

class ChatMethods {
  static final Firestore _firestore = Firestore.instance;

  final CollectionReference _messageCollection =
      _firestore.collection(MESSAGES_COLLECTION);

  final CollectionReference _userCollection =
      _firestore.collection(USERS_COLLECTION);

  Future<void> addMessageToDb(
      Message message, User sender, User receiver) async {
    var map = message.toMap();

    await _messageCollection
        .document(message.senderId)
        .collection(message.recieverId)
        .add(map);

    addToContacts(senderId: message.senderId, recieverId: message.recieverId);

    return await _messageCollection
        .document(message.recieverId)
        .collection(message.senderId)
        .add(map);
  }

  DocumentReference getContactsDocument({String of, String forContact}) =>
      _userCollection
          .document(of)
          .collection(CONTACTS_COLLECTION)
          .document(forContact);

  addToContacts({String senderId, String recieverId}) async {
    Timestamp currentTime = Timestamp.now();

    await addToSenderContacts(senderId, recieverId, currentTime);
    await addToReceiverContacts(senderId, recieverId, currentTime);
  }

  Future<void> addToSenderContacts(
    String senderId,
    String recieverId,
    currentTime,
  ) async {
    DocumentSnapshot senderSnapshot =
        await getContactsDocument(of: senderId, forContact: recieverId).get();

    if (!senderSnapshot.exists) {
      //does not exists
      Contact receiverContact = Contact(
        uid: recieverId,
        addedOn: currentTime,
      );

      var receiverMap = receiverContact.toMap(receiverContact);

      await getContactsDocument(of: senderId, forContact: recieverId)
          .setData(receiverMap);
    }
  }

  Future<void> addToReceiverContacts(
    String senderId,
    String recieverId,
    currentTime,
  ) async {
    DocumentSnapshot receiverSnapshot =
        await getContactsDocument(of: recieverId, forContact: senderId).get();

    if (!receiverSnapshot.exists) {
      //does not exists
      Contact senderContact = Contact(
        uid: senderId,
        addedOn: currentTime,
      );

      var senderMap = senderContact.toMap(senderContact);

      await getContactsDocument(of: recieverId, forContact: senderId)
          .setData(senderMap);
    }
  }

  void setImageMsg(String url, String recieverId, String senderId) async {
    Message message;

    message = Message.imageMessage(
        message: "IMAGE",
        recieverId: recieverId,
        senderId: senderId,
        photoUrl: url,
        timestamp: Timestamp.now(),
        type: 'image');

    // create imagemap
    var map = message.toImageMap();

    // var map = Map<String, dynamic>();
    await _messageCollection
        .document(message.senderId)
        .collection(message.recieverId)
        .add(map);

    _messageCollection
        .document(message.recieverId)
        .collection(message.senderId)
        .add(map);
  }

  Stream<QuerySnapshot> fetchContacts({String userId}) => _userCollection
      .document(userId)
      .collection(CONTACTS_COLLECTION)
      .snapshots();

  Stream<QuerySnapshot> fetchLastMessageBetween({
    @required String senderId,
    @required String recieverId,
  }) =>
      _messageCollection
          .document(senderId)
          .collection(recieverId)
          .orderBy("timestamp")
          .snapshots();
}