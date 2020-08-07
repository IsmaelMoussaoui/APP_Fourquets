import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'meme.dart';
import 'dart:io';
import 'dart:async';

class MemoDbProvider
{
  Future<Database> init() async
  {
    Directory directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, "memos.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE Memos(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT)");
      }
    );
  }

  Future<int> addItem(MemoModel item) async
  {
    final db = await init();

    return db.insert("Memos", item.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<MemoModel>> fetchMemos() async
  {
    final db = await init();
    final maps = await db.query("Memos");

    return List.generate(maps.length, (i)
    {
      return MemoModel(
        id: maps[i]['id'],
        title: maps[i]['title'],
        content: maps[i]['content']
      );
    });
  }

  Future<int> deleteMemo(int id) async
  {
    final db = await init();

    int result = await db.delete(
      "Memos",
      where: "id = ?",
      whereArgs: [id]
    );
    return result;
  }

  Future<int> updateMemo(int id, MemoModel item) async
  {
    final db = await init();

    int result = await db.update("Memos",
      item.toMap(),
      where: "id = ?",
      whereArgs: [id]
      );
    return result;
  }
}