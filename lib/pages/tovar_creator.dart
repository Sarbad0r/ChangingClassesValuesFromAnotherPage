import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tovar/models/tovar_model.dart';
import 'package:tovar/providers/list_of_class_provider.dart';

class CrateTovar extends StatelessWidget {
  int? index;
  Tovar? tovar;
  CrateTovar({Key? key, this.tovar, this.index}) : super(key: key);

  var _formKey = GlobalKey<FormState>();

  late TextEditingController nameController =
      TextEditingController(text: tovar?.name);
  late TextEditingController codeController =
      TextEditingController(text: tovar?.code);

  @override
  Widget build(BuildContext context) {
    var _textStyle = const TextStyle(color: Colors.grey, fontSize: 14);
    var tovarProvider = Provider.of<ListOfClassProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title:
            const Text("For learning", style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
              onPressed: () {
                FocusManager.instance.primaryFocus!.unfocus();
                if (!_formKey.currentState!.validate()) {
                  return;
                }

                if (!tovarProvider.check(tovar!) && index == null) {
                  tovarProvider.add(Tovar(
                      name: nameController.text, code: codeController.text));
                  Navigator.pop(context);
                  return;
                }

                tovarProvider.update(
                    Tovar(name: nameController.text, code: codeController.text),
                    index!);
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
                  decoration:
                      InputDecoration(hintText: "Код", hintStyle: _textStyle),
                )
              ],
            ),
          )),
    );
  }
}
