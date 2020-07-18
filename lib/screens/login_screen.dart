import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pratichabi/resources/auth_methods.dart';
import 'package:pratichabi/screens/home_screen.dart';
import 'package:pratichabi/utils/universal_variables.dart';
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
    _authMethods.signOut();
    return Scaffold(
      backgroundColor: UniversalVaribales.blackColor,
      body: Stack(
        children: <Widget>[
          Center(
            child:loginButton()
          ),
          isLoginPressed ? Center(
            child:CircularProgressIndicator()
          ):Container()
        ],
      )
    );
  }

  Widget loginButton() {
    return Shimmer.fromColors(
        baseColor:Colors.white,
        highlightColor: UniversalVaribales.senderColor,
          child: FlatButton(
        padding: EdgeInsets.all(35),
        child: Text(
          "LOGIN",
          style: TextStyle(
              fontSize: 35, fontWeight: FontWeight.w900, letterSpacing: 1.2 ,color:Colors.black),
        ),
        onPressed: () => performLogin(),
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