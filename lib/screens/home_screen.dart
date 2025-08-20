import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/group.dart';
import 'add_word_screen.dart';
import 'test_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Group> groups = [];

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  void _loadGroups() async {
    groups = await DatabaseHelper.instance.getGroups();
    setState(() {});
  }

  void _addGroup() async {
    TextEditingController nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Yangi guruh"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: "Guruh nomi"),
        ),
        actions: [
          TextButton(
            child: const Text("Bekor qilish"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Saqlash"),
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                await DatabaseHelper.instance.insertGroup(
                  Group(name: nameController.text),
                );
                _loadGroups();
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _editGroup(Group group) {
    TextEditingController controller = TextEditingController(text: group.name);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Guruhni tahrirlash"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Yangi nom"),
        ),
        actions: [
          TextButton(
            child: const Text("Bekor"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Saqlash"),
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                await DatabaseHelper.instance.updateGroup(
                  Group(id: group.id, name: controller.text),
                );
                _loadGroups();
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _deleteGroup(int id) async {
    await DatabaseHelper.instance.deleteGroup(id);
    _loadGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Guruhlar"), centerTitle: true),
      body: ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final group = groups[index];
          return ListTile(
            title: Text(group.name),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddWordScreen(group: group)),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.play_arrow, color: Colors.green),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TestScreen(group: group),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _editGroup(group),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteGroup(group.id!),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addGroup,
        child: const Icon(Icons.add),
      ),
    );
  }
}
