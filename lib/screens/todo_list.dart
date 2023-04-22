import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todos_app/screens/add_page.dart';
import 'package:todos_app/services/todo_services.dart';
import 'package:todos_app/utils/snackbar_helper.dart';
import 'package:todos_app/widget/todo_card.dart';

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({super.key});

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  List items = [];
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                'No Todo Item',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            child: ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final id = item['_id'] as String;
                  return TodoCard(
                      index: index,
                      item: item,
                      navagateToEdit: navigateToEditPage,
                      deleteById: deleteById);
                }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            navigateToAddPage();
          },
          label: Text('Add Todo')),
    );
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> deleteById(String id) async {
    // Delete the item
    final isSucccess = await TodoService.deletedById(id);
    if (isSucccess) {
      // Remove item from the list
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      showErrorMassage(context, message: 'Deleted Failed');
    }
    // Remove item from the list
  }

  Future<void> fetchTodo() async {
    final response = await TodoService.fetchTodos();

    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      //show error
      showErrorMassage(context, message: 'Something went to wrong');
    }

    setState(() {
      isLoading = false;
    });
  }
}
