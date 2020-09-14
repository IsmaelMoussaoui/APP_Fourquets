import 'package:commandes/database/ProviderDatabase.dart';
import 'package:commandes/models/provider.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';

class SearchProvider extends StatelessWidget
{
  Future<List<Provider>> search(String search) async {
    return ProviderDatabase.instance.retrieveProviders();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar<Provider>(
            onSearch: search,
            cancellationText: Text("Annuler"),
            onItemFound: (Provider post, int index) {
              return ListTile(
                title: Text(post.name),
                subtitle: Text(post.company),
              );
            },
          ),
        ),
      ),
    );
  }
}
