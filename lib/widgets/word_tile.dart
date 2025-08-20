import 'package:flutter/material.dart';
import '../models/word.dart';

class WordTile extends StatelessWidget {
  final Word word;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const WordTile({
    super.key,
    required this.word,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(word.word),
      subtitle: Text(word.translation),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(onPressed: onEdit, icon: const Icon(Icons.edit)),
          IconButton(onPressed: onDelete, icon: const Icon(Icons.delete)),
        ],
      ),
    );
  }
}
