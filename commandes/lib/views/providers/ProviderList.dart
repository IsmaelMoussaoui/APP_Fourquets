import 'package:commandes/database/ProviderDatabase.dart';
import 'package:commandes/models/provider.dart';
import 'package:commandes/views/providers/AddProvider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProviderList extends StatefulWidget
{
  @override
  _ProviderList createState() => _ProviderList();
}

class _ProviderList extends State<ProviderList>
{
  @override
  Widget build(BuildContext context) {
    _refreshPage();
    return Scaffold(
        appBar: AppBar(
          title: Text("Les fournisseurs"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add), onPressed: () {
          Navigator.pushNamed(context, '/AddProvider');
        },
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(icon: Icon(Icons.search), onPressed: () {
                Navigator.pushNamed(context, '/searchProvider');
              }),
              IconButton(icon: Icon(Icons.sync), onPressed: () {
                _refreshPage();
              }),
            ],
          ),
        ),
        body: FutureBuilder<List<Provider>>(
            future: ProviderDatabase.instance.retrieveProviders(),
            builder: (context, snapshot){
              if (snapshot.hasData){
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index){
                    return ListTile(
                      title: Text(snapshot.data[index].id.toString()),
                      subtitle: Text(snapshot.data[index].name + snapshot.data[index].mail + snapshot.data[index].phone),
                      onLongPress: () async {
                        ProviderDatabase.instance.deleteProvider(snapshot.data[index].id, snapshot.data[index].company);
                        setState(() {});
                      },
                      onTap: (){launch("tel://" + snapshot.data[index].phone);},
                      trailing: FlatButton(child: Text("Editer"), onPressed: (){
                        __navigateToDetail(context, snapshot.data[index]);
                      }),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                    child: Text("Failed to fetch providers"));
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }
        )
    );
  }

  __navigateToDetail(BuildContext context, Provider provider) async
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddProvider(provider: provider)));
  }

  _refreshPage()
  {
    setState(() {
      ProviderDatabase.instance.retrieveProviders();
    });
  }
}