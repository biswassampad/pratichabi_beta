import 'dart:math';

import 'package:flutter/material.dart';
import 'package:senger/models/call.dart';
import 'package:senger/models/user.dart';
import 'package:senger/resources/call_methods.dart';
import 'package:senger/screens/call_screens/call_screen.dart';

class CallUtils{

  static final CallMethods callMethods = CallMethods();

  static dial({User from, User to,context}) async{
    Call call = Call(
     callerId : from.uid, 
    callerName : from.name,
    callerPic: from.profilePhoto,
    recieverId: to.uid,
    recieverName: to.name,
    recieverPic: to.profilePhoto,
    channelId: Random().nextInt(10000).toString(),
    );

    bool callMade = await callMethods.makeCall(call:call);

    call.hasDialled = true;

    if(callMade){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context)=>CallScreen(call: call))
      );
    }
    }

}