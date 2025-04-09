import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/comment_model.dart';
import '../models/tache_model.dart';
import '../provider/tache_provider.dart';

class TacheWidget extends StatefulWidget {
  final TacheModel task;

  const TacheWidget({super.key, required this.task});

  @override
  State<TacheWidget> createState() => _TacheWidgetState();
}

class _TacheWidgetState extends State<TacheWidget> {
  bool isExpanded = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      elevation: 1,
      expansionCallback: (index, expanded) {
        setState(() {
          isExpanded = !expanded;
        });
      },
      children: [
        ExpansionPanel(
          isExpanded: isExpanded,
          headerBuilder: (context, isOpen) => ListTile(
            title: Text(widget.task.title, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Row(
              children: [
                _badge(widget.task.priority, _priorityColor(widget.task.priority)),
                SizedBox(width: 6),
                _badge(widget.task.status, _statusColor(widget.task.status)),
                SizedBox(width: 6),
                Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                Text(" ${widget.task.dueDateFormatted}", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _labelText("Description:", widget.task.description),
                _labelText("Progression:", "${(widget.task.progress * 100).toInt()}%", withBar: true),
                _labelText("Assigné à:", widget.task.assignedTo),
                SizedBox(height: 10),
                Text("Discussion:", style: TextStyle(fontWeight: FontWeight.bold)),
                ...widget.task.comments.map((c) => _buildComment(c)).toList(),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: "Ajouter un commentaire...",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        if (_commentController.text.trim().isNotEmpty) {
                          final comment = CommentModel(
                            author: "Vous",
                            content: _commentController.text.trim(),
                            date: DateTime.now(),
                          );
                          Provider.of<TacheProvider>(context, listen: false)
                              .addComment(widget.task.id, comment);
                          _commentController.clear();
                        }
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: TextStyle(color: color)),
    );
  }

  Widget _labelText(String label, String text, {bool withBar = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        if (withBar)
          Column(
            children: [
              LinearProgressIndicator(value: widget.task.progress),
              SizedBox(height: 4),
              Text(text),
            ],
          )
        else
          Text(text),
        SizedBox(height: 6),
      ],
    );
  }

  Widget _buildComment(CommentModel c) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        child: Text(c.author[0].toUpperCase()),
      ),
      title: Text(c.author),
      subtitle: Text("${c.content}\n${c.timeAgo}"),
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
}