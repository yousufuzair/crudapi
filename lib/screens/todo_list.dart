import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crudcrud/screens/add_page.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo APP"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Visibility(
        visible: isLoading,
        child: const Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index] as Map;

              final id = item['_id'];
              final title = item['title'] ?? 'No Title';
              final description = item['description'] ?? 'No Description';

              return ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text(title),
                subtitle: Text(description),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      // Navigate to Edit Page or Handle Editing Logic
                    } else if (value == 'delete') {
                      // Handle deletion by ID
                      deleteById(id);
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: const Text('Edit'),
                        value: 'edit',
                      ),
                      PopupMenuItem(
                        child: const Text('Delete'),
                        value: 'delete',
                      ),
                    ];
                  },
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: const Text('Add todo'),
      ),
    );
  }

  void navigateToAddPage() {
    final route = MaterialPageRoute(
      builder: (context) => const AddTodoPage(),
    );
    Navigator.push(context, route);
  }

  Future<void> deleteById(String id) async {
    // Append the ID to the URL for deletion
    final url = 'https://crudcrud.com/api/f9afe50ac14349b4aab4c10db18d9603/unicorns/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      // Filter out the deleted item from the list
      final filtered = items.where((element) => element['_id'] != id).toList();

      setState(() {
        items = filtered;
      });
    } else {
      // Show error if deletion fails
      showErrorMessage('Deletion failed');
    }
  }

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> fetchTodo() async {
    final url = 'https://crudcrud.com/api/f9afe50ac14349b4aab4c10db18d9603/unicorns';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      try {
        final result = jsonDecode(response.body) as List;
        setState(() {
          items = result;
        });
      } catch (e) {
        debugPrint("Error parsing JSON: $e");
      }
    } else {
      debugPrint("Failed to fetch data, status code: ${response.statusCode}");
    }
  }
}
