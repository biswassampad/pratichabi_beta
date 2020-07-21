import 'package:flutter/material.dart';
import 'package:senger/models/call.dart';
import 'package:senger/resources/call_methods.dart';
import 'package:senger/screens/call_screens/call_screen.dart';
import 'package:senger/screens/widgets/cached_image.dart';
import 'package:senger/utils/permissions.dart';

class PickupScreen extends StatelessWidget {

  final Call call;
  final CallMethods callMethods = CallMethods();

  PickupScreen({
    @required this.call,
    
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        alignment: Alignment.center,
        padding:EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Incoming Video Call..",
              style:TextStyle(
                fontSize: 30
              )
            ),
            SizedBox(
              height: 30,
            ),
            CachedImage(
              call.callerPic,
              isRound: true,
              radius:180
            ),
            SizedBox(
              height:15
            ),
            Text(call.callerName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
            ),
            SizedBox(height: 75,),
            Row(
              mainAxisAlignment:MainAxisAlignment.center,
              children: <Widget>[
                IconButton(icon: Icon(Icons.call_end),color:Colors.redAccent, onPressed: ()async{
                    await callMethods.endCall(call:call);
                }),
                SizedBox(width:25),
                IconButton(icon: Icon(Icons.call),
                color:Colors.green, 
                onPressed: () async => await Permissions.cameraAndMicrophonePermissionsGranted()? Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>CallScreen(call:call)
                  )
                  ) :{},
                )
              ],
            )
          ],
        ),
      )
    );
  }
}