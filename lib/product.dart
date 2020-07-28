import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'Provider.dart';

/// This is the stateful widget that the main application instantiates.
class NewProduct extends StatefulWidget
{
  NewProduct({Key key}) : super(key: key);

  get _bakery => false;
  get _pastry => false;
  get _sell   => false;

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<NewProduct>
{
  final _formKey = GlobalKey<FormState>();

  // ignore: non_constant_identifier_names
  contactProvider Contact = new contactProvider();
  String dropdownValue = 'Fournisseur1';
  bool _bakery  = false;
  bool _pastry  = false;
  bool _sell    = false;

  set setBakery(bool){
    _bakery = bool;
  }
  set setPastry(bool){
    _pastry = bool;
  }
  set setSell(bool){
    _sell = bool;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
                icon: Icon(Icons.fastfood),
                hintText: 'Nom ou Reference du produit',
                labelText: "Nom",
                contentPadding: EdgeInsets.all(20.0)
            ),
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value.isEmpty) {
                return 'Entrez une valeur';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
                hintText: "Prix Unitaire",
                labelText: "Prix",
                icon: Icon(Icons.attach_money),
                contentPadding: EdgeInsets.all(20.0)
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value.isEmpty) {
                return 'Entrez un prix';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.functions),
              hintText: "Unité de mesure",
              labelText: "Unité",
              contentPadding: EdgeInsets.all(20.0),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value.isEmpty) {
                return 'Entrez une unite de mesure';
              }
              return null;
            },
          ),
          new Wrap(
             crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              FilterChip(
                  selected: _bakery,
                  label: Text('Boulangerie'),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: Colors.teal,
                  selectedColor: Colors.tealAccent,
                  avatar: Text('B', style: TextStyle(color: Colors.white)),
                  onSelected: (bool selected) {
                    setState(() {
                      setBakery = !_bakery;
                     }
                    );
                  }
              ),
              FilterChip(
                  selected: _pastry,
                  label: Text('Pâtisserie'),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: Colors.green,
                  selectedColor: Colors.greenAccent,
                  avatar: Text('P', style: TextStyle(color: Colors.white)),
                  onSelected: (bool selected) {
                      setState(() {
                        setPastry = !_pastry;
                      });
                  }
              ),
              FilterChip(
                selected: _sell,
                label: Text('Vente'),
                labelStyle: TextStyle(color: Colors.white),
                backgroundColor: Colors.pink,
                selectedColor: Colors.pinkAccent,
                avatar: Text('V', style: TextStyle(color: Colors.white)),
                onSelected: (bool selected){
                  setState(() {
                    setSell = !_sell;
                  });
                },
              ),
              new DropdownButton<String>(
                value: dropdownValue,
                icon: Icon(Icons.person),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.deepOrange),
                underline: Container(
                  height: 2,
                  color: Colors.deepOrangeAccent,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items: <String>['Fournisseur1', 'Fournisseur2', 'Fournisseur3', 'Fournisseur4'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                  );
                }).toList(),
              )
          ]),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 35.0),
            child: RaisedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState.validate()) {
                  // Process data.
                }
              },
              child: Text('Ajouter'),
            ),
          ),
        ],
      ),
    );
  }
}
