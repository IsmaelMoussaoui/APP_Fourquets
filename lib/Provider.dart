import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class NewProvider extends StatefulWidget {
  NewProvider({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class contactProvider {
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

class _MyStatefulWidgetState extends State<NewProvider>
{
  final _formKey = GlobalKey<FormState>();
  var Contact = new contactProvider();

  @override
  Widget build(BuildContext context)
  {
    String _name;
    String _numberPhone;
    String _mail;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Container(
              width: 350,
              padding: EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      TextFormField(
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'Entrez le nom du commercial',
                          labelText: 'Nom'),
                        keyboardType: TextInputType.name,
                        validator: (name) {
                          _name = name;
                          if (_name.isEmpty)
                            return 'Remplissez le champ';
                          return null;
                        }
                      ),

                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.phone),
                          hintText: 'Entrez le numéro de téléphone du commercial',
                          labelText: 'Numéro'),
                        keyboardType: TextInputType.phone,
                        validator: (numberPhone){
                          _numberPhone = numberPhone;
                          if (_numberPhone.isEmpty)
                            return 'Remplissez le champ';
                          return null;
                        }
                      ),

                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.mail),
                          hintText: "Entrez l'adresse mail du commercial",
                          labelText: "Email"),
                        keyboardType: TextInputType.emailAddress,
                        validator: (mail){
                          _mail = mail;
                          if (_mail.isEmpty)
                            return 'Remplissez le champ';
                          return null;
                        }
                      ),

                      new Container(
                        padding: const EdgeInsets.all(10),
                        child: RaisedButton(
                          child: Text('Valider'),
                          onPressed: (){
                            if (_formKey.currentState.validate()){
                              Scaffold.of(context)
                                .showSnackBar(SnackBar(content: Text(_name + " ajouté aux commerciaux")));
                              }
                            },
                        ),
                      )


                    ]
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );

  }
}
