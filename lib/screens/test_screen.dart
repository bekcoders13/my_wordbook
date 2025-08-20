import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/group.dart';
import '../models/word.dart';

class TestScreen extends StatefulWidget {
  final Group group;
  const TestScreen({super.key, required this.group});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  List<Word> _words = [];
  int _index = 0;
  bool _showTranslation = false;

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

  void _next() {
    if (_index < _words.length - 1) {
      setState(() {
        _index++;
        _showTranslation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_words.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("${widget.group.name} - Test")),
        body: const Center(child: Text("So'zlar mavjud emas")),
      );
    }

    final word = _words[_index];

    return Scaffold(
      appBar: AppBar(title: Text("${widget.group.name} - Test")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(word.word, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 20),
            if (_showTranslation)
              Text(
                word.translation,
                style: const TextStyle(fontSize: 28, color: Colors.blue),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  setState(() => _showTranslation = !_showTranslation),
              child: Text(_showTranslation ? "Yashirish" : "Tarjima ko'rish"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _next, child: const Text("Keyingi")),
          ],
        ),
      ),
    );
  }
}
