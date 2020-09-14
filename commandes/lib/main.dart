import 'package:commandes/models/Product.dart';
import 'package:commandes/views/Cart.dart';
import 'package:commandes/views/products/AddProduct.dart';
import 'package:commandes/views/products/ProductList.dart';
import 'package:commandes/views/products/SearchProduct.dart';
import 'package:commandes/views/providers/AddProvider.dart';
import 'package:commandes/views/providers/ProviderList.dart';
import 'package:commandes/views/providers/SearchProvider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  List<Product> _cart;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mes commandes',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/AddProduct': (context) => AddProduct(),
        '/ProductList': (context) => ProductList(),
        '/AddProvider': (context) => AddProvider(),
        '/ProviderList': (context) => ProviderList(),
        '/searchProduct': (context) => SearchProduct(),
        '/searchProvider': (context) => SearchProvider(),
      },
    );
  }
}
class MyHomePage extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes commandes"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add), onPressed: (){
          Navigator.pushNamed(context, '/AddProduct');
      },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(icon: Icon(Icons.list), onPressed: () {
              Navigator.pushNamed(context, '/ProductList');
            }),
            IconButton(icon: Icon(Icons.search), onPressed: () {
              Navigator.pushNamed(context, '/test');
            }),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text("Les produits"),
              onPressed: (){
                Navigator.pushNamed(context, '/ProductList');
              },
            ),
            RaisedButton(
              child: Text("Les fournisseurs"),
              onPressed: (){
                Navigator.pushNamed(context, '/ProviderList');
              },
            ),
          ],
        ),
      )
    );
  }
}
