import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:senger/constants/menu.dart';
import 'package:senger/constants/strings.dart';
import 'package:senger/models/message.dart';
import 'package:senger/models/user.dart';
import 'package:senger/provider/image_upload_provider.dart';
import 'package:senger/provider/user_provider.dart';
import 'package:senger/resources/storage_methods.dart';
import 'package:senger/resources/chat_methods.dart';
import 'package:senger/resources/auth_methods.dart';
import 'package:senger/screens/widgets/cached_image.dart';
import 'package:senger/screens/call_screens/pickup_layout.dart';
import 'package:senger/utils/call_utilities.dart';
import 'package:senger/utils/permissions.dart';
import 'package:senger/utils/universal_variables.dart';
import 'package:senger/utils/utils.dart';
import 'package:senger/widgets/appbarr.dart';
import 'package:senger/widgets/custom_tile.dart';
import 'package:provider/provider.dart';

class MessageScreen extends StatefulWidget {
  final User reciever;

  MessageScreen({this.reciever});

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  
  TextEditingController textFieldController = TextEditingController();
  final AuthMethods _authMethods = AuthMethods();
   final StorageMethods _storageMethods = StorageMethods();
    final ChatMethods _chatMethods = ChatMethods();
    final UserProvider userProvider = UserProvider();

  ImageUploadProvider _imageUploadProvider;

  User sender;

  String _currentUserId;

  FocusNode textFieldFocus = FocusNode();

  bool isWriting = false;
  bool showEmojiPicker = false;
  bool isDownloading = false;
  

  @override
  void initState() {
    super.initState();

    _authMethods.getCurrentUser().then((user) {
      _currentUserId = user.uid;

      setState(() {
        sender = User(
          uid: user.uid,
          name: user.displayName,
          profilePhoto: user.photoUrl,
        );
      });
    });
  }

  showKeyboard()=>textFieldFocus.requestFocus();
  hideKeyboard()=>textFieldFocus.unfocus();

  hideEmojiContainer(){
    setState(() {
      showEmojiPicker = false;
    });
  }

  showEmojiContainer(){
    setState(() {
      showEmojiPicker = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    return PickUpLayout(
          scaffold: Scaffold(
        backgroundColor: Colors.white,
        appBar: customAppBar(context),
        body: Column(
          children: <Widget>[
            Flexible(
              child: messageList(),
            ),
            // _imageUploadProvider.getViewState == ViewState.LOADING ? 
            // Container(
            //   alignment: Alignment.centerRight,
            //   margin: EdgeInsets.only(right:15),
            //   child: CircularProgressIndicator()
            //   ): Container(),
            chatControls(),
            showEmojiPicker ? Container(child:emojiContainer()):Container()
          ],
        ),
      ),
    );
  }

  emojiContainer(){
    return EmojiPicker(
      bgColor: Colors.white,
      indicatorColor: UniversalVaribales.blueColor,
      rows:3,
      columns:7,
      onEmojiSelected: (emoji,category){
          setState(() {
            isWriting = true;
          });

          textFieldController.text = textFieldController.text + emoji.emoji;
      },
    );
  }

   pickImage({@required ImageSource source}) async{
      File selctedImage = await Utils().pickImage(source:source);
      _storageMethods.uploadImage(
        image:selctedImage,
        recieverId:widget.reciever.uid,
        senderId:_currentUserId,
        imageUploadProvider:_imageUploadProvider,
        type:'image'
      );
    }

  pickFile() async{
    File file = await FilePicker.getFile();
    print(file);
     _storageMethods.uploadImage(
        image:file,
        recieverId:widget.reciever.uid,
        senderId:_currentUserId,
        imageUploadProvider:_imageUploadProvider,
        type:'file'
      );
  }

  Widget messageList() {
    print('new message fetched');
    return StreamBuilder(
      stream: Firestore.instance
          .collection(MESSAGES_COLLECTION)
          .document(_currentUserId)
          .collection(widget.reciever.uid)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: snapshot.data.documents.length,
          reverse: true,
          itemBuilder: (context, index) {
            // mention the arrow syntax if you get the time
            return chatMessageItem(snapshot.data.documents[index]);
          },
        );
      },
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    Message _message = Message.fromMap(snapshot.data);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        alignment: _message.senderId == _currentUserId
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: _message.senderId == _currentUserId
            ? senderLayout(_message)
            : recieverLayout(_message),
      ),
    );
  }

  Widget senderLayout(Message message) {
    Radius messageRadius = Radius.circular(10);

    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: UniversalVaribales.senderColor,
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: getMessage(message),
      ),
    );
  }

  getMessage(Message message) {
   return message.type != MESSAGE_TYPE_IMAGE ?

  Text(
      message.message,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
    ) : message.photoUrl != null ? CachedImage(message.photoUrl,height:250,width:250,radius: 10,) 
    : Text('Image file is broken');
  }

  Widget recieverLayout(Message message) {
    Radius messageRadius = Radius.circular(10);

    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        gradient: UniversalVaribales.msgGradient,
        borderRadius: BorderRadius.only(
          bottomRight: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: getMessage(message),
      ),
    );
  }

  Widget chatControls() {
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    addMediaModal(context) {
      showModalBottomSheet(
          context: context,
          elevation: 0,
          backgroundColor: Colors.white,
          builder: (context) {
            return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: <Widget>[
                      FlatButton(
                        child: Icon(
                          Icons.close,
                          color: Colors.yellow[700],
                        ),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Content and tools",
                            style: TextStyle(
                                color: Colors.yellow[900],
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView(
                    children: <Widget>[
                      ModalTile(
                        title: "Media",
                        subtitle: "Share Photos and Video",
                        icon: Icons.image,
                        onTap:()=>{pickImage(
                           source:ImageSource.gallery,
                          ),
                          Navigator.maybePop(context)
                          
                          }
                      ),
                      ModalTile(
                          title: "File",
                          subtitle: "Share files",
                          icon: Icons.tab,
                          onTap:()=>{
                            pickFile(),
                            Navigator.maybePop(context)
                            }
                          
                          ),
                      ModalTile(
                          title: "Contact",
                          subtitle: "Share contacts",
                          icon: Icons.contacts),
                      ],
                  ),
                ),
              ],
            );
          });
    }

    sendMessage() {
      var text = textFieldController.text;

      Message _message = Message(
        recieverId: widget.reciever.uid,
        senderId: sender.uid,
        message: text,
        timestamp: Timestamp.now(),
        type: 'text',
      );

      setState(() {
        isWriting = false;
      });

      textFieldController.text = "";

      _chatMethods.addMessageToDb(_message, sender, widget.reciever);
    }

   

    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => addMediaModal(context),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                gradient: UniversalVaribales.fabGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Stack(
                children: <Widget>[
                  TextField(
                    onTap: (){
                      hideEmojiContainer();
                    },
                controller: textFieldController,
                focusNode: textFieldFocus,
                style: TextStyle(
                  color: Colors.black,
                ),
                onChanged: (val) {
                  (val.length > 0 && val.trim() != "")
                      ? setWritingTo(true)
                      : setWritingTo(false);
                },
                decoration: InputDecoration(
                  hintText: "Type a message",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(50.0),
                      ),
                      borderSide: BorderSide.none),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
                ],
            ),
          ),
          isWriting
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: IconButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onPressed: (){
                    if(!showEmojiPicker){
                      hideKeyboard();
                      showEmojiContainer();
                    }else{
                      showKeyboard();
                      hideEmojiContainer();
                    }
                  },
                  icon: Icon(Icons.face,color: UniversalVaribales.gradientColorEnd),
                ),
                ),
          isWriting ? Container() : GestureDetector(
            onTap: ()=>pickImage(
              source:ImageSource.camera
              ),
            child: Icon(Icons.camera_alt,color: UniversalVaribales.gradientColorEnd,)
            ),
          isWriting
              ? Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      gradient: UniversalVaribales.fabGradient,
                      shape: BoxShape.circle),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 15,
                    ),
                    onPressed: () => sendMessage(),
                  ))
              : Container()
        ],
      ),
    );
  }

  CustomAppBar customAppBar(context) {
    return CustomAppBar(
      leading: Row(
        children: <Widget>[
          IconButton(
        icon: Icon(
          Icons.arrow_back,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
        ],
      ),
      centerTitle: false,
      title: Text(
        widget.reciever.name,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.video_call,
          ),
          onPressed: () async=>await Permissions.cameraAndMicrophonePermissionsGranted() ?
           CallUtils.dial(
            from: sender,
            to:widget.reciever,
            context: context
          ) : {},
        ),
        PopupMenuButton<String>(
          onSelected:choiceActions,
          itemBuilder: (BuildContext context){
            return Constants.choices.map((String choice){
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        )
      ],
    );
  }

  void choiceActions(String choice){
    print('working $choice');
  }
}

class ModalTile extends StatelessWidget {

  final String title;
  final String subtitle;
  final IconData icon;
  final Function onTap;

  const ModalTile({
    @required this.title,
    @required this.subtitle,
    @required this.icon,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
        mini: false,
        onTap: onTap,
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: UniversalVaribales.recieverColor,
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: Colors.yellow,
            size: 38,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: UniversalVaribales.greyColor,
            fontSize: 14,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}