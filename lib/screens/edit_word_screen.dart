import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/word.dart';

class EditWordScreen extends StatefulWidget {
  final Word word;
  const EditWordScreen({super.key, required this.word});

  @override
  State<EditWordScreen> createState() => _EditWordScreenState();
}

class _EditWordScreenState extends State<EditWordScreen> {
  final _wordController = TextEditingController();
  final _translationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _wordController.text = widget.word.word;
    _translationController.text = widget.word.translation;
  }

  void _save() async {
    await DatabaseHelper.instance.updateWord(
      Word(
        id: widget.word.id,
        word: _wordController.text,
        translation: _translationController.text,
        groupId: widget.word.groupId,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("So'zni tahrirlash")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _wordController,
              decoration: const InputDecoration(labelText: "So'z"),
            ),
            TextField(
              controller: _translationController,
              decoration: const InputDecoration(labelText: "Tarjima"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _save, child: const Text("Saqlash")),
          ],
        ),
      ),
    );
  }
}
