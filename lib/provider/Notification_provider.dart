import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show File,Platform;

import 'package:rxdart/rxdart.dart';

class NotificationPlugin{

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  final BehaviorSubject<RecievedNotification> didRecievedLocalNotificationSubject =
     BehaviorSubject<RecievedNotification>();
  var initializationSettings;
  NotificationPlugin._(){
    init();
  }

  init() async{
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if(Platform.isIOS){
      _requestIOSPermission();
    }
    initializePlatformSpecifics();
  }



    initializePlatformSpecifics(){
      var initializeSettingsForAndroid = AndroidInitializationSettings('app_notif_icon');
      var initializationForIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (id,title,body,payload) async{
          RecievedNotification recievedNotification = RecievedNotification(id: id, title: title, body: body, payload: payload);
          didRecievedLocalNotificationSubject.add(recievedNotification);
        }
      );

      initializationSettings = InitializationSettings(initializeSettingsForAndroid,initializationForIOS);
    }

  _requestIOSPermission(){
    flutterLocalNotificationsPlugin
    .resolvePlatformSpecificImplementation
    <IOSFlutterLocalNotificationsPlugin>().requestPermissions(
      alert:false,
      badge:true,
      sound:true,
    );
  }

  setListenerForLowerVersions(Function onLowerVersionNotifications){
      didRecievedLocalNotificationSubject.listen((recievedNotification) {
          onLowerVersionNotifications(recievedNotification);
       });
  }


  setOnNotificationClick(Function onNotificationClick) async{
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
    onSelectNotification: (String payload) async{
      onNotificationClick(payload);
    });
  } 
  Future<void>showNotification() async{
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      'CHANNEL_DESCRIPTION',
      enableLights: true,
      importance: Importance.Max,
      priority: Priority.High,
      styleInformation: DefaultStyleInformation(true, true)
      );
    var iosChannelSpecifics = IOSNotificationDetails();

    var platfromSpecifics  = NotificationDetails(androidChannelSpecifics,iosChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      '<b>You have a new Message</b>',
      'From Biswas Sampad',
      platfromSpecifics,
      payload: 'Test Payload');
  }

  Future<void>scheduleNotification() async{
    var scheduleNotificationDateTime = DateTime.now().add(Duration(seconds: 1));
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID 1',
      'CHANNEL_NAME 1',
      'CHANNEL_DESCRIPTION 1',
      sound: RawResourceAndroidNotificationSound("notif_sound"),
      enableLights: true,
      color:const Color.fromARGB(255, 255, 0, 0),
      ledColor:const Color.fromARGB(255, 255, 0, 0),
      ledOnMs: 1000,
      ledOffMs: 500,
      importance: Importance.Max,
      priority: Priority.High,
      styleInformation: DefaultStyleInformation(true, true)
      );
    var iosChannelSpecifics = IOSNotificationDetails();

    var platfromSpecifics  = NotificationDetails(androidChannelSpecifics,iosChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
      0,
      '<b>Hi Biswas</b>',
      'Good Night',
      scheduleNotificationDateTime,
      platfromSpecifics,
      payload: 'Test Payload');
  }

  Future<int> getPendingNotificationCount() async{
    List<PendingNotificationRequest> p =
    await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return p.length;
  }
}

  


NotificationPlugin notificationPlugin = NotificationPlugin._();


class RecievedNotification{
  final int id;
  final String title;
  final String body;
  final String payload;

  RecievedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload
  });
}