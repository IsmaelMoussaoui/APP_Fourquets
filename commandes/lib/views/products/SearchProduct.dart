import 'package:commandes/database/ProductDatabase.dart';
import 'package:commandes/models/Product.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';

class SearchProduct extends StatelessWidget
{
  Future<List<Product>> search(String search) async {
    await Future.delayed(Duration(seconds: 2));
    return ProductDatabase.instance.retrieveProductsByName(search);
  }

  final SearchBarController<Product> _searchBarController = SearchBarController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar<Product>(
            onSearch: search,
            searchBarController: _searchBarController,
            header: Row(
              children: <Widget>[
                RaisedButton(
                  child: Text('Trier par prix'),
                  onPressed: (){
                    _searchBarController.sortList((Product a, Product b)
                    {
                      return a.globalPrice.compareTo(b.globalPrice);
                    });
                  },
                )
              ]
            ),
            onItemFound: (Product post, int index) {
              return ListTile(
                title: Text(post.name),
                subtitle: Text(post.provider),
              );
            },
          ),
        ),
      ),
    );
  }
}
