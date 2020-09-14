import 'package:commandes/database/ProductDatabase.dart';
import 'package:commandes/database/ProviderDatabase.dart';
import 'package:commandes/models/Product.dart';
import 'package:commandes/models/provider.dart';
import 'package:flutter/material.dart';

class AddProduct extends StatefulWidget
{
  final Product product;
  const AddProduct({Key key, this.product}) : super(key: key);

  @override
  _AddProduct createState() => _AddProduct(product);
}

class _AddProduct extends State<AddProduct>
{
  Product product;
  _AddProduct(this.product);
  String _prv;
  String _value   = "Kilogrammes";

  ///Variables relatives au poste de commandes
  bool pastry     = false;
  bool bakery     = false;
  bool sell       = false;

  int valPastry   = 1;
  int valBakery   = 2;
  int valSell     = 4;
  int totalValue  = 0;

  set setPastry(bool) {pastry = bool;}
  set setBakery(bool) {bakery = bool;}
  set setSell(bool) {sell = bool;}
  ///Variables et methodes relatives au poste de commandes

  final nameTextController = TextEditingController();
  final priceTextController = TextEditingController();
  final unitTextController = TextEditingController();
  final providerTextController = TextEditingController();


  @override
  void initState()
  {
    super.initState();
    if (product != null) {
      nameTextController.text = product.name;
      priceTextController.text = product.price;
      unitTextController.text = product.unit;
      providerTextController.text = product.provider;
    }
  }

  @override
  void dispose()
  {
    super.dispose();
    nameTextController.dispose();
    priceTextController.dispose();
    unitTextController.dispose();
    providerTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter un produit"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check), onPressed: () {
        if (bakery)
          totalValue += valBakery;
        if (pastry)
          totalValue += valPastry;
        if (sell)
          totalValue += valSell;

          var i = num.parse(priceTextController.text) * num.parse(unitTextController.text);
          _saveProduct(nameTextController.text, priceTextController.text, unitTextController.text, i.toStringAsFixed(2), providerTextController.text, totalValue.toString(), context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(21.0),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              children: <Widget> [
                TextFormField(decoration: InputDecoration(hintText: "Nom du produit"), controller: nameTextController),
                TextFormField(decoration: InputDecoration(hintText: "Prix du produit"), keyboardType: TextInputType.number, controller: priceTextController),
                TextFormField(decoration: InputDecoration(hintText: "Nombre d'unités"), keyboardType: TextInputType.number, controller: unitTextController),
                FutureBuilder<List<Provider>>(
                    future: ProviderDatabase.instance.retrieveProviders(),
                    builder: (context, snapshot){
                      if (!snapshot.hasData)
                        return CircularProgressIndicator();
                      if (snapshot.hasError)
                        return Text("Failed to load data");
                      return DropdownButton<String>(
                        hint: Text("Choisir un fournisseur"),
                        value: _prv,
                        items: snapshot.data.map((company) => DropdownMenuItem<String>(
                          child: Text(company.company), value: company.company)).toList(),
                        onChanged: (String newProv) {
                          setState(() {providerTextController.text = newProv;});
                          _prv = providerTextController.text;
                          },
                      );
                    }
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: DropdownButton(
                    value: this._value,
                    hint: Text("Choisir une unité de mesure"),
                    isExpanded: false,
                    items: [
                      DropdownMenuItem(
                        child: Text("Kilogrammes"),
                        value: "Kilogrammes",
                      ),
                      DropdownMenuItem(
                        child: Text("Grammes"),
                        value: "Grammes",
                      ),
                      DropdownMenuItem(
                        child: Text("Litres"),
                        value: "Litres",
                      ),
                      DropdownMenuItem(
                        child: Text("Centilitres"),
                        value: "Centilitres",
                      ),
                      DropdownMenuItem(
                        child: Text("Pièces"),
                        value: "Pièces",
                      ),
                    ],
                    onChanged: (value){
                      setState(() {
                        _value = value;
                      });},
                  ),
                ),
                Wrap(
                  spacing: 8,
                  children: <Widget>[
                    FilterChip(
                        padding: EdgeInsets.all(10),
                        selected: pastry,
                        pressElevation: 2,
                        label: Text("Patisserie", style: TextStyle(color: Colors.white)),
                        labelStyle: TextStyle(color: Colors.black),
                        backgroundColor: Colors.red,
                        selectedColor: Colors.redAccent,
                        avatar: Text('P', style: TextStyle(color: Colors.black)),
                        onSelected: (bool selected) {
                          setState(() {
                            setPastry = !pastry;
                          });
                        }
                    ),
                    FilterChip(
                        padding: EdgeInsets.all(10),
                        selected: bakery,
                        pressElevation: 2,
                        label: Text("Boulangerie", style: TextStyle(color: Colors.white)),
                        labelStyle: TextStyle(color: Colors.black),
                        backgroundColor: Colors.green,
                        selectedColor: Colors.greenAccent,
                        avatar: Text('B', style: TextStyle(color: Colors.black)),
                        onSelected: (bool selected) {
                          setState(() {
                            setBakery = !bakery;
                          });
                        }
                    ),
                    FilterChip(
                        padding: EdgeInsets.all(10),
                        selected: sell,
                        pressElevation: 2,
                        label: Text("Vente", style: TextStyle(color: Colors.white)),
                        labelStyle: TextStyle(color: Colors.black),
                        backgroundColor: Colors.blue,
                        selectedColor: Colors.blueAccent,
                        avatar: Text('V', style: TextStyle(color: Colors.black)),
                        onSelected: (bool selected) {
                          setState(() {
                            setSell = !sell;
                          });
                        }
                    ),
                  ],
                ),
              ]
            )
          )
        ),
      ),
    );
  }

  _saveProduct(String name, String price, String unit, String globalPrice, String provider, String posts, BuildContext context) async
  {
    if (product == null) {
      ProductDatabase.instance.insertProduct(
          Product(name: nameTextController.text, price: priceTextController.text,
              unit: unitTextController.text, globalPrice: globalPrice,
              provider: providerTextController.text, post: totalValue.toString()));
      Navigator.pop(context, "Le produit à été ajouté");
    } else {
      await ProductDatabase.instance.updateProduct(
          Product(id: product.id, name: name, unit: unit, globalPrice: globalPrice, price: price, provider: provider, post: posts));
      Navigator.pop(context);
    }
  }
}