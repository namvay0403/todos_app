import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navagateToEdit;
  final Function(String) deleteById;

  const TodoCard({
    super.key,
    required this.index,
    required this.item,
    required this.navagateToEdit,
    required this.deleteById,
  });

  @override
  Widget build(BuildContext context) {
    final id = item['_id'] as String;
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text('${index + 1}')),
        title: Text(item['title']),
        subtitle: Text(item['description']),
        trailing: PopupMenuButton(
          onSelected: (value) {
            if (value == 'edit') {
              // Open edit page
              navagateToEdit(item);
            } else if (value == 'delete') {
              // Delete and remove item
              deleteById(id);
            }
          },
          itemBuilder: (context) {
            return [
              const PopupMenuItem(
                child: Text('Edit'),
                value: 'edit',
              ),
              const PopupMenuItem(
                child: Text('Delete'),
                value: 'delete',
              ),
            ];
          },
        ),
      ),
    );
  }
}
