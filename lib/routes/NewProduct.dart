import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:startup_namer/core/models/Provider.dart';
import 'package:startup_namer/database/ProviderDataBase.dart';
import 'package:startup_namer/database/ProductDataBase.dart';
import 'package:startup_namer/routes/NewProvider.dart';
import '../core/models/Product.dart';

class NewProduct extends StatefulWidget
{
  final Product product;
  const NewProduct({Key key, this.product}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateNewProduct(product);

}

class _CreateNewProduct extends State<NewProduct>
{

  _CreateNewProduct(this.product);

  bool pastry     = false;
  bool bakery     = false;
  bool sell       = false;

  int valPastry   = 1;
  int valBakery   = 2;
  int valSell     = 4;
  int totalValue  = 0;
  int price;

  Product product;
  Provider _prv;

  String _value   = "Kilogrammes";
  String selectedProv;
  String selectedUnit;
  String post;

  set setPastry(bool) {pastry = bool;}
  set setBakery(bool) {bakery = bool;}
  set setSell(bool) {sell = bool;}

  final nameTextController          = TextEditingController();
  final providerTextController      = TextEditingController();
  final unitTextController          = TextEditingController();
  final unitPriceTextController     = TextEditingController();
  final postTextController          = TextEditingController();
  final numberUnitTextController    = TextEditingController();
  final globalPriceTextController   = TextEditingController();


  @override
  void initState()
  {
    super.initState();
    if (product != null) {
      nameTextController.text         = product.name;
      providerTextController.text     = product.provider;
      unitTextController.text         = product.unit;
      unitPriceTextController.text    = product.unitPrice;
      postTextController.text         = product.post;
      numberUnitTextController.text   = product.numberUnit;
      globalPriceTextController.text  = product.globalPrice;
    }
  }

  @override
  void dispose()
  {
    super.dispose();
    nameTextController.dispose();
    providerTextController.dispose();
    unitTextController.dispose();
    unitPriceTextController.dispose();
    postTextController.dispose();
    numberUnitTextController.dispose();
    globalPriceTextController.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    final _formKey      = GlobalKey<FormState>();
    bool _autoValidate  = false;

    return Scaffold(
      appBar: AppBar(title: Text("Nouveau produit")),
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
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.fastfood),
                      labelText: "Nom du produit"),
                    controller: nameTextController,
                    validator: (value) {
                      if (value.isEmpty)
                        return 'Entrez le nom du produit';
                      return null;
                    }
                  ),
                  Container(height: 15),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.attach_money),
                      labelText: "Prix à l'unité"),
                    controller: unitPriceTextController,
                    keyboardType: TextInputType.number,
                    validator: (value){
                      if (value.isEmpty)
                        return "Entrez le prix unitaire";
                      return null;
                      },
                  ),
                  Container(height: 15),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.bubble_chart),
                            labelText: "Nombre d'unité"),
                    controller: numberUnitTextController,
                    keyboardType: TextInputType.number,
                    validator: (value)
                    {
                      if (value.isEmpty)
                        return "Entrez le nombre d'unité";
                      return null;
                  },
                ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          FutureBuilder<List<Provider>>(
                            future: ProviderDataBase.instance.fetchProvider(),
                            builder: (context, snapshot){
                            if (!snapshot.hasData)
                              return CircularProgressIndicator();
                            return DropdownButton<Provider>(
                              items: snapshot.data
                                      .map((provider) => DropdownMenuItem<Provider>(
                                child: Text(provider.societyName), value: provider)).toList(),
                              onChanged: (prov) {setState(() {_prv = prov;});},
                              isExpanded: false,
                              hint: Text("Choisir un fournisseur"),
                            );
                          }
                        ),
                          SizedBox(height: 20),
                          _prv != null ? Text(_prv.societyName):Text("Aucun fournisseur ajouté"),
                        ]
                      ),
                      Container(height: 15),
                      Wrap(
                        spacing: 8,
                        children: <Widget>[
                          FilterChip(
                            padding: EdgeInsets.all(10),
                            selected: pastry,
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
                      ]),
                      Container(height: 15),
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
                      RaisedButton(
                        child: Text("Nouveau Fournisseur"),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NewProvider())),
                      ),
                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: FloatingActionButton(
                              child: Icon(Icons.check),
                              onPressed: () async {
                                if (bakery)
                                  totalValue += valBakery;
                                if (pastry)
                                  totalValue += valPastry;
                                if (sell)
                                  totalValue += valSell;

                                print(unitPriceTextController.text);
                                print(numberUnitTextController.text); 
                                var a = double.parse(numberUnitTextController.text) * double.parse(unitPriceTextController.text);

                                globalPriceTextController.text = a.toStringAsFixed(2);
                                if (_formKey.currentState.validate())
                                  setState(() {
                                    selectedProv = _prv.societyName;
                                    selectedUnit = _value;
                                  });
                                _saveProduct(
                                    nameTextController.text,
                                    selectedProv,
                                    selectedUnit,
                                    unitPriceTextController.text,
                                    post,
                                    numberUnitTextController.text,
                                    globalPriceTextController.text
                                  );
                                setState(() {});
                              }
                             ),
                            )
                         )
                       ),
                     ]
                    ),
                  ),
                ),
              );
          }
   _saveProduct(String name, String provider, String unit, String unitPrice, String post, String numberUnit, String globalPrice) async {
    if (product == null) {
      ProductDataBase.instance.insertProduct(Product(name: nameTextController.text,
          provider: selectedProv, unit: this.selectedUnit, unitPrice: unitPriceTextController.text,
          post: this.post, numberUnit: this.numberUnitTextController.text, globalPrice: globalPriceTextController.text));
      setState(() {});
      Navigator.pop(context, "Le produit a ete ajouté");
    } else {
      await ProductDataBase.instance.updateProduct(Product(id: product.id,
          name: name, provider: provider, unit: unit, unitPrice: unitPrice,
          post: post, numberUnit: numberUnit, globalPrice: globalPrice));
      setState(() {});
      Navigator.pop(context);
    }
  }

}
