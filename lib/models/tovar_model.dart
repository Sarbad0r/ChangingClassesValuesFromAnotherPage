class Tovar {
  String name = '';
  String code = '';
  Tovar({ this.name = '', this.code = ''});

  factory Tovar.fromJson(Map<String, dynamic> json) {
    return Tovar( name: json['name'], code: json['code']);
  }

  Map<String, dynamic> toJson() {
return{
      'name' : name,
      'code': code
    };
  }
}
