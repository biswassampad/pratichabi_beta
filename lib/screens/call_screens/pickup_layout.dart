import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pratichabi/models/call.dart';
import 'package:pratichabi/provider/user_provider.dart';
import 'package:pratichabi/resources/call_methods.dart';
import 'package:pratichabi/screens/call_screens/pickup_screen.dart';
import 'package:provider/provider.dart';

class PickUpLayout extends StatelessWidget {

  final Widget scaffold;
  final CallMethods callMethods = CallMethods();

  PickUpLayout({
   @required this.scaffold
  });

  @override
  Widget build(BuildContext context) {

    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return (userProvider != null && userProvider.getUser != null) ?
     StreamBuilder<DocumentSnapshot>(
      stream: callMethods.callStream(uid:userProvider.getUser.uid),
      builder: (context,snapshot){
        if(snapshot.hasData && snapshot.data.data != null){
          Call call = Call.fromMap(snapshot.data.data);

          if(!call.hasDialled){
            return PickupScreen(call: call);  
          }
          return scaffold;
        }

        return scaffold;
      },
    ):Scaffold(
      body:Center(
      child:CircularProgressIndicator()
      )
    );
  }
}