import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/tache_model.dart';
import '../models/comment_model.dart';
import '../provider/tache_provider.dart';

class TacheListScreen extends StatefulWidget {
  final String projectId;
  const TacheListScreen({super.key, required this.projectId});

  @override
  State<TacheListScreen> createState() => _TacheListScreenState();
}

class _TacheListScreenState extends State<TacheListScreen> {
  List<bool> _isExpandedList = [];
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final taches = Provider.of<TacheProvider>(context, listen: false)
          .getTachesByProject(widget.projectId);
      setState(() {
        _isExpandedList = List.generate(taches.length, (_) => false);
        // Assurez-vous que les contrôleurs sont initialisés correctement
        _controllers.clear();
        for (var tache in taches) {
          _controllers[tache.id] = TextEditingController();
        }
      });
    });
  }


  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taches = Provider.of<TacheProvider>(context).getTachesByProject(widget.projectId);

    if (_isExpandedList.length != taches.length) {
      _isExpandedList = List.generate(taches.length, (_) => false);
    }

    return Scaffold(
      appBar: AppBar(title: Text("Tâches du projet")),
      body: SingleChildScrollView(
        child: ExpansionPanelList(
          expansionCallback: (index, isExpanded) {
            setState(() {
              _isExpandedList[index] = !isExpanded;
            });
          },
          children: taches.asMap().entries.map((entry) {
            final index = entry.key;
            final tache = entry.value;
            final controller = _controllers[tache.id]!;

            return ExpansionPanel(
              isExpanded: _isExpandedList[index],
              headerBuilder: (context, isExpanded) => ListTile(
                title: Text(tache.title, style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Row(
                  children: [
                    _buildChip(tache.priority, _priorityColor(tache.priority)),
                    SizedBox(width: 5),
                    _buildChip(tache.status, _statusColor(tache.status)),
                    SizedBox(width: 10),
                    Text(DateFormat('dd/MM/yyyy').format(tache.dueDate),
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Description:", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text(tache.description),
                    SizedBox(height: 10),
                    Text("Progression: ${(tache.progress * 100).toInt()}%"),
                    LinearProgressIndicator(value: tache.progress),
                    SizedBox(height: 10),
                    Text("Assigné à : ${tache.assignedTo}"),
                    SizedBox(height: 10),
                    Text("Discussion:", style: TextStyle(fontWeight: FontWeight.bold)),
                    ...tache.comments.map((c) => ListTile(
                      leading: CircleAvatar(child: Text(c.author[0])),
                      title: Text(c.author),
                      subtitle: Text(c.content),
                      trailing: Text(c.timeAgo),
                    )),
                    TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: "Ajouter un commentaire...",
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            final content = controller.text.trim();
                            if (content.isNotEmpty) {
                              final comment = CommentModel(
                                author: "Moi",
                                content: content,
                                date: DateTime.now(),
                              );
                              Provider.of<TacheProvider>(context, listen: false)
                                  .addComment(tache.id, comment);
                              controller.clear();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTacheDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Chip(
      label: Text(label, style: TextStyle(color: Colors.white)),
      backgroundColor: color,
      visualDensity: VisualDensity.compact,
    );
  }

  Color _priorityColor(String priority) {
    switch (priority) {
      case 'Haute':
        return Colors.orange;
      case 'Moyenne':
        return Colors.blue;
      case 'Basse':
        return Colors.green;
      case 'Urgente':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'À faire':
        return Colors.grey;
      case 'En cours':
        return Colors.blue;
      case 'Terminé':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _showAddTacheDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final titleController = TextEditingController();
        final descriptionController = TextEditingController();
        return AlertDialog(
          title: Text('Ajouter une nouvelle tâche'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(hintText: 'Titre'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(hintText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newTache = TacheModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  priority: 'Moyenne',
                  status: 'À faire',
                  dueDate: DateTime.now().add(Duration(days: 1)),
                  description: descriptionController.text,
                  assigneeName: 'Moi',
                  progress: 0,
                  comments: [],
                  projectId: widget.projectId,
                );
                Provider.of<TacheProvider>(context, listen: false)
                    .addTache(newTache);
                Navigator.of(context).pop();
              },
              child: Text('Ajouter'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
          ],
        );
      },
    );
  }
}