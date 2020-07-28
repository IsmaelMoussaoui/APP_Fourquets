import 'package:flutter/material.dart';
import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import 'package:startup_namer/product.dart';

import 'Provider.dart';

class ProductRoute extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
          title: Text('Produits')),
      body: Center(
        child: Text("Listes des produits"),
      ),
    );
  }
}

class newProviderRoute extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
          title: Text('Nouveau fournisseur')),
      body: NewProvider(),
    );
  }
}

class newProductRoute extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
          title: Text('Nouveau Produit')),
      body: NewProduct(),
    );
  }
}


class RateRoute extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
          title: Text('Tarifs')),
      body: Center(
        child: Text("Listes des produits tarifé"),
      ),
    );
  }
}

class ProviderRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Fournisseurs')),
      body: Center(
        child: Text('Listes des fournisseurs'),
      ),
    );
  }
}

class CategoryRoute extends StatelessWidget
{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories')),
      body: Center(
        child: Text('Listes des categories'),
      ),
    );
  }
}

class PosteCommandeRoute extends StatelessWidget
{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
          title: Text('Poste de coommande')),
      body: Center(
        child: Text('Poste de commande'),
      ),
    );
  }
}