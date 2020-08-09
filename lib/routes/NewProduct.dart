import 'package:flutter/material.dart';
import 'package:startup_namer/class/Provider.dart';
import '../class/Product.dart';

class NewProduct extends StatefulWidget
{
  final Product product;
  const NewProduct({Key key, this.product}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateNewProduct(product);

}

class _CreateNewProduct extends State<NewProduct>
{
  bool pastry = false;
  bool bakery = false;
  bool sell = false;

  set setPastry(bool) {
    pastry = bool;
  }
  set setBakery(bool) {
    bakery = bool;
  }
  set setSell(bool) {
    sell = bool;
  }

  Product product;
  Provider _prv;

  final nameTextController = TextEditingController();
  final providerTextController = TextEditingController();
  final unitTextController = TextEditingController();
  final unitPriceTextController = TextEditingController();
  final postTextController = TextEditingController();
  final globalPriceTextController = TextEditingController();

  _CreateNewProduct(this.product);

  @override
  void initState() {
    super.initState();
    if (product != null) {
      nameTextController.text = product.name;
      providerTextController.text = product.provider;
      unitTextController.text = product.unit;
      unitPriceTextController.text = product.unitPrice;
      postTextController.text = product.post;
      globalPriceTextController.text = product.globalPrice;
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameTextController.dispose();
    providerTextController.dispose();
    unitTextController.dispose();
    unitPriceTextController.dispose();
    postTextController.dispose();
    globalPriceTextController.dispose();
  }

  String selectedProv;

  @override
  Widget build(BuildContext context)
  {
    final _formKey = GlobalKey<FormState>();
    bool _autoValidate = false;

    return Scaffold(
      appBar: AppBar(title: Text("Nouveau produit")),
      body: Form(
        autovalidate: _autoValidate,
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:<Widget>[
              TextFormField(
              decoration: InputDecoration(
                  icon: Icon(Icons.fastfood),
                  labelText: "Nom du produit"),
              controller: nameTextController,
              validator: (value) {
                if (value.isEmpty)
                  return 'Entrez le nom du produit';
                return null;
                }
            ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FutureBuilder<List<Provider>>(
                    future: ProviderDataBase.instance.fetchProvider(),
                    builder: (context, snapshot){
                    if (!snapshot.hasData)
                      return CircularProgressIndicator();
                    return DropdownButton<Provider>(
                      //value: _prv,
                      items: snapshot.data
                              .map((provider) => DropdownMenuItem<Provider>(
                        child: Text(provider.societyName), value: provider)).toList(),
                      onChanged: (prov) {setState(() {_prv = prov;});},
                      isExpanded: false,
                      hint: Text("Choisir un fournisseur"),
                    );
                  }
                ),
                  SizedBox(height: 20),
                  _prv != null ? Text(_prv.societyName):Text("Aucun fournisseur ajouté"),
                ]),
                TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.attach_money),
                  labelText: "Prix à l'unité"),
                controller: unitPriceTextController,
                keyboardType: TextInputType.number,
                validator: (value){
                  if (value.isEmpty)
                    return "Entrez le prix unitaire";
                  return null;
                },
                ),
              FilterChip(
                padding: EdgeInsets.all(10),
                selected: pastry,
                label: Text("Patisserie"),
                labelStyle: TextStyle(color: Colors.black),
                backgroundColor: Colors.red,
                selectedColor: Colors.redAccent,
                avatar: Text('P', style: TextStyle(color: Colors.black)),
                onSelected: (bool selected) {setState(() {setPastry = !pastry;});} ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: FloatingActionButton(
                    child: Icon(Icons.check),
                    onPressed: () async {
                      if (!_formKey.currentState.validate())
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Renseignez les champs manquants")));
                      setState(() {
                        selectedProv = _prv.societyName;
                      });
                      _saveProduct(
                      nameTextController.text,
                      selectedProv,
                      unitTextController.text,
                      unitPriceTextController.text,
                      postTextController.text,
                      globalPriceTextController.text
                    );
                    setState(() {});
                  }
                ),
              )
            ]
          ),
        ),
      ),
    );
  }
/*  int id;
  String name;
  String provider;
  String unit;
  DateTime addedDate;
  int unitPrice;
  String post;
  int globalPrice;*/

  _saveProduct(String name, String provider, String unit, String unitPrice, String post, String globalPrice) async {
    if (product == null) {
      ProductDataBase.instance.insertProduct(Product(
        name: nameTextController.text,
        provider: selectedProv,
        unit: unitTextController.text,
        unitPrice: unitPriceTextController.text,
        post: postTextController.text,
        globalPrice: globalPriceTextController.text
      ));
      Navigator.pop(context, "Le produit a ete ajouté");
    } else {
      await ProductDataBase.instance
          .updateProduct(Product(id: product.id, name: name, provider: provider,
          unit: unit, unitPrice: unitPrice, post: post, globalPrice: globalPrice));
      Navigator.pop(context);
    }
  }

}


/*
class NewProduct extends StatefulWidget
{
  @override
  _NewProduct createState() => _NewProduct();
}


class _NewProduct extends State<NewProduct>
{

  bool bakery = false;
  bool pastry = false;
  bool sell = false;
  bool isSwitched = false;
  DateTime date;
  File imageFile;
  dynamic save;
  String oui;
  String non;
  final _formKey = GlobalKey<FormState>();


  set setBakery(bool) {
    bakery = bool;
  }
  set setPastry(bool) {
    pastry = bool;
  }
  set setSell(bool) {
    sell = bool;
  }
  set setDate(DateTime){
    date = DateTime;
  }
  set setIsSwitched(bool){
    isSwitched = bool;
  }

  @override
  Widget build(BuildContext context)
  {
    List<String> category = ["Boisson", "Confiserie", "Décor", "Divers", "Emballage",
                        "Entretien", "Fruits", "Préparation","Surgelé", "Traiteur"];

    List<String> fruitCat = ["Fruit-Patisserie"];

    List<DropdownMenuItem<String>> catList = category.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(value)],
        ),
      );}).toList();

    List<DropdownMenuItem<String>> FruitList = fruitCat.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(value)],
        ),
      );}).toList();

    String name;
    var forms = new Forms();
    return Scaffold(
      appBar: AppBar(title: Text("Nouveau Produit")),
        body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Wrap(
                  children: <Widget>[
                    forms.formsFields(Icon(Icons.fastfood), "Nom du produit", "Produit", TextInputType.name, name),
                    forms.formsFields(Icon(Icons.work), "Nom du fournisseur", "Fournisseur", TextInputType.text, name),
                    forms.formsFields(Icon(Icons.attach_money), "Prix unitaire", "Prix", TextInputType.number, name),
                    forms.formsFields(Icon(Icons.monetization_on), "Prix global", "Prix global", TextInputType.number, name),
                    Container(height: 6),
                    forms.dropButton(Icon(Icons.category), "Categories", this.oui, catList, (String newValue) {setState(() {this.oui = newValue;});}),
                    if (this.oui == "Fruits")
                      forms.dropButton(Icon(Icons.person), "Sous-Categories", this.non, FruitList, (String furnish) {setState(() {this.non = furnish;});}),
                    Container(height: 6),
                    //forms.dropButton(Icon(Icons.person), "Fournisseurs", this.non, provid, (String furnish) {setState(() {this.non = furnish;});}),
                    Container(height: 12),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              forms.newText("Poste pour le produit : "),
                              forms.filterButton(bakery, Colors.green, Colors.greenAccent, "Boulangerie", (bool selected) {setState(() {setBakery = !bakery;});}),
                             forms.filterButton(pastry, Colors.blue, Colors.blueAccent, "Patisserie", (bool selected) {setState(() {setPastry = !pastry;});}),
                              forms.filterButton(sell, Colors.red, Colors.redAccent, "Vente", (bool selected) {setState(() {setSell = !sell;});}),]
                        )]
                    ),
                    Center(
                      child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              forms.newText("Une promotion sur un produit ?"),
                              forms.switcher(isSwitched, Colors.orangeAccent, Colors.orange, (bool selected) {setState(() {setIsSwitched = !isSwitched;});}),
                              if (isSwitched)
                                forms.newText("A implementer les dates Time  pour les promos"),
                              forms.formsSaveButton(context, _formKey)]
                      ),
                    ),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        forms.buttonIconNew(context, "Nouveau fournisseur", Icon(Icons.add))]
                    )]
              )
            )
          )
        )
      );
  }
}
*/
