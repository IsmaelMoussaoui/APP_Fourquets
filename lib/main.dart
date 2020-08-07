import 'package:startup_namer/Database/memo/database.dart';
import 'package:startup_namer/Database/memo/meme.dart';
import 'package:startup_namer/routes/NewProduct.dart';
import 'package:startup_namer/routes/NewProvider.dart';

import 'class/Product.dart';
import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


void main()
{
  runApp(MaterialApp(
    title: "Gestion des commandes",
    routes: {'/NewProduct': (context) => NewProduct(), '/NewProvider': (context) => NewProvider()},
    theme: new ThemeData(
      brightness: Brightness.light,
      primaryColor: Color(0xFF004D40),
      accentColor: Color(0xFF009688)),
    home: FirstRoute()));
}

Widget buttonMenu(context, String name, Color colorText, Color colorButton, StatefulWidget route, Icon icon)
{
  return RaisedButton(
      padding: const EdgeInsets.all(20.0),
      textColor: colorText,
      elevation: 12,
      color: colorButton,
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (
            context) => route));
      },
      child: Column(
        children: <Widget>[
          icon,
          Text(name)
        ],
      ));
}

class FirstRoute extends StatelessWidget
{
  MemoDbProvider memo = MemoDbProvider();
  final mem = MemoModel(
    title: "oui",
    content: 'baj nna');

  var ss;
  int i = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Gestion des commandes"), centerTitle: true,),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                buttonMenu(context, "Les Produits", Colors.white, Colors.teal, ProductRoute(), Icon(Icons.category)),
                Container(height: 12),
                buttonMenu(context, "Les Fournisseurs", Colors.white, Colors.deepPurple, ProductRoute(), Icon(Icons.person_outline)),
                RaisedButton(
                  child: Text("oui"),
                  onPressed: () async {
                    memo.addItem(mem);
                    memo.deleteMemo(47);
                    ss = await memo.fetchMemos();
                    print(ss);
                    for (final e in ss) {
                      i++;
                      print(e.id);
                      print(e.title);
                      print(i);
                    }
                    i = 0;
                  },
                  elevation: 12,
                ),
              ],
            ),
          ),
        )
    );
  }
}