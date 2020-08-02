import 'package:flutter/material.dart';
import 'package:senger/constants/strings.dart';
import 'package:senger/models/call.dart';
import 'package:senger/models/logs.dart';
import 'package:senger/resources/call_methods.dart';
import 'package:senger/screens/call_screens/call_screen.dart';
import 'package:senger/screens/widgets/cached_image.dart';
import 'package:senger/utils/permissions.dart';

class PickupScreen extends StatefulWidget {

  final Call call;

  PickupScreen({
    @required this.call,
    
  });

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  final CallMethods callMethods = CallMethods();
  bool isCallMissed = true ;
  // initializes and adds call logs to the database
  addToLocalStorage({@required String callStatus}){
    print('call status');
    print(callStatus);
    Log log = Log(
      callerName:  widget.call.callerName,
      callerPic:  widget.call.callerPic,
      receiverName: widget.call.recieverName,
      receiverPic: widget.call.recieverPic,
      timestamp: DateTime.now().toString(),
      callStatus: callStatus
    );
  }

  @override
  void dispose() {
    super.dispose();
      if(isCallMissed){
      print('record added');
      addToLocalStorage(callStatus: CALL_STATUS_MISSED);
    }
  }

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
              widget.call.callerPic,
              isRound: true,
              radius:180
            ),
            SizedBox(
              height:15
            ),
            Text(widget.call.callerName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
            ),
            SizedBox(height: 75,),
            Row(
              mainAxisAlignment:MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.call_end),
                  color:Colors.redAccent, 
                  onPressed: ()async{
                    isCallMissed = false;
                    addToLocalStorage(callStatus: CALL_STATUS_REJECTED);
                    await callMethods.endCall(call:widget.call);
                }),
                SizedBox(width:25),
                IconButton(icon: Icon(Icons.call),
                color:Colors.green, 
                onPressed: () async{
                  isCallMissed = false;
                  addToLocalStorage(callStatus: CALL_STATUS_RECIEVED);
                  await Permissions.cameraAndMicrophonePermissionsGranted()?
                 Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>CallScreen(call:widget.call)
                  )
                  ) :{};
                },
                )
              ],
            )
          ],
        ),
      )
    );
  }
}