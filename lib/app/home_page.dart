import 'package:beba_agua_new/service/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../local_notifications_helper.dart';
import '../second_page.dart';
import 'package:beba_agua_new/globals.dart' as globals;
import '../globals.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'bottle_page.dart';
import 'goal.dart';


class LocalNotificationWidget extends StatefulWidget {
  LocalNotificationWidget({@required this.auth});
  final AuthBase auth;



  @override
  _LocalNotificationWidgetState createState() =>
      _LocalNotificationWidgetState();
}

class _LocalNotificationWidgetState extends State<LocalNotificationWidget> {
  final notifications = FlutterLocalNotificationsPlugin();
  var currentDate = DateTime.now();
  List<charts.Series<Task, String>> _seriesPieData;




  Future<void> _signOut() async {
    try {
      await widget.auth.signOut();
      globals.isFirstLaunch = false;
    } catch (e) {
      print(e.toString());
    }
  }




  Future<void> alertDialogYouWin() async {
    print(globals.isFirstLoaded01);
    if (globals.isFirstLoaded01 == true) {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('YOU HAVE DONE IT!!!'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('CONGRATULATIONS ON YOUR EFFORT!!!'),
                  Text('Tomorrow you will do it again!!'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  globals.isFirstLoaded01 = false;
                  print(globals.isFirstLoaded01);
                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  await preferences.setBool('isFirstLoaded01', globals.isFirstLoaded01);

                },
              ),
            ],
          );
        },
      );
    }
  }



  checkExtra() async{

    if (globals.toGo == 0) {
      globals.toGo = globals.toGo;
      globals.isFirstLoaded01 = true;  // colocado para ter certeza que sempre comecará com true e o alert disparará;
      alertDialogYouWin();
      globals.textToGo = 'Extra';
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString('textToGo', globals.textToGo);
    }

    else if (globals.toGo < 0) {
      globals.toGo = -globals.toGo;
      alertDialogYouWin();    // se o alert aparecer duas vezes arrumar dentro do alertdialog
      globals.textToGo = 'Extra';
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString('textToGo', globals.textToGo);
    }


  }


  void calculatePLUS()  async {



    setState(()  {



      if (globals.presentValue == 0.0) {
        globals.presentValue = globals.initialValue + globals.bottle;


      } else {
        globals.presentValue = globals.presentValue + globals.bottle;
      }

      if (globals.presentValue == 0.0) {
        globals.percentual = 0;


      }

      else {
        globals.percentual = (globals.presentValue / globals.goalDouble)*100.0;
      }

      if (globals.percentual <= 0.0) {
        globals.complementar = 0.0;


      }

      else if ((100 - globals.percentual) <= 0.0) {
        globals.complementar = 0.0;


      }


      else {
        globals.complementar = (100 - globals.percentual);
      }

      globals.toGo = globals.goalDouble - globals.presentValue;


      checkExtra();


    }




    );



  }



  addDoubleToSP() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setDouble('presentValue', globals.presentValue);
    await preferences.setDouble('percentual', globals.percentual);
    await preferences.setDouble('complementar', globals.complementar);
    await preferences.setDouble('goalDouble', globals.goalDouble);
    await preferences.setDouble('toGo', globals.toGo);
    await preferences.setDouble('bottle', globals.bottle);
    await preferences.setDouble('initialValue', globals.initialValue);
    await preferences.setString('textToGo', globals.textToGo);
    await preferences.setBool('pressAttention01', globals.pressAttention01);
    await preferences.setBool('pressAlarm01', globals.pressAlarm01);
    await preferences.setInt('storedHour', globals.storedHour);
    await preferences.setInt('storedMinute', globals.storedMinute);

  }



  clearSP() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('storedHour');
    preferences.remove('storedMinute');
  }


  void _addGoal(BuildContext context){
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => goalPage(),
      ),
    );
  }

  void _addBottle(BuildContext context){
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => bottlePage(),
      ),
    );
  }






  generateData() {



    globals.seriesPieData.add(
      charts.Series(
        domainFn: (Task task, _) => task.task,
        measureFn: (Task task, _) => task.taskvalue,
        colorFn: (Task task, _) =>
            charts.ColorUtil.fromDartColor(task.colorval),
        id: 'Daily Water',
        data: globals.piedata,
        labelAccessorFn: (Task row, _) => '${row.taskvalue.toStringAsFixed(1)}%',
      ),
    );

    print('Percentual inside genereteData():  ${globals.percentual}');

  }






  @override
  void initState() {
    super.initState();

    final settingsAndroid = AndroidInitializationSettings('app_icon');  // png inside android/app/src/main/res/drawable
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);


    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);


    globals.piedata = [
      new Task('Water', globals.percentual, globals.colorPainted),
      new Task('Empty', globals.complementar, globals.colorNotPainted),
    ];

    globals.seriesPieData = List<charts.Series<Task, String>>();
    generateData();


  }

  Future onSelectNotification(String payload) async => await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SecondPage(payload: payload)),
  );




  Future<void> scheduleNotificationPeriodically(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      String id,
      String body,
      RepeatInterval interval) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      id,
      'Reminder notifications',
      'Remember about it',
      icon: 'smile_icon',
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.periodicallyShow(
        0, 'Reminder', body, interval, platformChannelSpecifics);
  }



  Future<void> scheduleNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      String id,
      String body,
      DateTime scheduledNotificationDateTime) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      id,
      'Reminder notifications',
      'Remember about it',
      icon: 'app_icon',
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(0, 'Reminder', body,
        scheduledNotificationDateTime, platformChannelSpecifics);
  }




  Widget title(String text) => Container(
    margin: EdgeInsets.symmetric(vertical: 4),
    child: Text(
      text,
      style: Theme.of(context).textTheme.title,
      textAlign: TextAlign.center,
    ),
  );





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFe7ecef),
      appBar: AppBar(
        title: Text('Drink Water'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: DrawerChild(),
      ),
      body: _buildContent03(context),
    );
  }



  Widget DrawerChild(){
    return ListView(
      children: <Widget>[
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                color: Color(0xFF274C77),
                child: ListTile(
                  title: Text('NETO', style: TextStyle(color: Colors.white),),
                  subtitle: Text(
                    'Upgrade to Premium', style: TextStyle(color:  Colors.limeAccent),),
                ),
              ),

              Container(
                color: Color(0xFF6096BA),
                child: ListTile(
                  leading: FaIcon(FontAwesomeIcons.history),
                  title: Text('Histórico', style: TextStyle(color: Colors.white),),
                  onTap: () {
                  },
                ),
              ),

              Container(
                color: Color(0xFF6096BA),
                child: ListTile(
                  leading: FaIcon(FontAwesomeIcons.gamepad),
                  title: Text('Play and Pratice',  style: TextStyle(color: Colors.white),),
                  onTap: () {
                  },
                ),
              ),

              Container(
                color: Color(0xFF6096BA),
                child: ListTile(
                  leading: FaIcon(FontAwesomeIcons.fantasyFlightGames),
                  title: Text('Play and Pratice',  style: TextStyle(color: Colors.white),),
                  onTap: () {
                  },
                ),
              ),

              Container(
                color: Color(0xFF6096BA),
                child: ListTile(
                  leading: FaIcon(FontAwesomeIcons.signOutAlt),
                  title: Text('Logout',  style: TextStyle(color: Colors.white),),
                  onTap: _signOut,
                ),
              ),

              SizedBox(
                height: double.maxFinite,
                child: Container(
                  color: Color(0xFF6096BA),
                ),
              )



            ],
          ),
        ),
      ],
    );
  }





  Widget _buildContent03(BuildContext context){
    return Padding(
      padding: EdgeInsets.all(1.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 1.0),


                    SizedBox(
                      height: 150,
                      child: Material(
                        color: Color(0xFFa3cef1),
                        elevation: 8.0,
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 7.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                InkWell(
                                  onTap: (){},
                                  child: Text(
                                    'Add Your Reminder',
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                InkWell(
                                  onTap: () => setState(() {



                                    print(
                                        'PressAttention05 : ${globals
                                            .pressAttention05}');

                                    print(
                                        'PressAlarm05 : ${globals
                                            .pressAttention05}');

                                    globals.pressAttention01 = !globals.pressAttention01;
                                    print("Esse é o botão press01 : $pressAttention01");

                                    globals.pressAttention02 = false;
                                    globals.pressAttention03 = false;
                                    globals.pressAttention04 = false;

                                    print("Esse é o botão press04 : $pressAttention04");

                                    globals.pressAlarm01 = !globals.pressAlarm01;
                                    print("Esse é o pressAlarm : $pressAlarm01");
                                    globals.pressAlarm02 = false;
                                    globals.pressAlarm03 = false;
                                    globals.pressAlarm04 = false;


                                    notifications.cancel(02);
                                    notifications.cancel(03);
                                    notifications.cancel(04);
                                    //notification 05 at same time

                                    addDoubleToSP();

                                    globals.pressAlarm01 ?
                                    showScheduledNotification(
                                        notifications,
                                        title: 'Hora de beber',
                                        body: 'Bebe logo!',
                                        id: 01)
                                        : notifications.cancel(01);


                                  }),
                                  child: Text(
                                    'EVERY 15 MIN',
                                    style: TextStyle(
                                      color: globals.pressAttention01 ? Colors.red : Colors.black87,
                                      fontSize: 15.0,
                                      fontWeight: globals.pressAttention01 ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Text(''),
                                InkWell(
                                  onTap: () => setState(() {
                                    print("${globals.pressAttention02}");
                                    globals.pressAttention02 = !globals.pressAttention02;
                                    globals.pressAttention01 = false;
                                    globals.pressAttention03 = false;
                                    globals.pressAttention04 = false;


                                    globals.pressAlarm02 = !globals.pressAlarm02;
                                    globals.pressAlarm01 = false;
                                    globals.pressAlarm03 = false;
                                    globals.pressAlarm04 = false;


                                    notifications.cancel(01);
                                    notifications.cancel(03);
                                    notifications.cancel(04);
                                    //notification 05 at same time

                                    addDoubleToSP();


                                    globals.pressAlarm02 ?
                                    showScheduledNotification(
                                        notifications,
                                        title: 'Hora de beber',
                                        body: 'Bebe logo!',
                                        id: 01)
                                        : notifications.cancel(01);

                                  }),
                                  child: Text(
                                    'EVERY 30 MIN',
                                    style: TextStyle(
                                      color: globals.pressAttention02 ? Colors.red : Colors.black87,
                                      fontSize: 15.0,
                                      fontWeight: globals.pressAttention02 ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                InkWell(
                                  onTap: () => setState(() {
                                    globals.pressAttention03 = !pressAttention03;
                                    globals.pressAttention01 = false;
                                    globals.pressAttention02 = false;
                                    globals.pressAttention04 = false;


                                    globals.pressAlarm03 = !globals.pressAlarm03;
                                    globals.pressAlarm01 = false;
                                    globals.pressAlarm02 = false;
                                    globals.pressAlarm04 = false;


                                    notifications.cancel(01);
                                    notifications.cancel(02);
                                    notifications.cancel(04);
                                    //notification 05 at same time

                                    addDoubleToSP();


                                    globals.pressAlarm03 ?
                                    showScheduledNotification(
                                        notifications,
                                        title: 'Hora de beber',
                                        body: 'Bebe logo!',
                                        id: 01)
                                        : notifications.cancel(01);
                                  }),
                                  child: Text(
                                    'EVERY 45 MIN',
                                    style: TextStyle(
                                      color: globals.pressAttention03 ? Colors.red : Colors.black87,
                                      fontSize: 15.0,
                                      fontWeight: globals.pressAttention03 ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Text(''),
                                InkWell(
                                  onTap: () => setState(() {
                                    globals.pressAttention04 = !globals.pressAttention04;
                                    globals.pressAttention01 = false;
                                    globals.pressAttention02 = false;
                                    globals.pressAttention03 = false;
                                    print("Esse é o botão press04 : $pressAttention04");
                                    print("Esse é o botão press01 : $pressAttention01");

                                    globals.pressAlarm04 = !globals.pressAlarm04;
                                    globals.pressAlarm01 = false;
                                    globals.pressAlarm02 = false;
                                    globals.pressAlarm03 = false;


                                    notifications.cancel(01);
                                    notifications.cancel(02);
                                    notifications.cancel(03);
                                    //notification 05 at same time

                                    addDoubleToSP();


                                    globals.pressAlarm04 ?
                                    showScheduledNotification(
                                        notifications,
                                        title: 'Hora de beber',
                                        body: 'Bebe logo!',
                                        id: 01)
                                        : notifications.cancel(01);
                                  }),
                                  child: Text(
                                    'EVERY 60 MIN',
                                    style: TextStyle(
                                      color: globals.pressAttention04 ? Colors.red : Colors.black87,
                                      fontSize: 15.0,
                                      fontWeight: globals.pressAttention04 ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {

                                    print(
                                        'PressAttention Meus Deus: ${globals
                                            .pressAttention05}');

                                    globals.pressAttention05 =
                                    !globals.pressAttention05;

                                    globals.pressAlarm05 =
                                    !globals.pressAlarm05;

                                    print(
                                        'PressAttention Meu deus 02: ${globals
                                            .pressAttention05}');

                                    if (globals
                                        .pressAttention05 == true) {



                                      DatePicker.showTimePicker(context,
                                          theme: DatePickerTheme(
                                            containerHeight: 210.0,
                                          ),
                                          showTitleActions: true,
                                          onConfirm: (time) {
                                            print('confirm $time');

                                            //    globals.listWarning.insert(index, '${(time.hour) >= 10 ? time.hour : '0' + '${time.hour}'} : ${(time.minute) >= 10 ? time.minute : '0' + '${time.minute}'}');   //${(_payload ?? '')}'),

                                            print('estou aqui');
                                            print(
                                                'PressAttention : ${globals
                                                    .pressAttention05}');

                                            globals.storedHour = time.hour;
                                            globals.storedMinute = time.minute;
                                            print({globals.storedMinute});




                                            print('estou aqui');
                                            print(
                                                'PressAttention : ${globals
                                                    .pressAttention05}');


                                            addDoubleToSP();

                                            print(
                                                'PressAlarm05 antes do acionamento do alarme: ${globals
                                                    .pressAlarm05} + ${globals
                                                    .pressAttention05}');
                                            print(
                                                'Horario selecionado: ${globals
                                                    .storedHour}   +  ${globals
                                                    .storedMinute}');


                                            setState(() {
                                              globals.pressAlarm05 ?
                                              showScheduledNotificationSpecificHour(
                                                  notifications,
                                                  title: 'Hora agendada!',
                                                  body: 'Bebe logo!',
                                                  scheduledTime: Time(
                                                      globals.storedHour,
                                                      globals.storedMinute, 0),
                                                  id: 01)
                                                  : notifications.cancel(01);   // nao tera else


                                              print(
                                                  'PressAlarm05 depois do acionamento do alarme: ${globals
                                                      .pressAlarm05} + ${globals
                                                      .pressAttention05}');
                                              print(
                                                  'Horario selecionado depois do alarme: ${globals
                                                      .storedHour}   +  ${globals
                                                      .storedMinute}');
                                            });
                                          },
                                          currentTime: DateTime.now(),
                                          locale: LocaleType.pt);



                                    }  else {

                                      setState(() {

                                        globals.pressAttention05 = false;
                                        globals.pressAlarm05 = false;
                                        notifications.cancel(05);

                                        print('estou aqui');
                                        print(
                                            'PressAttention : ${globals
                                                .pressAttention05} + ${globals
                                                .pressAlarm05}');


                                      });




                                    }







                                  },
                                  child: Text(
                                    'SPECIFIC TIME OF THE DAY - ${(globals.storedHour) >= 10 ? globals.storedHour : '0' + '${globals.storedHour}'} : ${(globals.storedMinute) >= 10 ? globals.storedMinute : '0' + '${globals.storedMinute}'}',

                                    style: TextStyle(
                                      color: globals.pressAttention05 ? Colors.red : Colors.black87,
                                      fontSize: 15.0,
                                      fontWeight: globals.pressAttention05 ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                        ),
                      ),
                    ),



                    ///////PUT YOUR SOCIAL SIGN IN BUTTON HERE /////////




                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 50.0,
                          child: RaisedButton(
                            color: Color(0xFFa3cef1),
                            child: Text(
                              'CHOOSE BOTTLE',
                              style: TextStyle(fontSize: 15.0),

                            ),
                            elevation: 8.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                            ),
                            onPressed: () async {
                              _addBottle(context);
                              print('presentValue: ${globals.presentValue}');
                              print('initialValue: ${globals.initialValue}');
                              print('boolean: ${globals.isFirstLoaded01}');
                              SharedPreferences preferences = await SharedPreferences.getInstance();
                            },
                          ),
                        ),
                        SizedBox(width: 8.0),
                        SizedBox(
                          height: 50.0,
                          child: RaisedButton(
                            color: Color(0xFFa3cef1),
                            child: Text(
                              '     ADD WATER     ',
                              style: TextStyle(fontSize: 15.0),
                            ),
                            elevation: 8.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                calculatePLUS();
                                addDoubleToSP();
                                clearSP();
                                globals.listSwitchedinString.forEach((element) => globals.convertedFromString.add(element == 'false' ? false : true));
                                print('List converted from string :${globals.convertedFromString}');

                                globals.piedata = [
                                  new Task('Water', globals.percentual, globals.colorPainted),
                                  new Task('Empty', globals.complementar, globals.colorNotPainted),
                                ];

                                print('First Task ${globals.piedata.first.taskvalue}');
                                print('Last Task ${globals.piedata.last.taskvalue}');

                                globals.seriesPieData = List<charts.Series<Task, String>>();

                                generateData();

                                print('Globals Goal: ${globals.goalDouble}');
                                print("Bebeu ${globals.presentValue} ML");
                                print("Percentual ${globals.percentual} %");
                                print("Complementar ${globals.complementar} %");
                                print('toGo : ${globals.toGo}');
                                print('TEXTtoGo : ${globals.textToGo}');
                                print('Bool do firstLoaded AlertDialog : ${globals.isFirstLoaded01}');
                              });

                            },
                          ),
                        ),
                      ],
                    ),




                    ///////PUT YOUR ROW HERE /////////




                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: charts.PieChart(
                    globals.seriesPieData,
                    animate: true,
                    animationDuration: Duration(seconds: 1),
                    defaultRenderer: new charts.ArcRendererConfig(
                        arcWidth: 100,
                        arcRendererDecorators: [
                          new charts.ArcLabelDecorator(
                              labelPosition: charts.ArcLabelPosition.inside)
                        ])),

              ),

              Column(
                children: <Widget>[
                  Container(
                    child: IntrinsicHeight(                 // hack to show verticaldivider, don't know why. Wrap the row
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          InkWell(
                            onTap: (){},
                            child: Row(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Text('bloco invisivel', style: TextStyle(fontSize: 8, color: Colors.grey[100]),), //hack to align
                                    Text("${globals.toGo.toStringAsFixed(0)}", style: TextStyle(fontSize: 35),),
                                  ],
                                ),
                                SizedBox(
                                  width: 7.0,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(globals.textToGo, style: TextStyle(fontSize: 11),),
                                    Text('ML', style: TextStyle(fontSize: 25),),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          VerticalDivider(color: Colors.black),
                          InkWell(
                            onTap: () {
                              _addGoal(context);
                            },
                            child: Row(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Text('bloco invisivel', style: TextStyle(fontSize: 8, color: Colors.grey[100]),),
                                    Text('${globals.goalDouble.toStringAsFixed(0)}', style: TextStyle(fontSize: 35),),
                                  ],
                                ),
                                SizedBox(
                                  width: 7.0,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('Goal', style: TextStyle(fontSize: 11),),
                                    Text('ML', style: TextStyle(fontSize: 25),),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }






}