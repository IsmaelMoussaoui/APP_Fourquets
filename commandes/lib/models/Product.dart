class Product
{
  final int id;
  final String name;
  final String provider;
  final String post;
  final String category;
  final String subCategory;
  final String price;
  final String unit;
  final String globalPrice;

  Product({this.id, this.name, this.provider, this.post, this.category,
      this.subCategory, this.price, this.unit, this.globalPrice});

  Map<String, dynamic> toMap()
  {
    return {
      'id':           id,
      'name':         name,
      'provider':     provider,
      'post':         post,
      'category':     category,
      'subCategory':  subCategory,
      'price':        price,
      'unit':         unit,
      'globalPrice':  globalPrice
    };
  }
}