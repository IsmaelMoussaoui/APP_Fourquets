import 'package:flutter/material.dart';
import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';


class CommandRoute extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.only(top: 36.0, left: 6.0, right: 6.0, bottom: 6.0),
            child: ExpansionTile(
              title: Text('Naissance de l\'univers'),
              children: <Widget>[
                Text('Big Bang'),
                Text('Birth of Sun'),
                Text('Earth is Born')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
