class Product
{
  /// Attributes of the class Product, all in public
  int id;
  String name;
  String provider;
  String unit;
  String addedDate;
  String unitPrice;
  String post;
  String numberUnit;
  String globalPrice;
  /// End of the attributes.

  /// Constructor for Product class
  Product({this.id, this.name, this.provider, this.unit, this.addedDate,
      this.unitPrice, this.post, this.numberUnit, this.globalPrice});


  Map<String, dynamic> toMap()
  {
    return <String, dynamic>
    {
      "id"            : id,
      "name"          : name,
      "provider"      : provider,
      "unit"          : unit,
      "addedDate"     : addedDate,
      "unitPrice"     : unitPrice,
      "post"          : post,
      "numberUnit"    : numberUnit,
      "globalPrice"   : globalPrice
    };
  }

}