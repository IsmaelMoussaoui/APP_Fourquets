class Provider
{
  final int id;
  final String name;
  final String company;
  final String mail;
  final String phone;


  Provider({this.id, this.name, this.company, this.mail, this.phone});

  Map<String, dynamic> toMap()
  {
    return {
      'id':           id,
      'name':         name,
      'company':      company,
      'mail':         mail,
      'phone':        phone,
    };
  }
}