import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async' show Future;

Widget CommandCard(String productName, String underCat, String providerName, String price)
{
  return Column(
      children: [ SingleChildScrollView(child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[

          Container(
            width: 350,
            padding: EdgeInsets.all(10),
            child: Card(
              child: Padding(
                padding: EdgeInsets.only(),
                child: ExpansionTile(
                  title: Text(productName),
                  children: <Widget>[
                    Text('Sous-Categorie : ' + underCat),
                    Text('Fournisseur : ' + providerName),
                    Text('Prix : ' + price + ' €'),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(

                            margin: EdgeInsets.only(top: 10, right: 15),
                            child: RaisedButton(child: Text("Supprimer"), onPressed: (){}, color: Colors.red, elevation: 10)),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child:  RaisedButton(child: Text("Modifier"), onPressed: (){}, color: Colors.blue, elevation: 10),
                          )
                        ]
                    )
                 ]
                )
            ),
          ),
          )
        ]
      )
    )
  ]);
}

class CommandRoute extends StatelessWidget
{
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> provider()
  {
    List<String> providerName = ["Mesmacques", "Vanderblabla", "toto"];
    return providerName;
  }

  List<String> underCat()
  {
    var bakery = "Boulangerie-";
    var pastry = "Patisserie-";
    var sell = "Vente-";

    List<String> underCat = [sell + "Entrerien", bakery + "Entretien"];
    return underCat;
  }

  List<String> product()
  {
    List<String> productName = ["Javel", "Donuts", "Baguette", "Emballage", "Framboise"];
    return productName;
  }

  Map fullProduct()
  {
    var prod = new Map();

    prod["Provider"] = "Mesmaques";
    prod["underCat"] = "Entretien-vente";
    prod["Price"] = "13,9";
    print(prod["Provider"]);
    return prod;
  }

  @override
  Widget build(BuildContext context) {
    var text = product();
    var t = fullProduct();
    return Scaffold(
        key: scaffoldKey,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                  for(var i in text)
                    Center(
                      child:
                        CommandCard(i, t["underCat"], t["Provider"], t["Price"])
                )
              ]
            )
          )
        )
    );
  }
}
