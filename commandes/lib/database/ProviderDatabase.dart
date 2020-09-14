import 'package:commandes/database/ProductDatabase.dart';
import 'package:commandes/models/Product.dart';
import 'package:commandes/models/provider.dart';
import 'package:sqflite/sqflite.dart';

class ProviderDatabase
{
  ProviderDatabase._();

  static const databaseName = 'productDB.db';
  static final ProviderDatabase instance = ProviderDatabase._();
  static Database _database;

  Future<Database> get database async
  {
    if (_database == null)
      return await ProductDatabase.instance.initializeDatabase();
    return _database;
  }

  insertProvider(Provider provider) async
  {
    final db = await database;
    var res = await db.insert("providers", provider.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  Future<List<Provider>> retrieveProviders() async
  {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query("providers");

    return List.generate(maps.length, (index) {
      return Provider(
        id: maps[index]['id'],
        name: maps[index]['name'],
        company: maps[index]['company'],
        mail: maps[index]['mail'],
        phone: maps[index]['phone'],
      );
    });
  }

  updateProvider(Provider provider) async
  {
    final db = await database;

    await db.update("providers", provider.toMap(),
        where: 'id = ?',
        whereArgs: [provider.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  deleteProvider(int id, String provider) async
  {
    var db = await database;
    db.delete("providers", where: 'id = ?', whereArgs: [id]);
    db.delete("products", where: 'provider = ?', whereArgs: [provider]);
  }
}