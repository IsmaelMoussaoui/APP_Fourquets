import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:startup_namer/class/Provider.dart';

class NewProvider extends StatefulWidget
{
  final Provider provider;
  const NewProvider({Key key, this.provider}) : super(key: key);

  @override
  _CreateNewProvider createState() => _CreateNewProvider(provider);
}

class _CreateNewProvider extends State<NewProvider>
{

  Provider provider;

  final nameTextController    = TextEditingController();
  final societyNameController = TextEditingController();
  final numberPhoneController = TextEditingController();
  final addressMailController = TextEditingController();

  _CreateNewProvider(this.provider);

  @override
  void initState() {
    super.initState();
      if (provider != null){
        nameTextController.text = provider.name;
        societyNameController.text = provider.societyName;
        addressMailController.text = provider.addressMail;
        numberPhoneController.text = provider.numberPhone;
    }
  }

  @override
  void dispose()
  {
    super.dispose();
    nameTextController.dispose();
    societyNameController.dispose();
    addressMailController.dispose();
    numberPhoneController.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    final _formKey = GlobalKey<FormState>();
    bool _autoValidate = false;

    return Scaffold(
      appBar: AppBar(title: Text("Nouveau fournisseur")),
      resizeToAvoidBottomPadding: true,
      body: Form(
        autovalidate: _autoValidate,
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:<Widget>[
                TextFormField(
                    decoration: InputDecoration(
                        icon: Icon(Icons.work),
                        labelText: "Nom de la société"),
                    controller: societyNameController,
                    validator: (value) {
                      if (value.isEmpty)
                        return 'Entrez le nom de la societe';
                      return null;
                    }
                ),
                TextFormField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: "Nom du commercial"),
                  controller: nameTextController,
                  validator: (value){
                    if (value.isEmpty)
                      return "Entrez le nom du fournisseur";
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.alternate_email),
                      labelText: "Adresse mail"),
                  controller: addressMailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty)
                      return 'Entrez l\'adresse mail du fournisseur';
                    return null;
                  }
                ),
                TextFormField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.phone),
                      labelText: "Numéro de telephone"),
                  controller: numberPhoneController,
                  keyboardType: TextInputType.number,
                  validator: (value){
                    if (value.isEmpty)
                      return "Entrez le numéro de téléphone";
                    return null;
                  },
                ),
                Expanded(
                  child: Align(
                      alignment: FractionalOffset.bottomCenter,
                        child : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: FloatingActionButton(
                            child: Icon(Icons.check),
                            onPressed: () async {
                              if (!_formKey.currentState.validate())
                                Scaffold.of(context).showSnackBar(SnackBar(content: Text("Renseignez les champs manquant")));
                            _saveProvider(
                              nameTextController.text,
                              societyNameController.text,
                              addressMailController.text,
                              numberPhoneController.text,
                            );
                          setState(() {});
                      }
                  ),
                )
                  ))]
          ),
        ),
      ),
    );
  }

  _saveProvider(String name, String societyName, String addressMail, String numberPhone) async {
    if (provider == null) {
      ProviderDataBase.instance.insertProvider(Provider(
          name: nameTextController.text,
          societyName: societyNameController.text,
          addressMail: addressMailController.text,
          numberPhone: numberPhoneController.text,
      ));
      Navigator.pop(context, "Le fournisseur à été ajouté");
    } else {
      await ProviderDataBase.instance
          .updateProvider(Provider(id: provider.id, name: name, societyName: societyName, addressMail: addressMail, numberPhone: numberPhone));
      Navigator.pop(context);
    }
  }

}
