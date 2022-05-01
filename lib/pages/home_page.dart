import 'package:flutter/material.dart';
import 'package:tovar/db/tovar_db.dart';
import 'package:tovar/models/tovar_model.dart';
import 'package:tovar/pages/tovar_creator.dart';
import 'package:tovar/providers/list_of_class_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tovarProvider = Provider.of<ListOfClassProvider>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                if (tovarProvider.listTovar.isNotEmpty)
                  for (int i = 0; i < tovarProvider.listTovar.length; i++) {
                    print(tovarProvider.listTovar[i].name);
                  }
                else {
                  print('empty');
                }
              },
              child: Text("Check"))
        ],
        backgroundColor: Colors.amber,
        title: const Text("Lests go", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 10),
            child: ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                color: Colors.blueGrey,
                thickness: 1,
              ),
              itemCount: tovarProvider.listTovar.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CrateTovar(
                            tovar: tovarProvider.listTovar[index],
                            index: index,
                          ),
                        ));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tovarProvider.listTovar[index].name,
                                style: TextStyle(fontSize: 16),
                              ),
                              if (tovarProvider
                                  .listTovar[index].code.isNotEmpty)
                                Text(tovarProvider.listTovar[index].code,
                                    style: TextStyle(fontSize: 16)),
                            ],
                          ),
                          IconButton(
                              onPressed: () {
                                DbTovar.deleteIzbrannie(tovarProvider.listTovar[index].code);
                                tovarProvider
                                    .delete(tovarProvider.listTovar[index]);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.blueGrey,
                              ))
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          const Expanded(child: const Text("")),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CrateTovar(
                                tovar: Tovar(name: '', code: ''),
                                index: null)));
                  },
                  child: const Text("ADD")),
            ],
          )
        ],
      ),
    );
  }
}
