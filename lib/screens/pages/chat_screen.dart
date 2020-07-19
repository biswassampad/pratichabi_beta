import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pratichabi/models/contact.dart';
import 'package:pratichabi/provider/user_provider.dart';
import 'package:pratichabi/resources/chat_methods.dart';
import 'package:pratichabi/screens/widgets/contact_view.dart';
import 'package:pratichabi/screens/widgets/new_chat_button.dart';
import 'package:pratichabi/screens/widgets/quite_box.dart';
import 'package:pratichabi/screens/widgets/user_circle.dart';
import 'package:pratichabi/utils/universal_variables.dart';
import 'package:pratichabi/widgets/appbarr.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget{

  CustomAppBar customAppBar(BuildContext context){
    return CustomAppBar(
      title: UserCircle(), 
      actions: <Widget>[
        IconButton(icon: Icon(Icons.search,color:Colors.white), onPressed: (){
          Navigator.pushNamed(context, '/search_screen');
        }),
        IconButton(icon:Icon(Icons.more_vert,color:Colors.white),onPressed: null,)
      ], 
      leading: IconButton(icon: Icon(Icons.notifications,color: Colors.white,), onPressed: null), 
      centerTitle: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVaribales.blackColor,
      appBar:customAppBar(context),
      floatingActionButton: NewChatButton(),
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
              return QuietBox();
            }
            return ListView.builder(
          padding:EdgeInsets.all(10),
          itemCount:docList.length,
          itemBuilder: (context,index){
            Contact  contact  = Contact.fromMap(docList[index].data);

            return ContactView(contact:contact);
            // return ContactView();
          },
        );
          }
            return Center(child: CircularProgressIndicator(),);
        },
      )
    );
  }
}

