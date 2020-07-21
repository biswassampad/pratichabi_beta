import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:senger/resources/auth_methods.dart';
import 'package:senger/screens/animations/fadeanimation.dart';
import 'package:senger/screens/home_screen.dart';
import 'package:senger/screens/widgets/shimmering_logo.dart';
import 'package:senger/utils/universal_variables.dart';
import 'package:shimmer/shimmer.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

  class LoginScreenState extends State<LoginScreen> {
    final AuthMethods _authMethods = AuthMethods();
    bool isLoginPressed = false;
    @override
      Widget build(BuildContext context) {
      return Scaffold(
      body: SafeArea(
        child: Container(
          color:Colors.white,
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  FadeAnimation(1, Row(
                    children: <Widget>[
                      Text("Welcome To ", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color:Colors.black
                  ),),
                  ShimmeringLogo(),
                  Text(" Senger", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color:Colors.yellow[700]
                  ),)
                    ],
                  )),
                  SizedBox(height: 20,),
                  FadeAnimation(1.2, Text("No Signup ,No Login , Just Two Tap Jump In.", 
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15
                  ),)),
                ],
              ),
              FadeAnimation(1.4, Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/1.png')
                  )
                ),
              )),
              Column(
                children: <Widget>[
                  isLoginPressed ? Center(
                   child:CircularProgressIndicator(
                     backgroundColor: Colors.yellow[700],
                   )
                    ):
                  FadeAnimation(1.6, Container(
                    padding: EdgeInsets.only(top: 3, left: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border(
                        bottom: BorderSide(color: Colors.black),
                        top: BorderSide(color: Colors.black),
                        left: BorderSide(color: Colors.black),
                        right: BorderSide(color: Colors.black),
                      )
                    ),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () =>performLogin(),
                      color: Colors.yellow[700],
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)
                      ),
                      child: Text("Jump In", style: TextStyle(
                        fontWeight: FontWeight.w600, 
                        fontSize: 18
                      ),),
                    ),
                  )),
                  SizedBox(height: 10,),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  void performLogin() {

    print("tring to perform login");

    setState(() {
      isLoginPressed = true;
    });
    
    _authMethods.signIn().then((FirebaseUser user) {
      print("something");
      if (user != null) {
        authenticateUser(user);
      } else {
        print("There was an error");
      }
    });
  }

  void authenticateUser(FirebaseUser user) {
    _authMethods.authenticateUser(user).then((isNewUser) {
      if (isNewUser) {
        _authMethods.addDataToDb(user).then((value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return HomeScreen();
          }));
        });
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
      }
    });
  }

  
  }

// class LoginScreenState extends State<LoginScreen> {
//    final AuthMethods _authMethods = AuthMethods();
//   bool isLoginPressed = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: UniversalVaribales.blackColor,
//       body: Stack(
//         children: <Widget>[
//           Center(
//             child:loginButton()
//           ),
//           isLoginPressed ? Center(
//             child:CircularProgressIndicator()
//           ):Container()
//         ],
//       )
//     );
//   }

//   Widget loginButton() {
//     return Shimmer.fromColors(
//         baseColor:Colors.white,
//         highlightColor: UniversalVaribales.senderColor,
//           child: FlatButton(
//         padding: EdgeInsets.all(35),
//         child: Text(
//           "LOGIN",
//           style: TextStyle(
//               fontSize: 35, fontWeight: FontWeight.w900, letterSpacing: 1.2 ,color:Colors.black),
//         ),
//         onPressed: () => ,
//       ),
//     );
//   }

  