import 'package:flutter/material.dart';
import 'package:senger/provider/Notification_provider.dart';


class LogScreen extends StatefulWidget {
  @override
  _LogScreenState createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  int count = 0;
  @override
  void initState(){
    super.initState();
    notificationPlugin.setListenerForLowerVersions(onNotificationInLowerVersions);
    notificationPlugin.setOnNotificationClick(onNotificationClick);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text('Notification Test')
      ),
      body:Center(
        child: FlatButton(onPressed: () async {
          // await notificationPlugin.showNotification();
          // await notificationPlugin.scheduleNotification();
          count = await  notificationPlugin.getPendingNotificationCount();
        }, child: Text('Send Notification')),
      )
    );
  }

  onNotificationInLowerVersions(RecievedNotification receivedNotification){}

  onNotificationClick(String payload){
    print('Payload $payload');
  }

}