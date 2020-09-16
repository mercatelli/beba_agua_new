import 'package:flutter/material.dart';

import 'bottle_form.dart';




class bottlePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose your Bottle'),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
           child: BottleForm(),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}