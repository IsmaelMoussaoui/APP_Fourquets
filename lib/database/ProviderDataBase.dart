
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:startup_namer/core/models/Provider.dart';

class ProviderDataBase
{
  ProviderDataBase._();

  static const databaseName               = "databas.db";
  static final ProviderDataBase instance  = ProviderDataBase._();
  static Database _database;

  Future<Database> get database async
  {
    if (_database == null)
      return await initDB();
    else
      return _database;
  }

  initDB() async
  {
    return await openDatabase(
        join(await getDatabasesPath(), databaseName),
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE providers(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
              " name TEXT, addressMail TEXT, numberPhone TEXT, societyName TEXT)");
        }
    );
  }

  insertProvider(Provider provider) async
  {
    final db = await database;
    var res  = await db.insert("providers", provider.toMap(), conflictAlgorithm:  ConflictAlgorithm.replace);

    return res;
  }

  Future<List<Provider>> fetchProvider() async
  {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("providers");

    return List.generate(maps.length, (i){
      return Provider(
        id: maps[i]['id'],
        name: maps[i]['name'],
        addressMail: maps[i]['addressMail'],
        numberPhone: maps[i]['numberPhone'],
        societyName: maps[i]['societyName'],
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

  deleteProvider(int id) async
  {
    var db = await database;
    db.delete('providers', where: 'id = ?', whereArgs: [id]);
  }

}
