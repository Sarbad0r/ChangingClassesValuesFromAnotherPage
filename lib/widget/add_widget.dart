import 'package:flutter/material.dart';

class AddWidget extends StatelessWidget {
  int? id;
  int? tovar_id;
  String? name = '';
  String? age = '';
  AddWidget({Key? key, this.id, this.tovar_id, this.name = '', this.age = ''})
      : super(key: key);

  late TextEditingController nameCotroller = TextEditingController(text: name);
  late TextEditingController ageController = TextEditingController(text: age);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            TextField(
              controller: nameCotroller,
            ),
            TextField(
              controller: ageController,
            )
          ],
        ));
  }
}
