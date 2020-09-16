library my_prj.globals;

import 'dart:ui';
import 'package:charts_flutter/flutter.dart' as charts;

String goal;
double goalDouble = 2000;
List<charts.Series<Task, String>> seriesPieData;
String bottleString;
double bottle = 200.0;
double initialValue = 0.0;
String presentValueString = "";
double presentValue = 0.0;
double percentual = 00.0;
double complementar = 100.0;
double toGo= 2000.0;
String textToGo = 'To Go';
Color colorPainted = Color(0xff274c77);
Color colorNotPainted = Color(0xff8b8c89);
bool isFirstLoaded01 = true;   //used in the AlertDialog when you reach the goal;
bool isFirstLaunch = true;    //used in the routes to determine the initialRoute;
DateTime d01 = DateTime.now();
DateTime d02 = DateTime.now();
int day01 = 0;
int day02 = d02.day;
List<String> list = [];
List<String> listTypeOfReminder = [];
List<String> listWarning = [];
int storedHour = 01;
int storedMinute = 36;
bool isSwitched = false;
List<bool> listSwitched = [];
List<String> listSwitchedinString = [];
List<bool> convertedFromString = [];
bool pressAttention01 = false;
bool pressAttention02 = false;
bool pressAttention03 = false;
bool pressAttention04 = false;
bool pressAttention05 = false;
bool pressAlarm01 = false;
bool pressAlarm02 = false;
bool pressAlarm03 = false;
bool pressAlarm04 = false;
bool pressAlarm05 = false;


class Task {
  String task;
  double taskvalue;
  Color colorval;

  Task(this.task, this.taskvalue, this.colorval);

}

var piedata = [
  new Task('Water', 0, Color(0xff3366cc)),
  new Task('Empty', 100, Color(0xfffdbe19)),
];