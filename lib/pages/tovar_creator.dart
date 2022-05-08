import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tovar/db/tovar_db.dart';
import 'package:tovar/models/tovar_model.dart';
import 'package:tovar/providers/add_widget_provider.dart';
import 'package:tovar/providers/list_of_class_provider.dart';
import 'package:tovar/widget/add_widget.dart';

class CrateTovar extends StatefulWidget {
  Tovar? tovar;
  List<AddWidget>? listWidget = [];
  CrateTovar({Key? key, this.tovar, this.listWidget}) : super(key: key);

  @override
  State<CrateTovar> createState() => _CrateTovarState();
}

class _CrateTovarState extends State<CrateTovar> {
  var _formKey = GlobalKey<FormState>();
  var _formKeyBottom = GlobalKey<FormState>();

  late TextEditingController nameController =
      TextEditingController(text: widget.tovar?.name);

  late TextEditingController codeController =
      TextEditingController(text: widget.tovar?.code);

  late List<AddWidget> list = widget.listWidget!;

  late TextEditingController bottomNameController =
      TextEditingController(text: '');
  late TextEditingController bottomAgeController =
      TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    var _textStyle = const TextStyle(color: Colors.grey, fontSize: 14);
    var tovarProvider = Provider.of<ListOfClassProvider>(context);
    var addWidgetProvider = Provider.of<AddWidgetProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title:
            const Text("For learning", style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
              onPressed: () {
                print(addWidgetProvider.listWidget.length);
              },
              child: Text("Check")),
          TextButton(
              onPressed: () async {
                FocusManager.instance.primaryFocus!.unfocus();
                if (!_formKey.currentState!.validate()) {
                  return;
                }

                Tovar tovarObject =
                    Tovar(name: nameController.text, code: codeController.text);

                if (!tovarProvider.check(widget.tovar!)) {
                  await DbTovar.inserToDb(tovarObject);
                  print("ID: ${tovarObject.id}");
                  tovarProvider.add(tovarObject);
                  if (list.isNotEmpty) {
                    await DbTovar.insertToCard(tovarObject.id!, list);

                    for (int i = 0; i < list.length; i++) {
                      list[i].tovar_id = tovarObject.id;
                      addWidgetProvider.addWidget(list[i]);
                    }
                  }
                  Navigator.pop(context);
                  return;
                }

                widget.tovar!.code = codeController.text;
                widget.tovar!.name = nameController.text;
                await DbTovar.updateTovar(widget.tovar!);
                tovarProvider.notify();
                await DbTovar.insertToCard(widget.tovar!.id!, list);

                for (int i = 0; i < list.length; i++) {
                 list[i].tovar_id = widget.tovar!.id!;
                  addWidgetProvider.addWidget(list[i]);
                }
                Navigator.pop(context);
              },
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ))
        ],
        centerTitle: true,
      ),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 20, right: 50, left: 50),
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Field is requared";
                    }
                  },
                  decoration: InputDecoration(
                      hintText: "Наименование", hintStyle: _textStyle),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: codeController,
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(hintText: "Код", hintStyle: _textStyle),
                ),
                const SizedBox(
                  height: 30,
                ),
                Card(
                  shadowColor: Colors.black,
                  elevation: 3,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Card"),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      if (list.isNotEmpty)
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => list[index]));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(list[index].nameCotroller.text),
                                        Text(list[index].ageController.text)
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          list.remove(list[index]);
                                        });
                                        addWidgetProvider.remWhere(list[index]);
                                      },
                                      icon: Icon(Icons.delete))
                                ],
                              ),
                            );
                          },
                          itemCount: list.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        height:
                                            MediaQuery.of(context).size.height,
                                        color: Colors.amber,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 25),
                                          child: Scaffold(
                                            appBar: AppBar(
                                              elevation: 0,
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      if (!_formKeyBottom
                                                          .currentState!
                                                          .validate()) {
                                                        return;
                                                      }
                                                      AddWidget newAddWidget =
                                                          AddWidget(
                                                        name:
                                                            bottomNameController
                                                                .text,
                                                        age: bottomAgeController
                                                            .text,
                                                      );
                                                      setState(() {
                                                        list.add(newAddWidget);
                                                      });
                                                      addWidgetProvider
                                                          .addWidget(
                                                              newAddWidget);
                                                      setState(() {
                                                        bottomNameController
                                                            .text = '';
                                                        bottomAgeController
                                                            .text = '';
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      "Сохранить",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ))
                                              ],
                                              backgroundColor: Colors.amber,
                                            ),
                                            body: Form(
                                              key: _formKeyBottom,
                                              child: Column(
                                                children: [
                                                  Card(
                                                    elevation: 3,
                                                    shadowColor: Colors.black,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 60,
                                                              left: 60),
                                                      child: Column(
                                                        children: [
                                                          TextFormField(
                                                            decoration:
                                                                InputDecoration(
                                                                    labelText:
                                                                        "Name"),
                                                            controller:
                                                                bottomNameController,
                                                            validator: (val) {
                                                              if (val!
                                                                  .isEmpty) {
                                                                return "Field is requared";
                                                              }
                                                            },
                                                          ),
                                                          TextFormField(
                                                            decoration:
                                                                InputDecoration(
                                                                    labelText:
                                                                        "Age"),
                                                            controller:
                                                                bottomAgeController,
                                                          ),
                                                          SizedBox(
                                                            height: 30,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: const Text("Add")),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
