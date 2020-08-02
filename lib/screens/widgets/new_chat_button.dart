import 'package:flutter/material.dart';
import 'package:senger/utils/universal_variables.dart';

class NewChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration :  BoxDecoration(
        gradient: UniversalVaribales.fabGradient,
        borderRadius: BorderRadius.circular(50)
      ),
      child:Icon(
        Icons.add_comment,
        color:Colors.white,
        size:25
      ),
      padding: EdgeInsets.all(15),
    );
  }
}