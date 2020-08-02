import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:senger/provider/user_provider.dart';
import 'package:senger/resources/auth_methods.dart';
import 'package:senger/resources/localdb/repository/log_respository.dart';
import 'package:senger/screens/call_screens/pickup_layout.dart';
import 'package:senger/screens/pages/contact_screen.dart';
import 'package:senger/screens/pages/log_screen.dart';
import 'package:senger/utils/universal_variables.dart';
import 'package:senger/screens/pages/chat_screen.dart';
import 'package:provider/provider.dart';
import '../enum/user_state.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  PageController pageController;
  int _page = 0;
  final AuthMethods _authMethods = AuthMethods();

  UserProvider userProvider;

  @override
  void initState(){
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      
    userProvider = Provider.of<UserProvider>(context, listen: false);
      // ignore: await_only_futures
      await userProvider.refreshUser();

      _authMethods.setUserState(
        userId: userProvider.getUser.uid,
        userState: UserState.Online, 
      );
      LogRepository.init(
        isHive: false,
        dbName: userProvider.getUser.uid
        );
     });

    WidgetsBinding.instance.addObserver(this);
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }


  @override
  void didChangeAppLifeCycleState(AppLifecycleState state){
    String currentUserId = 
      (userProvider != null && userProvider.getUser != null)
      ? userProvider.getUser.uid
      :"";

      super.didChangeAppLifecycleState(state);

        switch(state){
          case AppLifecycleState.resumed:
           currentUserId != null ?
           _authMethods.setUserState(
             userId: currentUserId,
             userState: UserState.Online 
             ): print('resume state');
          break;
        case AppLifecycleState.inactive:
         currentUserId != null ?
           _authMethods.setUserState(
             userId: currentUserId,
             userState: UserState.Offline 
             ): print('offline state');
          break;
        case AppLifecycleState.paused:
          currentUserId != null ?
           _authMethods.setUserState(
             userId: currentUserId,
             userState: UserState.Waiting 
             ): print('paused state');
          break;
        case AppLifecycleState.detached:
         currentUserId != null ?
           _authMethods.setUserState(
             userId: currentUserId,
             userState: UserState.Offline 
             ): print('detached state');
          break;
        }
  }

  void onPageChanged(int page){
    setState((){
      _page = page;
    });
  }

  void navigationTapped(int page){
    print('page ,$page');
    pageController.jumpToPage(page);
  }

  Widget build(BuildContext context) {
    return PickUpLayout(
          scaffold: Scaffold( 
        backgroundColor: Colors.white,
        body: PageView(
          children: <Widget>[
            Center(child: ChatScreen(),),
            Center(child:LogScreen()),
            Center(child:ContactScreen())
          ],
          controller: pageController,
          onPageChanged: onPageChanged, 
        ),
        bottomNavigationBar: Container(
          child:Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: CupertinoTabBar(
              backgroundColor: Colors.white,
              items:<BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon:Icon(Icons.chat,color:(_page ==0)?UniversalVaribales.blackColor:UniversalVaribales.greyColor),
                  title: Text('Chats',style: TextStyle(fontSize:10,color:(_page ==0)?Colors.black:UniversalVaribales.greyColor))
                ),
                BottomNavigationBarItem(
                  icon:Icon(Icons.call,color:(_page ==1)?UniversalVaribales.blackColor:UniversalVaribales.greyColor),
                  title: Text('Calls',style: TextStyle(fontSize:10,color:(_page ==1)?Colors.black:UniversalVaribales.greyColor))
                ),
                BottomNavigationBarItem(
                  icon:Icon(Icons.contacts,color:(_page ==2)?UniversalVaribales.blackColor:UniversalVaribales.greyColor),
                  title: Text('Contacts',style: TextStyle(fontSize:10,color:(_page ==2)?Colors.black:UniversalVaribales.greyColor))
                )
              ],
              onTap: navigationTapped,
              currentIndex: _page,
            ),
          )
        ),
      ),
    );
  }
}