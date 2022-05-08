import 'package:flutter/cupertino.dart';
import 'package:tovar/db/tovar_db.dart';
import 'package:tovar/widget/add_widget.dart';

class AddWidgetProvider with ChangeNotifier {
  List<AddWidget> _listWidget = [];
  void addWidget(AddWidget addWidget) {
    var found = _listWidget.where((element) => element.id == addWidget.id);
    if(found.isNotEmpty)
      {
        return;
      }
    _listWidget.add(addWidget);
    notifyListeners();
  }

  void remWhere(AddWidget addWidget)
  {
    _listWidget.removeWhere((element) => element.id == addWidget.id);
    notifyListeners();
  }

  List<AddWidget> getWidget(int tovar_id) {
    return _listWidget.where((element) => element.tovar_id == tovar_id).toList();
  }

  AddWidgetProvider(){
    fetch();
  }
  void fetch()async
  {
    await fetchAndSetData();
    _listWidget;
    notifyListeners();
  }

  Future<List<AddWidget>> fetchAndSetData() async {
    final data = await DbTovar.getCard();
    print(data.length);
    if (data.isNotEmpty) {
      _listWidget = data.map((e) {
        return AddWidget(id: e.id, tovar_id: e.tovar_id, name: e.name, age: e.age);
      }).toList();
    }
    return _listWidget;
  }

  List<AddWidget> get listWidget => _listWidget;
}
