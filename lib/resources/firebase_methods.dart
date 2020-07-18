
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pratichabi/constants/strings.dart';
import 'package:pratichabi/models/message.dart';
import 'package:pratichabi/models/user.dart';
import 'package:pratichabi/utils/utils.dart';
import 'package:pratichabi/provider/image_upload_provider.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final Firestore firestore = Firestore.instance;
  static final CollectionReference _userCollection = firestore.collection(USERS_COLLECTION);
  

  StorageReference _storageReference;

  //user class
  User user = User();

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
  }

  Future<FirebaseUser> signIn() async {
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: _signInAuthentication.accessToken,
        idToken: _signInAuthentication.idToken);

    FirebaseUser user = await _auth.signInWithCredential(credential);
    return user;
  }

  Future<bool> authenticateUser(FirebaseUser user) async {
    QuerySnapshot result = await firestore
        .collection(USERS_COLLECTION)
        .where(EMAIL_VALUE, isEqualTo: user.email)
        .getDocuments();

    final List<DocumentSnapshot> docs = result.documents;

    //if user is registered then length of list > 0 or else less than 0
    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(FirebaseUser currentUser) async {
    String username = Utils.getUsername(currentUser.email);

    user = User(
        uid: currentUser.uid,
        email: currentUser.email,
        name: currentUser.displayName,
        username: username);
        profilePhoto: currentUser.photoUrl;

    firestore
        .collection(USERS_COLLECTION)
        .document(currentUser.uid)
        .setData(user.toMap(user));
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    return await _auth.signOut();
  }

  Future<List<User>> fetchAllUsers(FirebaseUser currentUser) async {
    List<User> userList = List<User>();

    QuerySnapshot querySnapshot =
        await firestore.collection(USERS_COLLECTION).getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != currentUser.uid) {
        userList.add(User.fromMap(querySnapshot.documents[i].data));
      }
    }
    return userList;
  }

  Future<void> addMessageToDb(Message message,User sender,User reciever) async{
      var map = message.toMap();

      await firestore
      .collection(MESSAGES_COLLECTION)
      .document(message.senderId)
      .collection(message.recieverId)
      .add(map);

      return await firestore
      .collection(MESSAGES_COLLECTION)
      .document(message.recieverId)
      .collection(message.senderId)
      .add(map);
    }
  
  Future<String> uploadImageToStorage(File image) async{
    try{
      _storageReference = FirebaseStorage.instance.ref().child('${DateTime.now().microsecondsSinceEpoch}');

    StorageUploadTask _storageUploadTask = _storageReference.putFile(image);

    var url =await ( await  _storageUploadTask.onComplete).ref.getDownloadURL();
    print(url);
    return url;
    }catch(e){
      return null;
    }
  }
  void setImageMessage(String url,String recievedId, String senderId)async{

    Message _message;
    _message  = Message.imageMessage(
      message: "Image",
      recieverId: recievedId,
      senderId : senderId,
      photoUrl:  url,
      timestamp: Timestamp.now(),
      type: 'image'
    );

    var map = _message.toImageMap();

    // set the data to database
     await firestore
      .collection(MESSAGES_COLLECTION)
      .document(_message.senderId)
      .collection(_message.recieverId)
      .add(map);

      await firestore
      .collection(MESSAGES_COLLECTION)
      .document(_message.recieverId)
      .collection(_message.senderId)
      .add(map);
      
  }
  
  void uploadImage(File image,String recieverId,String senderId,ImageUploadProvider imageUploadProvider) async {
      imageUploadProvider.setToLoading();
     String url = await uploadImageToStorage(image);

      imageUploadProvider.setToIdle();
     setImageMessage(url,recieverId,senderId);
    }

    Future<User> getUserDetails() async{
      FirebaseUser currentUser = await getCurrentUser();

      DocumentSnapshot documentSnapshot =   await _userCollection.document(currentUser.uid).get();

      return User.fromMap(documentSnapshot.data);
    }
}