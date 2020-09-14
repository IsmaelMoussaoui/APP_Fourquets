import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:startup_namer/core/models/Cart.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class CartView extends StatefulWidget
{
  @override
  _CartView createState() => _CartView();
}

class _CartView extends State<CartView>
{
  
  Future<void> _createPDF(String name, int length) async
  {
    PdfDocument document = PdfDocument();
    PdfPage page = document.pages.add();
    var date = DateFormat('d MM').format(DateTime.now());
    double left = 50;
    double top = 50;
    double width = 500;
    double height = 30;

    page.graphics.drawString("Liste des produits à commander", PdfStandardFont(PdfFontFamily.helvetica, 18),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      bounds: Rect.fromLTWH(0, 0, width, height));
    for (int i = 0; i < length; i++) {
      page.graphics.drawString(
          name ,PdfStandardFont(PdfFontFamily.helvetica, 12),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          bounds: Rect.fromLTWH(left, top, width, height));
      top += 30;
    }
    List<int> bytes = document.save();
    document.dispose();
    Directory directory = await getExternalStorageDirectory();
    String path = directory.path;
    File file = File('$path/Commande_du_${date.toString()}.pdf');
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open('$path/Commande_du_${date.toString()}.pdf');
  }

  Future<String> cartPrefGet() async
  {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name') ?? 0;
    Cart a = Cart(name);
    String b = a.name;
    return b;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: cartPrefGet(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: Text("oui")),
            body: Center(
                child: Text(snapshot.data)
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                _createPDF(snapshot.data, 1);
              },
              label: Text('Passer commande'),
              icon: Icon(Icons.shopping_cart),
              backgroundColor: Colors.teal,
            )
          );
        } else {
          return Scaffold(
              body: Text("Il n'y a aucun element dans ton panier")
          );
        }
      }
        );

  }
}