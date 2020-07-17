import 'package:flutter/material.dart';
import 'package:pratichabi/resources/firebase_repository.dart';
import 'package:pratichabi/utils/universal_variables.dart';
import 'package:pratichabi/utils/utils.dart';
import 'package:pratichabi/widgets/appbarr.dart';
import 'package:pratichabi/widgets/custom_tile.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

final FirebaseRepository _repository = FirebaseRepository();

class _ChatScreenState extends State<ChatScreen> {

  String currentUserId;
  String initials;

  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((user) {
     setState(() {
        currentUserId = user.uid;
        initials = Utils.getInitials(user.displayName);
     });
    });
  }

  CustomAppBar customAppBar(BuildContext context){
    return CustomAppBar(
      title: UserCircle(initials), 
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
      body: ChatListContainer(currentUserId),
    );
  }
}

class UserCircle extends StatelessWidget {
  
  final String text;

  UserCircle(this.text);
  
  @override
  Widget build(BuildContext context) {
    return Container(
        height:40,
        width:40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color:UniversalVaribales.separatorColor,
        ),
        child:Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(
                text,
                style:TextStyle(
                  fontWeight: FontWeight.bold,
                  color:UniversalVaribales.lightBlueColor,
                  fontSize: 13
                )
              ),
            ),

            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height:12,
                width:12,
                decoration: BoxDecoration(
                  shape:BoxShape.circle,
                  border:Border.all(
                    color:UniversalVaribales.blackColor,
                    width:2,
                  ),
                  color:UniversalVaribales.onlineDotColor,
                ),
              ),
            )
          ],
        )
    );
  }
}


class NewChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration :  BoxDecoration(
        gradient: UniversalVaribales.fabGradient,
        borderRadius: BorderRadius.circular(50)
      ),
      child:Icon(
        Icons.add_comment,
        color:Colors.white,
        size:25
      ),
      padding: EdgeInsets.all(15),
    );
  }
}

class ChatListContainer extends StatefulWidget {

  final String currentUserId;

  ChatListContainer(this.currentUserId);

  @override
  _ChatListContainerState createState() => _ChatListContainerState();
}

class _ChatListContainerState extends State<ChatListContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child:ListView.builder(
        padding:EdgeInsets.all(10),
        itemCount:2,
        itemBuilder: (context,index){
          return CustomTile(
            mini:false,
            onTap: null,
            title:Text('Biswas',style: TextStyle(color:Colors.white,fontFamily: "Arial",fontSize: 19),),
            subtitle: Text('Hello',style:TextStyle(
              color:UniversalVaribales.greyColor,
              fontSize: 14,
            )),
            leading:Container(
              constraints: BoxConstraints(maxHeight: 60,maxWidth: 60),
              child: Stack(children: <Widget>[
                CircleAvatar(
                  maxRadius: 30,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2018/01/15/07/51/woman-3083377_1280.jpg'),
                ),
                Align(
                  alignment:Alignment.bottomRight,
                  child: Container(
                    height:15,
                    width:15,
                    decoration:BoxDecoration(
                      shape:BoxShape.circle,
                      color:UniversalVaribales.onlineDotColor,
                      border:Border.all(
                        color:UniversalVaribales.blackColor,
                        width:2,

                      )
                    )
                  ),
                )
              ],),
            )
          );
        },
      )
    );
  }
}