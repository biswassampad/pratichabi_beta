import 'package:flutter/material.dart';
import 'package:senger/screens/pages/search_screen.dart';
import 'package:senger/utils/universal_variables.dart';


class QuietBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child:Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child:Container(
            color:UniversalVaribales.separatorColor,
            padding:EdgeInsets.symmetric(vertical: 35,horizontal: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: <Widget>[
                Text(
                  "This is where all the contacts are listed.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30
                  ),
                ),
                Text(
                  "Search for your friends and family to start calling or chatting to them",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.normal,
                    fontSize: 18
                  ),
                ),
                SizedBox(height:25),
                FlatButton(
                  color:UniversalVaribales.lightBlueColor,
                  child: Text("START SEARCHING"),
                  onPressed: ()=>Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context)=>SearchScreen(),
                      )
                    ),
                ),
              ],
            ),

          )
        )
    );
  }
}