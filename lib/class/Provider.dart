import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:startup_namer/routes/NewProvider.dart';
import 'package:url_launcher/url_launcher.dart';


class Provider
{
  ///Attributes for Provider
  int id;
  String name;
  String addressMail;
  String numberPhone;
  String societyName;
  ///End of attributes Provider

  ///Constructor for provider
  Provider({this.id, this.name, this.addressMail, this.numberPhone, this.societyName});

  Map<String, dynamic> toMap()
  {
    return <String, dynamic>
    {
      "id": id,
      "name": name,
      "addressMail": addressMail,
      "numberPhone": numberPhone,
      "societyName": societyName,
    };
  }
}

class ProviderDataBase
{
  ProviderDataBase._();

  static const databaseName = "databas.db";
  static final ProviderDataBase instance = ProviderDataBase._();
  static Database _database;

  Future<Database> get database async
  {
    print("1");
    if (_database == null) {
      print("3");
      return await initDB();
    } else {
      print("2");
      return await initDB();
    }
  }

  initDB() async
  {
    return await openDatabase(
      join(await getDatabasesPath(), databaseName),
      version: 1,
      onCreate: (Database db, int version) async {
        print("oui");
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

class ProviderRoute extends StatefulWidget
{
  @override
  _ProviderRoute createState() => _ProviderRoute();
}

class _ProviderRoute extends State<ProviderRoute>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Fournisseurs")),
        body: FutureBuilder<List<Provider>>(
            future: ProviderDataBase.instance.fetchProvider(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ExpansionTile(
                          title: Text(snapshot.data[index].societyName),
                          children: <Widget>[
                            Text(snapshot.data[index].name),
                            Text(snapshot.data[index].addressMail),
                            Text(snapshot.data[index].numberPhone),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                RaisedButton.icon(
                                  icon: Icon(Icons.delete, color: Colors.white),
                                  label: Text("Supprimer",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: Colors.red,
                                  onPressed: () async {
                                    ProviderDataBase.instance.deleteProvider(
                                      snapshot.data[index].id);
                                    setState(() {});
                                  }),
                              RaisedButton.icon(
                                icon: Icon(Icons.edit, color: Colors.white),
                                label: Text("Modifier",
                                  style: TextStyle(color: Colors.white)),
                                color: Colors.green,
                                onPressed: () async {
                                  _navigateToDetail(context, snapshot.data[index]);
                                  setState(() {});
                                }),
                              RaisedButton.icon(
                                icon: Icon(Icons.phone, color: Colors.white),
                                label: Text("Téléphone", style: TextStyle(color: Colors.white),),
                                color: Colors.blue,
                                onPressed: () async => {
                                  launch("tel://" + snapshot.data[index].numberPhone.toString())}),
                            ]
                      ),
                    ]));
                  },
                );
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Text("Fail");
              } else if(!snapshot.hasData){
                return Center(child: Text("Il n'y a aucun fournisseur pour le moment"));
              }
              return CircularProgressIndicator();
            }
        )
    );
  }

  _navigateToDetail(BuildContext context, Provider provider) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewProvider(provider: provider)),
    );
    setState(() {});
  }
}