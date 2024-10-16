import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Provider/notify_provider.dart';
import 'package:path/path.dart';

class NotificationServices{
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> notificationSettings() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      sound: true,
      badge: true,
      announcement: true,
      provisional: true,
      carPlay: true,
      criticalAlert: true,
    );
    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print('user authorized');
    }else
      {
        print('user not authorized ');
      }
  }

  void initlocalNotification(BuildContext context,RemoteMessage message) async {
    var androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    // var iosInitializationSettings = DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      // iOS: iosInitializationSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
    //     onDidReceiveNotificationResponse: (payload){
    //   handleMessage(context, message);
    //
    //
    // }
    );
  }

  void Firebaseinit(BuildContext context){
    FirebaseMessaging.onMessage.listen((message) async {
      print(message.notification!.title.toString());
      print(message.notification!.body.toString());
      print(message.data.toString());


      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isChataScreen = prefs.getBool("isChatScreen")!;

      print(isChataScreen);
      if(isChataScreen){
        final provider = Provider.of<NotifyProvider>(context, listen: false);

        dynamic abc = jsonDecode(jsonEncode(message.data));
        print(abc['file']);
        print("abc['file']");


        provider.messageAdd(
            abc['appointment_id'],
            abc['appointment_id'],
            abc['userList_id'],
            abc['drprofile_id'],
            abc['sender'],
            abc['type'],
            abc['message'],
            abc['status']);
      }

      initlocalNotification(context, message);
      ShowNotification(message);

    });
  }

  Future<void> ShowNotification(RemoteMessage message) async {

    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      'High Importance Notifications',
      importance: Importance.max,

    );
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'your channel discription',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );
    // DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
    //   presentAlert: true,
    //   presentBadge: true,
    //   presentSound: true,
    //
    // );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      // iOS: darwinNotificationDetails,
    );

 await Future.delayed(Duration.zero,
        (){
          flutterLocalNotificationsPlugin.show(
              0,
              message.notification!.title.toString(),
              message.notification!.body.toString(),
              notificationDetails,
          );
        });
  }


  Future<String> GetDeviceToken() async {
   String? token = await messaging.getToken();
  return token!;
  }
  void IsDeviceTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {

      event.toString();
      print('refresh');
    });
  }

    Future<void> SetUpInteractMessage(BuildContext context)async{
    RemoteMessage?  initalMessage = await FirebaseMessaging.instance.getInitialMessage();
    if(initalMessage!=null){
     handleMessage(context, initalMessage);

    }
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
     handleMessage(context, event);
    });
    }

  void handleMessage(BuildContext context,RemoteMessage message){
    if(message.data['type'] == 'msj'){
      // Get.to(Mess(name: message.data['id'].toString()));
    }

  }
}