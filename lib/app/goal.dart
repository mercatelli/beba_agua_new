import 'package:flutter/material.dart';
import 'goal_form.dart';



class goalPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose your GOAL'),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: GoalForm(),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}