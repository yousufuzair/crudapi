import 'dart:convert';

import 'package:crudcrud/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Todo'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [TextField(
          controller: titleController,
          decoration: InputDecoration(hintText: 'Title'),
        ),
        TextField(
          controller: descriptionController,
          decoration: InputDecoration(hintText: 'Description'),
          keyboardType: TextInputType.multiline,
          minLines: 5,
          maxLines: 8,
        ),
        SizedBox(height: 20),
        ElevatedButton(onPressed: submitdata, child: Text('Submit'),
        )
        ],
      ),
    );
  }
  Future<void> submitdata() async{
    final title  = titleController.text;
    final description = descriptionController.text;
    final body = {      "title" : title,
      "description" : description,
      "is_completed" : false,
    };
    final url = 'https://crudcrud.com/api/f9afe50ac14349b4aab4c10db18d9603/unicorns';
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: jsonEncode(body),
    headers: {'Content-Type' : 'application/json'});

    if (response.statusCode == 201){
      titleController.text = '';
      descriptionController.text = '';
      print('Creation Success');
      showSuccessMessage('Creation Success');
    } else {
      showErrorMessage('Creation Failed');
      print(response.body);
      }
    
    }
    void showSuccessMessage (String message) {
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  void showErrorMessage (String message) {
      final snackBar = SnackBar(content: Text(
        message,
        style: TextStyle(color: Colors.red)
        )
        );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}