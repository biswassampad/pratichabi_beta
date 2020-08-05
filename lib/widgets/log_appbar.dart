import 'package:flutter/material.dart';
import 'package:senger/screens/widgets/shimmering_logo.dart';
import 'package:senger/widgets/appbarr.dart';

class LogAppBar extends StatelessWidget implements PreferredSizeWidget {

  final  dynamic title;
  final List<Widget> actions;


  const LogAppBar({
    Key key,
    @required this.title,
    @required this.actions
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: title is String ? Text(
        title,
        style:TextStyle(
          color:Colors.white,
          fontWeight: FontWeight.bold
        ),
        ): title,
      actions: actions, 
      leading: ShimmeringLogo(), 
      centerTitle: true
      );
  }

  @override
  Size get preferredSize => const  Size.fromHeight(kToolbarHeight+10);
}