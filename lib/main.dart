import 'package:flutter/material.dart';
import 'package:patterns_setstate/pages/create_page.dart';
import 'package:patterns_setstate/pages/home_page.dart';
import 'package:patterns_setstate/pages/update_page.dart';

//har bir o'rgangan arxitekturani 3 martadan yoz 1. ustoz bilan, 2. va 3. o'zing 4. esa uga vazifa bo'sin shunda yaxshiroq o'rganasan

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Patterns',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: {
        HomePage.id: (context) => HomePage(),
        CreatePage.id: (context) => CreatePage(),
        UpdatePage.id: (context) => UpdatePage(),
      },
    );
  }
}