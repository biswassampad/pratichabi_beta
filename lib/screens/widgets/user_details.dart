import 'package:flutter/material.dart';
import 'package:senger/models/user.dart';
import 'package:senger/provider/user_provider.dart';
import 'package:senger/screens/widgets/cached_image.dart';
import 'package:provider/provider.dart';

class UserDetailsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final User user = userProvider.getUser;

    return Container(
      padding:EdgeInsets.symmetric(vertical: 20,horizontal: 20),
      child: Row(
        children: <Widget>[
          CachedImage(user.profilePhoto,isRound: true,radius: 50,),
          SizedBox(width: 15,),
          Column(
            crossAxisAlignment:CrossAxisAlignment.start ,
            children: <Widget>[
              Text(
                user.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color:Colors.white
                ),
              ),
              SizedBox(height:10),
              Text(
                user.email,
                style: TextStyle(fontSize: 14,color:Colors.white),
              )
            ],
          )
        ],
      ),  
    );
  }
}