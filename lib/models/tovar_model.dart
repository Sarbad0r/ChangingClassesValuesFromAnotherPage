class Tovar {
  int? id;
  String name = '';
  String code = '';
  Tovar({this.id, this.name = '', this.code = ''});

  factory Tovar.fromJson(Map<String, dynamic> json) {
    return Tovar(name: json['name'], code: json['code']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'code': code};
  }
}
