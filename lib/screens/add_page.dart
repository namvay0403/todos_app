import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todos_app/services/todo_services.dart';
import 'package:todos_app/utils/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({super.key, this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          ElevatedButton(
            onPressed: () {
              isEdit ? updateData() : submitData();
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(isEdit ? 'Update' : 'Submit'),
            ),
          )
        ],
      ),
    );
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      print('You can not call updated without todo data');
      return;
    }

    final id = todo['_id'];

    final isSuccess = await TodoService.updateTodo(id, body);

    if (isSuccess) {
      showSuccessMassage(context, message: 'Updation Success');
    } else {
      showErrorMassage(context, message: 'Updation Failed');
    }
  }

  Future<void> submitData() async {
    // Submit data to the server
    final isSuccess = await TodoService.addTodo(body);

    // Show success or fail message based on status
    if (isSuccess) {
      showSuccessMassage(context, message: 'Creation Success');
      titleController.text = '';
      descriptionController.text = '';
    } else {
      showErrorMassage(context, message: 'Created Failed');
    }
  }

  Map get body {
    // Get data from here
    final title = titleController.text;
    final description = descriptionController.text;
    return {
      "title": title,
      "description": description,
      "is_completed": false,
    };
  }
}
