import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:startup_namer/core/models/Product.dart';
import 'package:startup_namer/database/ProductDataBase.dart';

class FiltredByProvider extends StatefulWidget
{
  final String provider;
  const FiltredByProvider({Key key, this.provider}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FiltredByProvider(provider);
}

class _FiltredByProvider extends State<FiltredByProvider>
{
  String provider;
  _FiltredByProvider(this.provider);
  bool isSelected = false;
  Color mycolor;

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(title: Text("Produits")),
      body: FutureBuilder<List<Product>>(
        future: ProductDataBase.instance.fetchProductByProvider(provider),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onLongPress: () {
                      toggleSelection();
                    },
                      child: Container(
                        width: 190,
                        height: 190,
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(selected: isSelected,
                                        leading: const Icon(Icons.info),
                                        title: Text(snapshot.data[index].name),
                                        subtitle: Text('Fournisseur : ${snapshot.data[index].provider} \n'
                                                       'Prix a l\'unité : ${snapshot.data[index].unitPrice}€ /\ ${snapshot.data[index].unit} \n'
                                                       'Nombre d\'unité : ${snapshot.data[index].numberUnit}'),
                                        isThreeLine: true,
                                        trailing: Text(snapshot.data[index].globalPrice + '€'),
                                        onLongPress: toggleSelection
                                    ),
                              ButtonTheme.bar(
                                  child: ButtonBar(
                                    children: <Widget>[
                                      FlatButton(
                                        child: const Text('Editer', style: TextStyle(color: Colors.black)),
                                        onPressed: () {},
                                      ),
                                      FlatButton(
                                        child: const Text('Supprimer', style: TextStyle(color: Colors.black)),
                                        onPressed: () {},
                                  ),
                                ],
                              ),
                            ),
                          ]
                        ),
                      ),
                    ),
                  ),
                )
              );
            }
          );
        } else if (snapshot.hasError) {
            print(snapshot.error);
            return Text("Fail");
          } else if (!snapshot.hasData)
              return Center(child: Text("Il n'y a aucun produit pour ce fournisseur"));
            return CircularProgressIndicator();
        }
      )
    );
  }

  void toggleSelection() {
    setState(() {
      if (isSelected) {
        mycolor=Colors.white;
        isSelected = false;
      } else {
        mycolor=Colors.grey[300];
        isSelected = true;
      }
    });
  }
}