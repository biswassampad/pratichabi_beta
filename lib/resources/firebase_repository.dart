import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:senger/models/message.dart';
import 'package:senger/resources/firebase_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:senger/models/user.dart';
import 'package:senger/provider/image_upload_provider.dart';

class FirebaseRepository{
  FirebaseMethods _firebaseMethods = FirebaseMethods(); 

  Future<FirebaseUser> getCurrentUser() => _firebaseMethods.getCurrentUser();

  Future<FirebaseUser> signIn() => _firebaseMethods.signIn();

  Future<User> getUserDetails() => _firebaseMethods.getUserDetails();

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