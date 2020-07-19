
import 'package:flutter/material.dart';
import 'package:pratichabi/models/contact.dart';
import 'package:pratichabi/models/user.dart';
import 'package:pratichabi/provider/user_provider.dart';
import 'package:pratichabi/resources/auth_methods.dart';
import 'package:pratichabi/resources/chat_methods.dart';
import 'package:pratichabi/screens/pages/message_screen.dart';
import 'package:pratichabi/screens/widgets/cached_image.dart';
import 'package:pratichabi/widgets/custom_tile.dart';
import 'package:provider/provider.dart';
import 'last_message_container.dart';
import 'online_indicator.dart';


class ContactView extends StatelessWidget {
  final Contact contact;
  final AuthMethods _authMethods = AuthMethods();

  ContactView({
    Key key, this.contact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _authMethods.getUserDetailsById(contact.uid),
      builder: (context,snapshot){
        if(snapshot.hasData){
          User user = snapshot.data; 

          return ViewModel(
            contact: user,
          );
        }
        return Center(child: CircularProgressIndicator(),);
      },
    );
  }
}

class ViewModel extends StatelessWidget {

  final User contact;
  final ChatMethods _chatMethods = ChatMethods();

  ViewModel({
    Key key, this.contact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return CustomTile(
      mini:false,
      onTap: ()=> Navigator.push(
        context, 
        MaterialPageRoute(builder: (context)=> MessageScreen(
          reciever:contact
        ))
        ),
      title:Text(
        contact?.name ?? "..",
      style: TextStyle(
        color:Colors.white,
        fontFamily: "Arial",
        fontSize: 19),
        ),
      subtitle: LastMessageContainer(
        stream: _chatMethods.fetchLastMessageBetween(
          senderId: userProvider.getUser.uid,
          recieverId: contact.uid
          )
      ),
      leading:Container(
        constraints: BoxConstraints(maxHeight: 60,maxWidth: 60),
        child: Stack(children: <Widget>[
         CachedImage(contact.profilePhoto,radius: 80,isRound: true,),
         OnlineDotIndicator(uid:contact.uid)
        ],),
      )
    );
  }
}