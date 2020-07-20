import 'package:flutter/material.dart';
import 'package:pratichabi/resources/auth_methods.dart';
import 'package:pratichabi/screens/login_screen.dart';
import 'package:pratichabi/screens/widgets/shimmering_logo.dart';
import 'package:pratichabi/screens/widgets/user_details.dart';
import 'package:pratichabi/widgets/appbarr.dart';

class UserDetailsContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     signOut() async{
    final bool isLoggedOut = await AuthMethods().signOut();
    if(isLoggedOut){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginScreen()), (Route<dynamic> route) => false);
    }
  }
    return Container(
        margin: EdgeInsets.only(top:25),
        child: Column(
          children: <Widget>[
            CustomAppBar(
             title: ShimmeringLogo(),
             actions: <Widget>[
               FlatButton(
                 onPressed: ()=>signOut(),
                 child: Text('Sign Out',
                 style: TextStyle(color:Colors.white,fontSize: 12),
                 
                 )
                 )
             ], 
             leading: IconButton(
               icon:Icon(
                 Icons.arrow_back,
                 color:Colors.white
                 ),
                 onPressed: ()=>Navigator.maybePop(context),
                 ), 
              centerTitle: true),
              UserDetailsBody()
          ],
        ),
    );
  }

 
}