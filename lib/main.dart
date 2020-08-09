import 'package:startup_namer/class/Provider.dart';
import 'package:startup_namer/routes/NewProduct.dart';
import 'package:startup_namer/routes/NewProvider.dart';
import 'class/Product.dart';
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
                buttonMenu(context, "Les Produits", Colors.white, Colors.teal, ProductRoute(), Icon(Icons.list)),
                Container(height: 12),
                buttonMenu(context, "Les Fournisseurs", Colors.white, Colors.deepPurple, ProviderRoute(), Icon(Icons.person)),
                Container(height: 12),
                buttonMenu(context, "Nouveau Produit", Colors.white, Colors.orange, NewProduct(), Icon(Icons.playlist_add)),
                Container(height: 12),
                buttonMenu(context, "Nouveau fournisseur", Colors.white, Colors.pink, NewProvider(), Icon(Icons.person_add))
              ],
            ),
          ),
        )
    );
  }
}