import 'package:commandes/models/Product.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ProductDatabase
{
  ProductDatabase._();

  static const databaseName = 'productDB.db';
  static final ProductDatabase instance = ProductDatabase._();
  static Database _database;

  Future<Database> get database async
  {
    if (_database == null)
      return await initializeDatabase();
    return _database;
  }

  initializeDatabase() async
  {
    return await openDatabase(join(await getDatabasesPath()
        ,databaseName), version: 1, onCreate: (Database db, int version) async
    {
      await db.execute("CREATE TABLE products(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
          "name TEXT, provider TEXT, post TEXT, category TEXT, subCategory TEXT, price TEXT,"
          "unit TEXT, globalPrice TEXT) ");
      await db.execute(
          "CREATE TABLE providers(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
          "name TEXT, company TEXT, mail TEXT, phone TEXT)");
    });
  }

  insertProduct(Product product) async
  {
    final db = await database;
    var res = await db.insert("products", product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  Future<List<Product>> retrieveProducts() async
  {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query("products");

    return List.generate(maps.length, (index) {
      return Product(
        id: maps[index]['id'],
        name: maps[index]['name'],
        provider: maps[index]['provider'],
        post: maps[index]['post'],
        category: maps[index]['category'],
        subCategory: maps[index]['subCategory'],
        price: maps[index]['price'],
        unit: maps[index]['unit'],
        globalPrice: maps[index]['globalPrice'],
      );
    });
  }

  Future<List<Product>> retrieveProductsByName(String name) async
  {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery("SELECT * FROM products WHERE lower(name) like "+"'%"+ name +"%'");

    return List.generate(maps.length, (index) {
      return Product(
        id: maps[index]['id'],
        name: maps[index]['name'],
        provider: maps[index]['provider'],
        post: maps[index]['post'],
        category: maps[index]['category'],
        subCategory: maps[index]['subCategory'],
        price: maps[index]['price'],
        unit: maps[index]['unit'],
        globalPrice: maps[index]['globalPrice'],
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
    db.delete("products", where: 'id = ?', whereArgs: [id]);
  }
}