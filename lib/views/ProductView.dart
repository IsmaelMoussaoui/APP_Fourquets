import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:startup_namer/core/models/Cart.dart';
import 'package:startup_namer/core/models/Product.dart';
import 'package:startup_namer/core/models/Provider.dart';
import 'package:startup_namer/database/ProductDataBase.dart';
import 'package:startup_namer/routes/FiltredByProvider.dart';
import 'package:startup_namer/routes/NewProduct.dart';
import 'package:startup_namer/views/CartView.dart';

class ProductRoute extends StatefulWidget
{
  @override
  _ProductRoute createState() => _ProductRoute();
}

class _ProductRoute extends State<ProductRoute>
{
  int i;
  Color myColor;
  Product product;
  bool isSelected = false;

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
        appBar: AppBar(title: Text("Produits")),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: (){ Navigator.push(
              context, MaterialPageRoute(builder: (
              context) => NewProduct()));},
          tooltip: "Ajouter",
          child: Icon(Icons.add),
          elevation: 2,
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: (){
                  MaterialPageRoute(builder: (context) => ProviderRoute());
                },
                iconSize: 30,
                color: Colors.white,
              ),
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CartView()));
                },
                iconSize: 30,
                color: Colors.white,
              ),
              IconButton(
                icon: Icon(Icons.sync),
                onPressed: (){
                  setState(() {
                    ProductDataBase.instance.fetchProduct();
                  });
                },
                iconSize: 30,
                color: Colors.white,
              )
            ],
          ),
          shape: CircularNotchedRectangle(),
          color: Color(0xFF004D40),
        ),
        body: FutureBuilder<List<Product>>(
            future: ProductDataBase.instance.fetchProduct(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, index) {
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                            child: Container(
                              width: 150,
                              height: 150,
                              child: Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ListTile(
                                          leading: const Icon(Icons.info),
                                          title: Text('${snapshot.data[index].name}           ${snapshot.data[index].globalPrice}€'),
                                          subtitle: Text( 'Fournisseur : ${snapshot.data[index].provider} \n'
                                              'Prix a l\'unité : ${snapshot.data[index].unitPrice}€ /\ ${snapshot.data[index].unit} \n'
                                              'Nombre d\'unité : ${snapshot.data[index].numberUnit}'),
                                          isThreeLine: true,
                                          trailing: PopupMenuButton<int>(
                                            itemBuilder: (context) => [
                                              PopupMenuItem(value: 1, child: Text("Modifier")),
                                              PopupMenuItem(value: 2, child: Text("Supprimer")),
                                              PopupMenuItem(value: 3, child: Text("Autres produits du fournisseur")),
                                              PopupMenuItem(value: 4, child: Text("Ajouter au panier"))
                                            ],
                                            onSelected: (value){
                                              if (value == 1)
                                                _navigateToDetail(context, snapshot.data[index]);
                                              setState(() {});
                                              if (value == 2)
                                                ProductDataBase.instance.deleteProduct(snapshot.data[index].id);
                                              setState(() {});
                                              if (value == 3)
                                                _navigateToProvider(context, snapshot.data[index].provider);
                                              setState(() {});
                                              if (value == 4)
                                                cartPreference('name', snapshot.data[index].name);
                                            },
                                          ),
                                        ),
                                      ]
                                  ),
                                ),
                              ),
                            )
                        )
                    );
                  },
                );
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Text("Fail");
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }
        )
    );
  }

  refreshProduct()
  {
    setState(() {
      ProductDataBase.instance.fetchProduct();
    });
  }

  cartPreference(String key, String value) async
  {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(key, value);
  }

  _navigateToDetail(BuildContext context, Product product) async
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NewProduct(product: product)));
    setState(() {});
  }

  _navigateToProvider(BuildContext context, String provider) async
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => FiltredByProvider(provider: provider)));
    setState(() {});
  }
}

