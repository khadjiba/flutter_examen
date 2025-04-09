import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../models/project_model.dart';
import '../../provider/project_controller.dart';

class CreateProjectScreen extends StatefulWidget {
  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  String _priority = "Moyenne";
  bool _isSaving = false;

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? DateTime.now() : (_startDate ?? DateTime.now()).add(Duration(days: 7)),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        isStart ? _startDate = picked : _endDate = picked;
      });
    }
  }

  Future<void> _saveProjectToFirestore() async {
    if (_titleController.text.isEmpty ||
        _descController.text.isEmpty ||
        _startDate == null ||
        _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Tous les champs doivent être remplis !")),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final project = ProjectModel(
      id: id,
      titre: _titleController.text,
      description: _descController.text,
      dateDebut: _startDate!,
      dateFin: _endDate!,
      priorite: _priority,
      statut: "En attente",
      createdAt: DateTime.now(),
    );

    try {
      await FirebaseFirestore.instance
          .collection('projets')
          .doc(id)
          .set(project.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Projet enregistré avec succès !")),
      );

      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de l'enregistrement : $e")),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Créer un projet")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Titre du projet",
                prefixIcon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Description",
                prefixIcon: Icon(Icons.description),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    onTap: () => _selectDate(context, true),
                    leading: const Icon(Icons.date_range),
                    title: const Text("Date de début"),
                    subtitle: Text(_startDate != null
                        ? "${_startDate!.day}/${_startDate!.month}/${_startDate!.year}"
                        : "Non défini"),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    onTap: () => _selectDate(context, false),
                    leading: const Icon(Icons.date_range),
                    title: const Text("Date de fin"),
                    subtitle: Text(_endDate != null
                        ? "${_endDate!.day}/${_endDate!.month}/${_endDate!.year}"
                        : "Non défini"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text("Priorité", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Column(
              children: ["Basse", "Moyenne", "Haute", "Urgente"].map((p) {
                return RadioListTile<String>(
                  value: p,
                  groupValue: _priority,
                  title: Text(p),
                  onChanged: (val) => setState(() => _priority = val!),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSaving ? null : _saveProjectToFirestore,
              child: _isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Créer le projet"),
            ),
          ],
        ),
      ),
    );
  }
}
