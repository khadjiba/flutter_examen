import 'package:ba_khadjiratou_l3gl_examen/services/project_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/project_model.dart';

class ProjectController extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final ProjectService _projectService = ProjectService();

  List<ProjectModel> _projets  = [];
  List<ProjectModel> get projets => _projets ;

  void fetchProjects() async {
    _projectService.getProjects().listen((projets) {
      print("Projets récupérés: $projets");  // Log des projets récupérés
      _projets = projets;
      notifyListeners();
    });
  }



  Future<void> ajouterProjet(ProjectModel projet) async {
    await _db.collection("projets").doc(projet.id).set(projet.toMap());
    fetchProjects(); // Recharger les projets après ajout
  }

  Future<List<ProjectModel>> getProjetsParStatut(String statut) async {
    final snapshot = await _db
        .collection("projets")
        .where("statut", isEqualTo: statut)
        .get();
    return snapshot.docs
        .map((doc) => ProjectModel.fromMap(doc.data()))
        .toList();
  }
}
