import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'dart:async';

import 'package:startup_namer/routes/NewProduct.dart';


class Product
{
  /// Attributes of the class Product, all in public
  int id;
  String name;
  String provider;
  String unit;
  DateTime addedDate;
  String unitPrice;
  String post;
  String globalPrice;
  /// End of the attributes.

  /// Constructor for Product class
  Product({this.id, this.name, this.provider, this.unit, this.addedDate,
      this.unitPrice, this.post, this.globalPrice});


  Map<String, dynamic> toMap()
  {
    return <String, dynamic>
    {
      "id": id,
      "name": name,
      "provider": provider,
      "unit": unit,
      "addedDate": addedDate,
      "unitPrice": unitPrice,
      "post": post,
      "globalPrice": globalPrice
    };
  }

}

class ProductDataBase
{
  ProductDataBase._();

  static const databaseName = "database.db";
  static final ProductDataBase instance = ProductDataBase._();
  static Database _database;
  
  Future<Database> get database async 
  {
    if(_database == null)
      return await initDB();
    return _database;
  }

  initDB() async
  {
    return await openDatabase(
      join(await getDatabasesPath(), databaseName),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute("Create TABLE products(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
            " name TEXT, provider TEXT, unit TEXT, addedDate TEXT,"
            " unitPrice TEXT, post TEXT, globalPrice TEXT)");
        }
      );
  }
  
  insertProduct(Product product) async
  {
    final db = await database;
    var res = await db.insert("products", product.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    return res;
  }
  
  Future<List<Product>> fetchProduct() async
  {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("products");
    
    return List.generate(maps.length, (i){
      return Product(
        id: maps[i]['id'],
        name: maps[i]['name'],
        provider: maps[i]['provider'],
        unit: maps[i]['unit'],
        addedDate: maps[i]['addedDate'],
        unitPrice: maps[i]['unitPrice'],
        post: maps[i]['post'],
        globalPrice: maps[i]['globalPrice']
      );
    });
  }

  updateProduct(Product product) async
  {
    final db = await database;

    await db.update("products", product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
      conflictAlgorithm: ConflictAlgorithm.replace);
  }

  deleteProduct(int id) async
  {
    var db = await database;
    db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

}

class ProductRoute extends StatefulWidget
{
  @override
  _ProductRoute createState() => _ProductRoute();
}


class _ProductRoute extends State<ProductRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Produits")),
        body: FutureBuilder<List<Product>>(
            future: ProductDataBase.instance.fetchProduct(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ExpansionTile(
                          title: Text(snapshot.data[index].name),
                          children: <Widget>[
                            Text(snapshot.data[index].provider),
                            Text(snapshot.data[index].unitPrice),
                            RaisedButton(
                                child: Text("Supprimer",
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Colors.red,
                                onPressed: () async {
                                  ProductDataBase.instance.deleteProduct(
                                      snapshot.data[index].id);
                                  setState(() {});
                                }),
                            RaisedButton(
                                child: Text("Modifier",
                                    style: TextStyle(color: Colors.white)),
                                color: Colors.green,
                                onPressed: () async {
                                  _navigateToDetail(context, snapshot.data[index]);
                                  setState(() {});
                                }),
                            //  Text(snapshot.data[index].globalPrice.toString()),
                          ]
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError)
                return Text("Fail");
              return CircularProgressIndicator();
            }
        )
    );
  }

  _navigateToDetail(BuildContext context, Product product) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewProduct(product: product)),
    );
    setState(() {});
  }
}