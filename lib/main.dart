import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pratichabi/provider/image_upload_provider.dart';
import 'package:pratichabi/provider/user_provider.dart';
import 'package:pratichabi/resources/auth_methods.dart';
import 'package:pratichabi/screens/home_screen.dart';
import 'package:pratichabi/screens/login_screen.dart';
import 'package:pratichabi/screens/pages/search_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {

  final AuthMethods _authMethods = AuthMethods();
  
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create:(_)=>ImageUploadProvider()),
        ChangeNotifierProvider(create:(_)=>UserProvider(),)
      ],
          child: MaterialApp(
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
          future:_authMethods.getCurrentUser(),
          builder: (context, AsyncSnapshot<FirebaseUser> snapshot){
            if(snapshot.hasData){
              return HomeScreen();
            }else{
              return LoginScreen();
            }
          },
        ),
      ),
    );
  }
}

// Author Details 
// Name: Biswas Sampad Satpathy
// Address: Oltibarsquare,Purunagarh,Deogarh
// email: biswassampad.official@gmail.com