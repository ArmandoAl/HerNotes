// ignore_for_file: avoid_print, unused_import
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:first/main.dart';
import 'package:flutter/material.dart';

class PushNotifications {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> init() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();

    print('FCM Token: $fcmToken');

    initPushNotifications();
  }

  Future<void> handleMessage(RemoteMessage message) async {
    print('Handling a background message ${message.messageId}');
  }

  void initPushNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print('Message data: ${message.data}');
      
      navKey.currentState!.pushNamed('/home', arguments: message.data);
    });

    FirebaseMessaging.onBackgroundMessage((message) => handleMessage(message));
  }

}
