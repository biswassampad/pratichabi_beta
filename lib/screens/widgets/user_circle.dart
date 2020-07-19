import 'package:flutter/material.dart';
import 'package:pratichabi/provider/user_provider.dart';
import 'package:pratichabi/utils/universal_variables.dart';
import 'package:pratichabi/utils/utils.dart';
import 'package:provider/provider.dart';

class UserCircle extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
     final UserProvider userProvider = Provider.of<UserProvider>(context);
  
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
                Utils.getInitials(userProvider.getUser.name),
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
