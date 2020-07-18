import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:pratichabi/models/message.dart';
import 'package:pratichabi/resources/firebase_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pratichabi/models/user.dart';
import 'package:pratichabi/provider/image_upload_provider.dart';

class FirebaseRepository{
  FirebaseMethods _firebaseMethods = FirebaseMethods(); 

  Future<FirebaseUser> getCurrentUser() => _firebaseMethods.getCurrentUser();

  Future<FirebaseUser> signIn() => _firebaseMethods.signIn();

  Future<bool> authenticateUser(FirebaseUser user)=> _firebaseMethods.authenticateUser(user);

  Future<void> addDataToDb(FirebaseUser user)=> _firebaseMethods.addDataToDb(user);

  Future<void> signOut() => _firebaseMethods.signOut();

  Future<List<User>> fetchAllUsers(FirebaseUser user)=> _firebaseMethods.fetchAllUsers(user);

  Future<void> addMessageToDb(Message message,User sender,User reciever)=> _firebaseMethods.addMessageToDb(message,sender,reciever);

  void uploadImage({
   @required File image,
   @required String recieverId,
   @required String senderId,
   @required ImageUploadProvider imageUploadProvider
  })=>
  _firebaseMethods.uploadImage(
    image,
    recieverId,
    senderId,
    imageUploadProvider
  );
}