import 'package:flutter/material.dart';
import 'package:pratichabi/models/call.dart';
import 'package:pratichabi/resources/call_methods.dart';

class CallScreen extends StatefulWidget {
  
  final Call call;
    final CallMethods callMethods = CallMethods();
  CallScreen({
    @required this.call
  });
  
  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Call has been made",
              ),
              MaterialButton(
                color:Colors.red,
                child:Icon(Icons.call_end,color:Colors.white,),
                onPressed: (){
                    
                },
              )
            ],
          ),
        )
    );
  }
}