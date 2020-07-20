import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmeringLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height:50,
      width:50,
      child:Shimmer.fromColors(
        child:Image.asset("assets/icons/logo.png"), 
        baseColor:Colors.yellow[700], 
        highlightColor: Colors.yellowAccent
        )
    );
  }
}