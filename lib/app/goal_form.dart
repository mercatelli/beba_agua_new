import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beba_agua_new/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../globals.dart';


class GoalForm extends StatefulWidget {

  @override
  _GoalFormState createState() => _GoalFormState();
}

class _GoalFormState extends State<GoalForm> {
  final TextEditingController _goalController = TextEditingController();



  void calculatePLUS02() {


    setState(()  {



      if (globals.presentValue == 0.0) {
        globals.presentValue = globals.initialValue + globals.bottle;


      } else {
        globals.presentValue = globals.presentValue;
      }

      if (globals.presentValue == 0.0) {
        globals.percentual = 0;


      }

      else {
        globals.percentual = (globals.presentValue / globals.goalDouble)*100.0;
      }


        globals.complementar = (100 - globals.percentual);

      if (globals.complementar < 0.0) {
        globals.complementar = 0.0;


      }


      globals.toGo = globals.goalDouble - globals.presentValue;


    }



    );

    globals.presentValueString = "${globals.presentValue.toStringAsFixed(2)}";

  }



  addDoubleToSP02() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setDouble('presentValue', globals.presentValue);
    await preferences.setDouble('percentual', globals.percentual);
    await preferences.setDouble('complementar', globals.complementar);
    await preferences.setDouble('goalDouble', globals.goalDouble);
    await preferences.setDouble('toGo', globals.toGo);
    await preferences.setDouble('bottle', globals.bottle);
    await preferences.setDouble('initialValue', globals.initialValue);
    print('Globals Goal: ${globals.goalDouble}');
    print("Bebeu ${globals.presentValue} ML");
    print("Percentual ${globals.percentual} %");
    print("Complementar ${globals.complementar} %");
    print('toGo : ${globals.toGo}');
  }


  generateData02() {



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
  }


  checkExtra02() async{

    if (globals.goalDouble - globals.presentValue >= 0 ) {
      globals.textToGo = 'To Go';
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString('textToGo', globals.textToGo);
    }

    else{
      globals.toGo = -globals.toGo;
      globals.textToGo = 'Extra';
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString('textToGo', globals.textToGo);

    }

  }

  void _submit (){

    globals.goal = _goalController.text;
    print('Este é o goal em String : ${globals.goal}');
    globals.goalDouble = (double.parse(globals.goal));
    calculatePLUS02();
    addDoubleToSP02();
    checkExtra02();

    globals.piedata = [
      new Task('Water', globals.percentual, globals.colorPainted),
      new Task('Empty', globals.complementar, globals.colorNotPainted),
    ];

    globals.seriesPieData = List<charts.Series<Task, String>>();
    generateData02();
    print('First Task ${globals.piedata.first.taskvalue}');
    print('Last Task ${globals.piedata.last.taskvalue}');
    Navigator.of(context).pop();

  //  print('goal: ${_goalController.text}');

  }

  List<Widget> _buildChildren(){
    return[
      SizedBox(
        height: 10,
      ),
      TextField(
        controller: _goalController,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 35.0),
        decoration: InputDecoration(
          hintText: 'Set Goal',
        ),
      ),
      SizedBox(
        height: 10,
      ),
      Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: (){},
              child: Text('oz')
          ),
          InkWell(
              onTap: (){},
              child: Text('ml')
          ),
          InkWell(
              onTap: (){},
              child: Text('L')
          ),

        ],
      ),

      SizedBox(
        height: 20,
      ),
      RaisedButton(
        color: Colors.limeAccent,
        child: Text('SAVE'),
        onPressed: _submit,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(),
      ),
    );
  }
}
