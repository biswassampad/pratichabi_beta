import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pratichabi/resources/firebase_repository.dart';
import 'package:pratichabi/screens/home_screen.dart';
import 'package:pratichabi/screens/login_screen.dart';
import 'package:pratichabi/screens/pages/search_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  FirebaseRepository _repository = FirebaseRepository();
  
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Pratichabi',
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        '/search_screen':(context)=>SearchScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark
      ),
      home:FutureBuilder(
        future:_repository.getCurrentUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot){
          if(snapshot.hasData){
            return HomeScreen();
          }else{
            return LoginScreen();
          }
        },
      ),
    );
  }
}

// Author Details 
// Name: Biswas Sampad Satpathy
// Address: Oltibarsquare,Purunagarh,Deogarh
// email: biswassampad.official@gmail.com