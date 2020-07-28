import 'package:flutter/material.dart';
import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';

Widget float1()
{
  return Container(
    child: FloatingActionButton(
      heroTag: "fl2",
      onPressed: null,
      tooltip: 'FirstButton',
      child: Icon(Icons.add),
    ),
  );
}

Widget float2()
{
  return Container(
    child: FloatingActionButton(
      heroTag: "fl1",
      onPressed: null,
      tooltip: 'Second',
      child: Icon(Icons.add),
    ),
  );
}

class CommandRoute extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("oui"),
      ),
    );
  }
}
