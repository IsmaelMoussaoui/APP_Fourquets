import 'package:flutter/material.dart';
import 'package:startup_namer/database/ProviderDataBase.dart';
import 'package:startup_namer/routes/FiltredByProvider.dart';
import 'package:startup_namer/routes/NewProvider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Product.dart';


class Provider
{
  ///Attributes for Provider
  int id;
  String name;
  String addressMail;
  String numberPhone;
  String societyName;
  ///End of attributes Provider

  ///Constructor for provider
  Provider({this.id, this.name, this.addressMail, this.numberPhone, this.societyName});

  Map<String, dynamic> toMap()
  {
    return <String, dynamic>
    {
      "id": id,
      "name": name,
      "addressMail": addressMail,
      "numberPhone": numberPhone,
      "societyName": societyName,
    };
  }
}

class ProviderRoute extends StatefulWidget
{
  @override
  _ProviderRoute createState() => _ProviderRoute();
}

class _ProviderRoute extends State<ProviderRoute>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Fournisseurs")),
        body: FutureBuilder<List<Provider>>(
            future: ProviderDataBase.instance.fetchProvider(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ExpansionTile(
                          title: Text(snapshot.data[index].societyName),
                          children: <Widget>[
                            Text(snapshot.data[index].name),
                            Text(snapshot.data[index].addressMail),
                            Text(snapshot.data[index].numberPhone),
                            RaisedButton.icon(
                                onPressed: () async {
                                  _navigateToProvider(context, snapshot.data[index].societyName);
                                },
                                color: Colors.teal,
                                icon: Icon(Icons.list, color: Colors.white),
                                label: Text("Liste des produits de " + snapshot.data[index].societyName,
                                  style: TextStyle(color: Colors.white),)),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                RaisedButton.icon(
                                  icon: Icon(Icons.delete, color: Colors.white),
                                  label: Text("Supprimer",
                                    style: TextStyle(color: Colors.white)),
                                  color: Colors.red,
                                  onPressed: () async {
                                    ProviderDataBase.instance.deleteProvider(
                                      snapshot.data[index].id);
                                    setState(() {});
                                  }),
                              RaisedButton.icon(
                                icon: Icon(Icons.edit, color: Colors.white),
                                label: Text("Modifier",
                                  style: TextStyle(color: Colors.white)),
                                color: Colors.green,
                                onPressed: () async {
                                  _navigateToDetail(context, snapshot.data[index]);
                                  setState(() {});
                                }),
                              RaisedButton.icon(
                                icon: Icon(Icons.phone, color: Colors.white),
                                label: Text("Téléphone", style: TextStyle(color: Colors.white),),
                                color: Colors.blue,
                                onPressed: () async => {
                                  launch("tel://" + snapshot.data[index].numberPhone.toString())}),
                            ]
                      ),
                    ]));
                  },
                );
              } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return Text(snapshot.error);
              } else if (!snapshot.hasData)
                return Center(child: Text("Il n'y a aucun fournisseur pour le moment"));
              return CircularProgressIndicator();
            }
        )
    );
  }

  _navigateToDetail(BuildContext context, Provider provider) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewProvider(provider: provider)),
    );
    setState(() {});
  }

  _navigateToProvider(BuildContext context, String provider) async
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => FiltredByProvider(provider: provider)));
    setState(() {});
  }

}