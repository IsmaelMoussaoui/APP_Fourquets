import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

/// This is the stateful widget that the main application instantiates.
class NewProvider extends StatefulWidget {
  NewProvider({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class contactProvider
{
  String namep;
  String phoneNumberp;
  String emailp;

  String get name => namep;
  String get phoneNumber => phoneNumberp;
  String get email => emailp;

  set name(String value) {
    namep = value;
  }
  set phoneNumber(String value) {
    phoneNumberp = value;
  }
  set email(String value) {
    emailp = value;
  }
  save(){
    print("Sauve");
  }
  contactProvider({this.namep, this.emailp, this.phoneNumberp});
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<NewProvider>
{
  final _formKey = GlobalKey<FormState>();
  final Contact = new contactProvider();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            autofocus: true,
            decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: 'Nom du commercial',
                labelText: "Nom",
                contentPadding: EdgeInsets.all(20.0)
            ),
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value.isEmpty) {
                return 'Entrez un nom';
              }
              Contact.namep = value;
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
                icon: Icon(Icons.phone),
                hintText: "Numéro du commercial",
                labelText: "Numéro",
                contentPadding: EdgeInsets.all(20.0)
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              var potentialNumber = int.tryParse(value);
              if (potentialNumber == null) {
                return 'Entrez un numéro de téléphone';
              }
              Contact.phoneNumberp = value;
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.mail),
              hintText: "Adresse mail du commercial",
              labelText: "Email",
              contentPadding: EdgeInsets.all(20.0),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (!EmailValidator.validate(value)) {
                return 'Entrez une adresse email valide';
              }
              Contact.emailp = value;
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 35.0),
            child: RaisedButton(
              onPressed: () {
                final form = _formKey.currentState;
                if(form.validate()){
                  form.save();
                  Contact.save();
                }
              },
              child: Text('Ajouter'),
            ),
          ),
        ],
      ),
    );
  }
  _showDialog(BuildContext context) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Submitting form')));
  }
}
