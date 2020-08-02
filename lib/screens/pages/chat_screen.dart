import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:senger/models/contact.dart';
import 'package:senger/provider/user_provider.dart';
import 'package:senger/resources/chat_methods.dart';
import 'package:senger/screens/widgets/contact_view.dart';
import 'package:senger/screens/widgets/quite_box.dart';
import 'package:senger/screens/widgets/shrimmering_logo_two.dart';
import 'package:senger/screens/widgets/user_circle.dart';
import 'package:senger/widgets/appbarr.dart';
import 'package:provider/provider.dart';
import 'package:senger/widgets/log_appbar.dart';

class ChatScreen extends StatelessWidget{

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      appBar:LogAppBar(
        title:UserCircle(),
        actions:<Widget>[
        IconButton(icon: Icon(Icons.add_comment,color:Colors.white), onPressed: (){
          Navigator.pushNamed(context, '/search_screen');
        }),
      ],
      ), 
      body: ChatListContainer(),
    );
  }
}

class ChatListContainer extends StatelessWidget {

  final ChatMethods _chatMethods = ChatMethods();

  @override
  Widget build(BuildContext context) {

    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Container(
      child:StreamBuilder<QuerySnapshot>(
        stream: _chatMethods.fetchContacts(userId: userProvider.getUser.uid),
        builder: (context,snapshot){

          if(snapshot.hasData){
            var docList = snapshot.data.documents;

            if(docList.isEmpty){
              return QuietBox(
                 header: "This is where your all chats will show", 
                bodytext: "Send messages to your friends and famiily without any extra cost"
              );
            }
            return ListView.builder(
            padding:EdgeInsets.all(10),
            itemCount:docList.length,
            itemBuilder: (context,index){
            Contact  contact  = Contact.fromMap(docList[index].data);

            return ContactView(contact);
            // return ContactView();
          },
        );
          }
            return Center(child: CircularProgressIndicator(
              backgroundColor: Colors.yellow[300],
            ),);
        },
      )
    );
  }
}

