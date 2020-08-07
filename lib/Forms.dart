import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class Forms
{
  String society;
  String productName;
  String commercialName;
  String numberPhone;
  String email;
  String unitPrice;
  String unit;

  Forms(){}

  Widget formsFields(Icon icon, String hint, String label, TextInputType keyboard, Function save(String name))
  {
    return TextFormField(
        decoration: InputDecoration(
            icon: icon,
            hintText: hint,
            labelText: label),
        keyboardType: keyboard,
        onSaved: save,
        validator: (name) {
          if (name.isEmpty)
            return 'Remplissez le champ';
          return null;
        }
    );
  }

  Widget formsSaveButton(context, GlobalKey<FormState> formKey)
  {
    return RaisedButton(
      child: Text("Ajouter"),
      onPressed: (){
        if (formKey.currentState.validate()){
          formKey.currentState.save();
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text(this.commercialName + " ajouté aux commerciaux")));
        }
      },
    );
  }

  Widget filterButton(bool selected, Color backgroundColor, Color selectedColor, String label, Function(bool) state)
  {
    return FilterChip(
        padding: EdgeInsets.all(10),
        selected: selected,
        label: Text(label),
        labelStyle: TextStyle(color: Colors.black),
        backgroundColor: backgroundColor,
        selectedColor: selectedColor,
        avatar: Text(label[0], style: TextStyle(color: Colors.black)),
        onSelected: state);
  }

  Widget dropButton(Color color, String dropValue, Icon icon, Function(String) state)
  {
    String dropdownValue = 'Fournisseur1';

    return DropdownButton<String>(
      value: dropdownValue,
      icon: icon,
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: color),
      underline: Container(
          height: 2),
      onChanged: state,
      items: <String>['Fournisseur1',
        'Fournisseur2',
        'Fournisseur3',
        'Fournisseur4'].map<DropdownMenuItem<String>>((String val) {
        return DropdownMenuItem<String>(
            value: val,
            child: Text(val));}).toList());
  }

}