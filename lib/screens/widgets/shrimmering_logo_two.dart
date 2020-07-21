import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmeringLogoTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height:30,
      width:30,
      child:Shimmer.fromColors(
        child:Image.asset("assets/icons/logo.png"), 
        baseColor:Colors.white, 
        highlightColor: Colors.black38
        )
    );
  }
}