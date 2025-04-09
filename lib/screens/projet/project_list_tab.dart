import 'package:flutter/material.dart';
import '../../models/project_model.dart';

class ProjectListTab extends StatelessWidget {
  final String tabName;
  final List<ProjectModel> projets;

  const ProjectListTab({
    required this.tabName,
    required this.projets,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: projets.length,
      itemBuilder: (context, index) {
        final projet = projets[index];
        return ListTile(
          title: Text(projet.titre),
          subtitle: Text(projet.description),
          trailing: Text(projet.statut), // Afficher le statut du projet
          onTap: () {
            // Action au clic sur le projet
          },
        );
      },
    );
  }
}
