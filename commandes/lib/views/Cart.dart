import 'package:commandes/models/Product.dart';
import 'package:commandes/views/pdf/ReportView.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget
{
  final List<Product> _cart;
  Cart(this._cart);

  @override
  _Cart createState() => _Cart(this._cart);

}

class _Cart extends State<Cart>
{
  List<Product> _cart;
  _Cart(this._cart);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Les produits"),
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10),
        child: FloatingActionButton.extended(
          label: Text("Générer PDF"),
          icon: Icon(Icons.shopping_cart),
          onPressed: () async {
            Navigator.push(context, reportView(context, _cart));
          },
        ),
      ),
      body: ListView.builder(
        itemCount: _cart.length,
          itemBuilder: (context, index){
            var item = _cart[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Card(
                child: ListTile(
                  title: Text(item.name),
                  onTap: () {
                    setState(() {
                      _cart.remove(item);
                    });
                  },
                ),
              ),
            );
          }
      ),
    );
  }
}