import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'routes.dart';
import 'command.dart';
import 'Provider.dart';
import 'product.dart';

void main() {
  runApp(MaterialApp(
    title: 'Gestion de la boulangerie',
    theme: new ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF212121),
      accentColor: const Color(0xFF64ffda),
      canvasColor: const Color(0xFF303030),
    ),
    home: FirstRoute()
  ));
}

Widget newProvider(context)
{
  return Container(
    child: FloatingActionButton(
      heroTag: "btn1",
      onPressed: () {
          Navigator.push(
            context, MaterialPageRoute(builder: (context) => newProviderRoute()));
  },
      backgroundColor: Colors.lightBlueAccent,
      tooltip: 'Ajouter un fournisseur',
      child: Icon(Icons.perm_identity),
    ),
  );
}

Widget newProduct(context)
{
  return Container(
    child: FloatingActionButton(
      heroTag: "btn2",
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => newProductRoute()));
      },
      backgroundColor: Colors.lightBlue,
      tooltip: 'Ajouter un produit',
      child: Icon(Icons.fastfood),
    ),
  );
}


class FirstRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Gestion des commandes')),
        floatingActionButton: AnimatedFloatingActionButton(
          fabButtons: <Widget>[
            newProvider(context), newProduct(context)
          ],
          colorStartAnimation: Colors.blue,
          colorEndAnimation: Colors.blueAccent,
          animatedIconData: AnimatedIcons.menu_close,
      ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                'Gestion des commandes',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                  fontFamily: 'Roboto',
                ),
              ),
              new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new RaisedButton(
                            padding: const EdgeInsets.all(8.0),
                            textColor: Colors.white,
                            color: Colors.blue,
                            elevation: 3,
                            onPressed: () {
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (
                                  context) => CommandRoute()));
                            },
                            child: Text("Commande")),
                        new RaisedButton(padding: const EdgeInsets.all(8.0),
                            textColor: Colors.white,
                            color: Colors.teal,
                            elevation: 3,
                            onPressed: () {
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (
                                  context) => CategoryRoute()));
                            },
                            child: Text("Categories")),
                        new RaisedButton(
                            padding: const EdgeInsets.all(8.0),
                            textColor: Colors.white,
                            color: Colors.purple,
                            elevation: 3,
                            onPressed: () {
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (
                                  context) => PosteCommandeRoute()));
                            },
                            child: Text("Poste de commande")),
                      ]),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new RaisedButton(onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (
                            context) => ProductRoute()));
                      },
                          elevation: 3,
                          textColor: Colors.white,
                          color: Colors.red,
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Produits")),
                      new RaisedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (
                                context) => RateRoute()));
                          },
                          textColor: Colors.white,
                          color: Colors.green,
                          elevation: 3,
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Tarifs")),
                      new RaisedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (
                                context) => ProviderRoute()));
                          },
                          textColor: Colors.white,
                          color: Colors.amber,
                          elevation: 3,
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Fournisseurs")),
                    ],
                  )
                ],
              )
            ],
          ),
        )
    );
  }
}