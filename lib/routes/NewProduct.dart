import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:startup_namer/widget/Forms.dart';

class NewProduct extends StatefulWidget
{
  @override
  _NewProduct createState() => _NewProduct();
}


class _NewProduct extends State<NewProduct>
{

  bool bakery = false;
  bool pastry = false;
  bool sell = false;
  bool isSwitched = false;
  DateTime date;
  File imageFile;
  dynamic save;
  String oui;
  String non;
  final _formKey = GlobalKey<FormState>();


  set setBakery(bool) {
    bakery = bool;
  }
  set setPastry(bool) {
    pastry = bool;
  }
  set setSell(bool) {
    sell = bool;
  }
  set setDate(DateTime){
    date = DateTime;
  }
  set setIsSwitched(bool){
    isSwitched = bool;
  }

  @override
  Widget build(BuildContext context)
  {
    List<String> category = ["Boisson", "Confiserie", "Décor", "Divers", "Emballage",
                        "Entretien", "Fruits", "Préparation","Surgelé", "Traiteur"];

    List<String> fruitCat = ["Fruit-Patisserie"];

    List<DropdownMenuItem<String>> catList = category.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(value)],
        ),
      );}).toList();

    List<DropdownMenuItem<String>> FruitList = fruitCat.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(value)],
        ),
      );}).toList();

    String name;
    var forms = new Forms();
    return Scaffold(
      appBar: AppBar(title: Text("Nouveau Produit")),
        body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Wrap(
                  children: <Widget>[
                    forms.formsFields(Icon(Icons.fastfood), "Nom du produit", "Produit", TextInputType.name, name),
                    forms.formsFields(Icon(Icons.work), "Nom du fournisseur", "Fournisseur", TextInputType.text, name),
                    forms.formsFields(Icon(Icons.attach_money), "Prix unitaire", "Prix", TextInputType.number, name),
                    forms.formsFields(Icon(Icons.monetization_on), "Prix global", "Prix global", TextInputType.number, name),
                    Container(height: 6),
                    forms.dropButton(Icon(Icons.category), "Categories", this.oui, catList, (String newValue) {setState(() {this.oui = newValue;});}),
                    if (this.oui == "Fruits")
                      forms.dropButton(Icon(Icons.person), "Sous-Categories", this.non, FruitList, (String furnish) {setState(() {this.non = furnish;});}),
                    Container(height: 6),
                    //forms.dropButton(Icon(Icons.person), "Fournisseurs", this.non, provid, (String furnish) {setState(() {this.non = furnish;});}),
                    Container(height: 12),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              forms.newText("Poste pour le produit : "),
                              forms.filterButton(bakery, Colors.green, Colors.greenAccent, "Boulangerie", (bool selected) {setState(() {setBakery = !bakery;});}),
                              forms.filterButton(pastry, Colors.blue, Colors.blueAccent, "Patisserie", (bool selected) {setState(() {setPastry = !pastry;});}),
                              forms.filterButton(sell, Colors.red, Colors.redAccent, "Vente", (bool selected) {setState(() {setSell = !sell;});}),]
                        )]
                    ),
                    Center(
                      child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              forms.newText("Une promotion sur un produit ?"),
                              forms.switcher(isSwitched, Colors.orangeAccent, Colors.orange, (bool selected) {setState(() {setIsSwitched = !isSwitched;});}),
                              if (isSwitched)
                                forms.newText("A implementer les dates Time  pour les promos"),
                              forms.formsSaveButton(context, _formKey)]
                      ),
                    ),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        forms.buttonIconNew(context, "Nouveau fournisseur", Icon(Icons.add))]
                    )]
              )
            )
          )
        )
      );
  }
}