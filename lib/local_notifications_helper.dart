import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meta/meta.dart';



NotificationDetails get _noSound {
  final androidChannelSpecifics = AndroidNotificationDetails(
    'silent channel id',
    'silent channel name',
    'silent channel description',
    importance: Importance.High,
    priority: Priority.High,
    playSound: false,
  );
  final iOSChannelSpecifics = IOSNotificationDetails(presentSound: false);

  return NotificationDetails(androidChannelSpecifics, iOSChannelSpecifics);
}


NotificationDetails get _ongoing {
  final androidChannelSpecifics = AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    'your channel description',
    importance: Importance.Default,
    priority: Priority.Max,
    ongoing: false,  // if true you cannot dismiss the notification
    autoCancel: true, // when you click it fades
    showProgress: true,
    indeterminate: true,
    color: const Color(0xbdc696),
  );
  final iOSChannelSpecifics = IOSNotificationDetails();
  return NotificationDetails(androidChannelSpecifics, iOSChannelSpecifics);
}



Future showSilentNotification(   //SUB METHOD OF _showNotification, need to define a _noSound parameter
    FlutterLocalNotificationsPlugin notifications, {
      @required String title,
      @required String body,
      int id = 0,
    }) =>
    _showNotification(notifications,
        title: title, body: body, id: id, type: _noSound);



Future showOngoingNotification(   //SUB METHOD OF _showNotification, need to define a _ongoing parameter
    FlutterLocalNotificationsPlugin notifications, {
      @required String title,
      @required String body,
      int id = 0,
    }) =>
    _showNotification(notifications,
        title: title, body: body, id: id, type: _ongoing);

Future _showNotification(         ////MAIN METHOD
    FlutterLocalNotificationsPlugin notifications, {
      @required String title,
      @required String body,
      @required NotificationDetails type,
      int id = 0,
    }) =>
    notifications.show(id, title, body, type);

Future _scheduleNotificationSpecificHour(         ////MAIN METHOD
    FlutterLocalNotificationsPlugin notifications, {
      @required String title,
      @required String body,
      @required NotificationDetails type,
      @required Time scheduledTime,
      int id = 0,
    }) =>
    notifications.showDailyAtTime(id, title, body, scheduledTime, type);

Future showScheduledNotificationSpecificHour(   //SUB METHOD OF _scheduleNotification, need to define a _ongoing parameter
    FlutterLocalNotificationsPlugin notifications, {
      @required String title,
      @required String body,
      @required Time scheduledTime,
      int id = 0,
    }) =>
    _scheduleNotificationSpecificHour(notifications,
        title: title, body: body, id: id, scheduledTime: scheduledTime, type: _ongoing);























NotificationDetails get _withSound {
  final androidChannelSpecifics = AndroidNotificationDetails(
    'silent channel id',
    'silent channel name',
    'silent channel description',
    playSound: true,
    ongoing: true,
  );
  final iOSChannelSpecifics = IOSNotificationDetails(presentSound: true);

  return NotificationDetails(androidChannelSpecifics, iOSChannelSpecifics);
}

Future _scheduleNotification(         ////MAIN METHOD 02
    FlutterLocalNotificationsPlugin notifications, {
      @required String title,
      @required String body,
      @required NotificationDetails type,
      @required RepeatInterval repeatInterval,
      int id = 0,
    }) =>
    notifications.periodicallyShow(id, title, body, repeatInterval, type);

Future showScheduledNotification(   //SUB METHOD OF _scheduleNotification, need to define a _ongoing parameter
    FlutterLocalNotificationsPlugin notifications, {
      @required String title,
      @required String body,
      int id = 0,
    }) =>
    _scheduleNotification(notifications,
        title: title, body: body, id: id, repeatInterval: RepeatInterval.EveryMinute, type: _ongoing);