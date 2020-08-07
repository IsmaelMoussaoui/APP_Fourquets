import 'package:flutter/material.dart';

class BottomBar
{
  Widget bottomBar()
  {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: Container(
        height: 100,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              iconSize: 50,
              padding: EdgeInsets.only(left: 28),
              icon: Icon(Icons.edit),
              onPressed: (){},
            )
          ],
        ),
      ),
    );
  }
}