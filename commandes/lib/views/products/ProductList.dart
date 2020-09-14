import 'package:badges/badges.dart';
import 'package:commandes/database/ProductDatabase.dart';
import 'package:commandes/models/Product.dart';
import 'package:commandes/views/Cart.dart';
import 'package:commandes/views/products/AddProduct.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';

class ProductList extends StatefulWidget
{
  @override
  _ProductList createState() => _ProductList();
}

class _ProductList extends State<ProductList>
{
  List<Product> _cartList = List<Product>();

  TextEditingController editingController = TextEditingController();

  String convertPostToString(String posts, String stringPosts)
  {
    switch(posts){
      case '1':
        stringPosts = 'Patisserie';
        break;
      case '2':
        stringPosts = 'Boulangerie';
        break;
      case '3':
        stringPosts = 'Patisserie/Boulangerie';
        break;
      case '4':
        stringPosts = 'Vente';
        break;
      case '5':
        stringPosts = 'Patisserie/vente';
        break;
      case '6':
        stringPosts = 'Boulangerie/Vente';
        break;
      case '7':
        stringPosts = 'Patisserie/Boulangerie/Vente';
        break;
    }
    return stringPosts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Les produits"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add), onPressed: () {
            Navigator.pushNamed(context, '/AddProduct');
          },
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(icon: Icon(Icons.search), onPressed: () {
                Navigator.pushNamed(context, '/searchProduct');
              }),
              IconButton(icon: Icon(Icons.sync), onPressed: () {
                _refreshPage();
              }),
              Badge(
                badgeContent: Text(_cartList.length.toString()),
                padding: EdgeInsets.all(8),
                badgeColor: Colors.tealAccent,
                child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Cart(_cartList)));
                  }),
              ),
              IconButton(icon: Icon(Icons.person), onPressed: () {
                Navigator.pushNamed(context, '/ProviderList');
              }),
            ],
          ),
        ),
      body: FutureBuilder<List<Product>>(
        future: ProductDatabase.instance.retrieveProducts(),
        builder: (context, snapshot){
          if (snapshot.hasData){
            return Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index){
                          String post;
                          post = convertPostToString(snapshot.data[index].post, post);
                          return ListTile(
                            title: Text(snapshot.data[index].globalPrice + '€'),
                            subtitle: Text(snapshot.data[index].name + '\n' + snapshot.data[index].price + ' ' + snapshot.data[index].provider + ' ' + post),
                            isThreeLine: true,
                            onLongPress: () async {
                              ProductDatabase.instance.deleteProduct(snapshot.data[index].id);
                              setState(() {});
                            },
                            onTap: () {Navigator.pushNamed(context, '/ProviderList'); },
                            trailing: FlatButton(
                                child: (!_cartList.contains(snapshot.data[index])) ? Text("Ajouter") : Text("Supprimer"),
                                onPressed: (){
                                  setState(() {
                                    if (_cartList.contains(snapshot.data[index]))
                                      _cartList.remove(snapshot.data[index]);
                                    else
                                      _cartList.add(snapshot.data[index]);
                                  });
                                  //_navigateToDetail(context, snapshot.data[index]);
                                }),
                          );
                        },
                      )
                    )
                  ]
                )
              );
          } else if (snapshot.hasError)
              return Center(
                child: Text("Failed to fetch products"));
            return Center(
              child: CircularProgressIndicator(),
            );
          }
      )
    );
  }

  _navigateToDetail(BuildContext context, Product product) async
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddProduct(product: product)));
  }

  _refreshPage()
  {
    setState(() {
      ProductDatabase.instance.retrieveProducts();
    });
  }
}