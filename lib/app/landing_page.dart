import 'package:beba_agua_new/app/sign_in/sign_in_page.dart';
import 'package:beba_agua_new/service/auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'package:beba_agua_new/globals.dart' as globals;

class LandingPage extends StatefulWidget {
  LandingPage({@required this.auth});
  final AuthBase auth;

  @override
  _LandingPageState createState() => _LandingPageState();
}




class _LandingPageState extends State<LandingPage> {





  Future<Null> getSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    globals.day01 = preferences.getInt('day01') ?? 0;  // essa linha me fodeu, indispensavel pqp...
    print('Globals.day01 antes do if=  ${globals.day01}');  // eu nao colocava ela e esperava que o valor de day01 fosse igual ao day02.
    print('Globals.day02 antes do if=  ${globals.day02}'); // Mas tem que carregar e depois comparar. sem a linha day01 = 0 sempre.
    globals.listSwitchedinString = preferences.getStringList('listSwitchedinString') ?? [];
    globals.listTypeOfReminder = preferences.getStringList('listTypeOfReminder') ?? [];
    globals.listWarning = preferences.getStringList('listWarning') ?? [];
    globals.pressAttention01 = preferences.getBool('pressAttention01') ?? false;
    globals.pressAlarm01 = preferences.getBool('pressAlarm01') ?? false;
    globals.listSwitchedinString.forEach((element) => globals.listSwitched.add(element == 'false' ? false : true));

    if (globals.day01 != globals.day02) {

      preferences.clear();

      globals.presentValue = preferences.getDouble('presentValue') ?? 0;
      globals.percentual = preferences.getDouble('percentual') ?? 0;
      globals.complementar = preferences.getDouble('complementar') ?? 100;
      globals.goalDouble = preferences.getDouble('goalDouble') ?? 2000;
      globals.toGo = preferences.getDouble('toGo') ?? 2000;
      globals.bottle = preferences.getDouble('bottle') ?? 200;
      globals.initialValue = preferences.getDouble('initialValue') ?? 0;
      globals.textToGo = preferences.getString('textToGo') ?? 'To Go';
      globals.isFirstLoaded01 = preferences.getBool('isFirstLoaded01') ?? true;
      globals.isFirstLaunch = preferences.getBool('isFirstLaunch') ?? false;
      globals.pressAttention01 = preferences.getBool('pressAttention01') ?? false;
      globals.pressAlarm01 = preferences.getBool('pressAlarm01') ?? false;

      print('get shared preferences acionada');
      preferences.setInt('day01', globals.d01.day);
      globals.day01 = preferences.getInt('day01');
      print('Globals.day01 =  ${globals.day01}');              // DAYS BECOME EQUALS, THEN EVERY TIME APP STARTS IT GOES TO THE ELSE BRANCH
      print('Globals.day02 =  ${globals.day02}');



      print('if branch');

    }
    else {


      print('Globals.day01 INICIAL=  ${globals.day01}');
      globals.presentValue = preferences.getDouble('presentValue') ?? 0;
      globals.percentual = preferences.getDouble('percentual') ?? 0;
      globals.complementar = preferences.getDouble('complementar') ?? 100;
      globals.goalDouble = preferences.getDouble('goalDouble') ?? 2000;
      globals.toGo = preferences.getDouble('toGo') ?? 2000;
      globals.bottle = preferences.getDouble('bottle') ?? 200;
      globals.initialValue = preferences.getDouble('initialValue') ?? 0;
      globals.textToGo = preferences.getString('textToGo') ?? 'To Go';
      globals.isFirstLoaded01 = preferences.getBool('isFirstLoaded01') ?? true;
      globals.isFirstLaunch = preferences.getBool('isFirstLaunch') ?? false;
      globals.pressAttention01 = preferences.getBool('pressAttention01') ?? false;
      globals.pressAlarm01 = preferences.getBool('pressAlarm01') ?? false;
      globals.storedHour = preferences.getInt('storedHour') ?? 0;
      globals.storedMinute = preferences.getInt('storedMinute') ?? 0;

      print('else branch');
      print('PressAttention01: ${globals.pressAttention01}');
      print('PressAlarm01: ${globals.pressAlarm01}');

    }




  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSharedPreferences();

  }





  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: widget.auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            if (user == null) {
              return SignInPage(
                auth: widget.auth,
              );
            }
              return LocalNotificationWidget(
                auth: widget.auth,
              );


          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        }
    );
  }
}
