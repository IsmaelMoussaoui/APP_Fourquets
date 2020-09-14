import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:startup_namer/core/models/Product.dart';

class ProductDataBase
{
  ProductDataBase._();

  static const databaseName             = "database.db";
  static final ProductDataBase instance = ProductDataBase._();
  static Database _database;

  Future<Database> get database async
  {
    if (_database == null)
      return await initDB();
    return _database;
  }

  initDB() async
  {
    return await openDatabase(join(await getDatabasesPath(), databaseName),
      version: 1,
      onCreate: (Database db, int version) async
      {
        await db.execute("Create TABLE products(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
            " name TEXT, provider TEXT, unit TEXT, addedDate TEXT,"
            " unitPrice REAL, post TEXT, numberUnit TEXT, globalPrice REAL)");
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
        id:           maps[i]['id'],
        name:         maps[i]['name'],
        provider:     maps[i]['provider'],
        unit:         maps[i]['unit'],
        addedDate:    maps[i]['addedDate'],
        unitPrice:    maps[i]['unitPrice'],
        post:         maps[i]['post'],
        numberUnit:   maps[i]['numberUnit'],
        globalPrice:  maps[i]['globalPrice'],
      );
    });
  }

  Future<List<Product>> fetchProductByProvider(String provider) async
  {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery("SELECT * FROM products WHERE provider = " + '"' + provider + '"');

    return List.generate(maps.length, (i){
      return Product(
          id:           maps[i]['id'],
          name:         maps[i]['name'],
          provider:     maps[i]['provider'],
          unit:         maps[i]['unit'],
          addedDate:    maps[i]['addedDate'],
          unitPrice:    maps[i]['unitPrice'],
          post:         maps[i]['post'],
          numberUnit:   maps[i]['numberUnit'],
          globalPrice:  maps[i]['globalPrice'],
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