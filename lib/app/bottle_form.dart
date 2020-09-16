import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beba_agua_new/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../globals.dart';


class BottleForm extends StatefulWidget {

  @override
  _BottleFormState createState() => _BottleFormState();
}

class _BottleFormState extends State<BottleForm> {
  final TextEditingController _bottleController = TextEditingController();




  addDoubleToSP03() async{

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setDouble('bottle', globals.bottle);
    print('New bottle: ${globals.bottle}');

  }







  void _submit (){

    globals.bottleString = _bottleController.text;
    print('Este é o String Bottle : ${globals.bottleString}');
    globals.bottle = (double.parse(globals.bottleString));
    addDoubleToSP03();



    Navigator.of(context).pop();

    //  print('goal: ${_goalController.text}');

  }

  List<Widget> _buildChildren(){
    return[
      SizedBox(
        height: 10,
      ),
      TextField(
        controller: _bottleController,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 35.0),
        decoration: InputDecoration(
          hintText: 'Choose Quantity',
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
      ),
      SizedBox(
        height: 20,
      ),
      Text('HINT: Put here your bottle size. In a regular glass we have 200 ml for example.')
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
