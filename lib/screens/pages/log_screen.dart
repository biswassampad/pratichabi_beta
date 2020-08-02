import 'package:flutter/material.dart';
import 'package:senger/models/logs.dart';
import 'package:senger/resources/localdb/repository/log_respository.dart';
import 'package:senger/screens/call_screens/pickup_layout.dart';
import 'package:senger/screens/widgets/log_list_container.dart';
import 'package:senger/widgets/log_appbar.dart';

class LogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PickUpLayout(
      scaffold: Scaffold(
        backgroundColor: Colors.white,
       appBar: LogAppBar(
        title:'Logs',
        actions:<Widget>[
        IconButton(icon: Icon(Icons.add_comment,color:Colors.white), onPressed: (){
          Navigator.pushNamed(context, '/search_screen');
        }),
      ],
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 15.0),
        child: LogListContainer(),
        ),
      )
      );
  }
}