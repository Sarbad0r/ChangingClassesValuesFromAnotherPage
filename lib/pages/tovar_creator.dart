import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tovar/db/tovar_db.dart';
import 'package:tovar/models/tovar_model.dart';
import 'package:tovar/providers/list_of_class_provider.dart';

class CrateTovar extends StatelessWidget {
  Tovar? tovar;
  CrateTovar({Key? key, this.tovar}) : super(key: key);

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
              onPressed: () async{
                FocusManager.instance.primaryFocus!.unfocus();
                if (!_formKey.currentState!.validate()) {
                  return;
                }

                Tovar tovarObject = Tovar(
                    name: nameController.text, code: codeController.text);

                if (!tovarProvider.check(tovar!)) {
                  await DbTovar.inserToDb(tovarObject);
                  print("ID: ${tovarObject.id}");
                  tovarProvider.add(tovarObject);

                  Navigator.pop(context);
                  return;
                }

                tovar!.code = codeController.text;
                tovar!.name = nameController.text;
                await DbTovar.updateTovar(tovar!);
                tovarProvider.notify();
                // tovarProvider.update(
                //     tovar!, codeController.text, nameController.text);
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
                )
              ],
            ),
          )),
    );
  }
}
