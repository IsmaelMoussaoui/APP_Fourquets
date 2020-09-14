import 'package:commandes/database/ProductDatabase.dart';
import 'package:commandes/database/ProviderDatabase.dart';
import 'package:commandes/models/Product.dart';
import 'package:commandes/models/provider.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class AddProvider extends StatefulWidget
{
  final Provider provider;
  const AddProvider({Key key, this.provider}) : super(key: key);

  @override
  _AddProvider createState() => _AddProvider(provider);
}

class _AddProvider extends State<AddProvider>
{
  Provider provider;
  _AddProvider(this.provider);

  final nameTextController = TextEditingController();
  final companyTextController = TextEditingController();
  final mailTextController = TextEditingController();
  final phoneTextController = TextEditingController();

  @override
  void initState()
  {
    super.initState();
    if (provider != null) {
      nameTextController.text = provider.name;
      companyTextController.text = provider.company;
      mailTextController.text = provider.mail;
      phoneTextController.text = provider.phone;
    }
  }

  @override
  void dispose()
  {
    super.dispose();
    nameTextController.dispose();
    companyTextController.dispose();
    mailTextController.dispose();
    phoneTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter un fournisseur"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check), onPressed: (){
        _saveProvider(nameTextController.text, companyTextController.text, mailTextController.text, phoneTextController.text, context);
      },
      ),
      body: Padding(
        padding: const EdgeInsets.all(21.0),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              children: <Widget> [
                TextFormField(decoration: InputDecoration(hintText: "Nom du fournisseur"), controller: nameTextController),
                TextFormField(decoration: InputDecoration(hintText: "Nom de la société"), controller: companyTextController),
                TextFormField(decoration: InputDecoration(hintText: "Mail de la société"), keyboardType: TextInputType.emailAddress, controller: mailTextController),
                TextFormField(decoration: InputDecoration(hintText: "Numéro du fournisseur"), keyboardType: TextInputType.phone, controller: phoneTextController),

              ],
            ),
          ),
        ),
      ),
    );
  }

  _saveProvider(String name, String company, String mail, String phone, BuildContext context) async
  {
    if (provider == null) {
      ProviderDatabase.instance.insertProvider(
          Provider(name: nameTextController.text, company: companyTextController.text, mail: mailTextController.text, phone: phoneTextController.text));
      Navigator.pop(context, "Le fournisseur à été ajouté");
    } else {
      await ProviderDatabase.instance.updateProvider(
          Provider(id: provider.id, name: name, company: company, mail: mail, phone: phone));
      Navigator.pop(context);
    }
  }
}