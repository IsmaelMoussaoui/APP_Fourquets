import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:startup_namer/routes/NewProvider.dart';


class Forms
{
  Forms();

  Widget formsFields(Icon icon, String hint, String label, TextInputType keyboard, String name)
  {
    return TextFormField(
        decoration: InputDecoration(
            icon: icon,
            hintText: hint,
            labelText: label),
        keyboardType: keyboard,
        autofocus: false,
        onSaved: (value) {
          name = value;},
        validator: (name) {
          if (name.isEmpty)
            return 'Remplissez le champ';
          return null;
        }
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

  Widget dropButton(Icon icon, String txt, String dropValue, var items, Function(String) state)
  {
    return Container(
      child: DropdownButton(
        isExpanded: true,
        icon: icon,
        value: dropValue,
        hint: Text(txt),
        onChanged: state,
        items: items
      )
    );
  }

  Widget formsSaveButton(context, GlobalKey<FormState> formKey)
  {
    return FloatingActionButton.extended(
      onPressed: () {
        // Add your onPressed code here
      },
      tooltip: "Valider",
      key: formKey,
      elevation: 4,
      label: Text("Valider"),
      icon: Icon(Icons.check),
      backgroundColor: Color(0xFF004D40),
    );
  }

  Widget newText(String txt)
  {
    return Text(txt);
  }

  Widget switcher(bool isSwitched, Color activeAccentColor, Color activeColor, Function(bool) state)
  {
    return Switch(
      value: isSwitched,
      onChanged: state,
      activeTrackColor: activeAccentColor,
      activeColor: activeColor);
  }

  Widget buttonIconNew(context, String text, Icon icon)
  {
    return RaisedButton.icon(
      onPressed: (){ Navigator.push (
        context,
      MaterialPageRoute(builder: (context) => NewProvider()),);},
      icon: icon,
      label: Text(text),
    );
  }

}