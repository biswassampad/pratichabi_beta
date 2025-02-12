import 'package:flutter/material.dart';

class UniversalVaribales{
  static final Color blueColor = Color(0xff2b9ed4);
  static final Color blackColor = Colors.yellow[700];
  static final Color greyColor = Color(0xff8f8f8f);
  static final Color userCircleBackground = Color(0xff2b2b33);
  static final Color onlineDotColor = Color(0xff46dc64);
  static final Color lightBlueColor = Color(0xff0077d7);
  static final Color separatorColor = Color(0xff272c35);

  static final Color gradientColorStart = Colors.yellow[700];
  static final Color gradientColorEnd = Colors.yellow[900];

  static final Color gradientStartMesage = Colors.green[300];
  static final Color gradientEndMessage = Colors.green[700];

  static final Color senderColor = Color(0xff2b343b);
  static final Color recieverColor = Color(0xff1e2225);

  static final Gradient fabGradient = LinearGradient(
    colors:[gradientColorStart,gradientColorEnd],
    begin:Alignment.topLeft,
    end:Alignment.bottomRight
  );

  static final Gradient msgGradient = LinearGradient(
    colors:[gradientColorStart,gradientEndMessage],
    begin:Alignment.topLeft,
    end:Alignment.bottomRight
  );
}