import 'package:flutter/cupertino.dart';
import 'package:tovar/models/tovar_model.dart';

class ListOfClassProvider with ChangeNotifier {
  List<Tovar> _listTovar = [];

  void add(Tovar tovar) {
    _listTovar.add(tovar);
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

  List<Tovar> get listTovar => _listTovar;
}
