import 'package:flutter/cupertino.dart';
import 'package:tovar/db/tovar_db.dart';
import 'package:tovar/models/tovar_model.dart';

class ListOfClassProvider with ChangeNotifier {
  List<Tovar> _listTovar = [];
  ListOfClassProvider()
  {
    fetch();
  }
  void add(Tovar tovar) {
    print(_listTovar.length + 1);
    _listTovar.add(tovar);
    notifyListeners();
  }
  void fetch()async
  {
    await fetchAndSetData();
    _listTovar;
    notifyListeners();
  }
  void delete(Tovar tovar) {
    _listTovar.remove(tovar);
    notifyListeners();
  }

  void update(Tovar tovar, int index) {
    print("Кор кад");
   
    _listTovar.replaceRange(index, index + 1, [tovar]);
    notifyListeners();
  }

  bool check(Tovar tovar) {
    print(_listTovar.contains(tovar));
    return _listTovar.contains(tovar);
  }

  Future<List<Tovar>> fetchAndSetData() async {
    final data = await DbTovar.getTovar();
    print(data.length);
    if (data.isNotEmpty) {
      _listTovar = data.map((e) {
        return Tovar(
            name: e.name,
            code : e.code);
      }).toList();
    }
    return _listTovar;
  }

  List<Tovar> get listTovar => _listTovar;
}
