import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/group.dart';
import '../models/word.dart';
import '../widgets/word_tile.dart';
import 'edit_word_screen.dart';

class AddWordScreen extends StatefulWidget {
  final Group group;
  const AddWordScreen({super.key, required this.group});

  @override
  State<AddWordScreen> createState() => _AddWordScreenState();
}

class _AddWordScreenState extends State<AddWordScreen> {
  List<Word> _words = [];
  final _wordController = TextEditingController();
  final _translationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    final words = await DatabaseHelper.instance.getWordsByGroup(
      widget.group.id!,
    );
    setState(() => _words = words);
  }

  void _addWord() async {
    if (_wordController.text.isNotEmpty &&
        _translationController.text.isNotEmpty) {
      await DatabaseHelper.instance.insertWord(
        Word(
          word: _wordController.text,
          translation: _translationController.text,
          groupId: widget.group.id!,
        ),
      );
      _wordController.clear();
      _translationController.clear();
      _loadWords();
    }
  }

  void _editWord(Word word) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditWordScreen(word: word)),
    ).then((_) => _loadWords());
  }

  void _deleteWord(int id) async {
    await DatabaseHelper.instance.deleteWord(id);
    _loadWords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.group.name)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _wordController,
                    decoration: const InputDecoration(labelText: "So'z"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _translationController,
                    decoration: const InputDecoration(labelText: "Tarjima"),
                  ),
                ),
                IconButton(onPressed: _addWord, icon: const Icon(Icons.add)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _words.length,
              itemBuilder: (context, index) {
                final w = _words[index];
                return WordTile(
                  word: w,
                  onEdit: () => _editWord(w),
                  onDelete: () => _deleteWord(w.id!),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
