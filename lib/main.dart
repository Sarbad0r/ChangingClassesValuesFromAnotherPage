import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tovar/pages/home_page.dart';
import 'package:tovar/providers/add_widget_provider.dart';
import 'package:tovar/providers/list_of_class_provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AddWidgetProvider>(
        create: (_) => AddWidgetProvider(),
      ),
      ChangeNotifierProvider<ListOfClassProvider>(
        create: (_) => ListOfClassProvider(),
      ),
    ],
    child: MaterialApp(
      theme: ThemeData(primaryColor: Colors.amber),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ),
  ));
}
