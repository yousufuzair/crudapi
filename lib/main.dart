import 'package:crudcrud/screens/todo_list.dart';
import 'package:flutter/material.dart';

void main() {
  runApp( CrudApp());
}
 class CrudApp extends StatelessWidget {
  const CrudApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: TodoListPage(),
    );
  }
}