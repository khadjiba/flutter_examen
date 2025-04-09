import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/project_model.dart';

class ProjectService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Stream<List<ProjectModel>> getProjects() {
    return _firestore.collection('projets').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        try {
          return ProjectModel.fromMap(data);
        } catch (e) {
          print("Erreur lors de la conversion : ${e.toString()}");
          return null;
        }
      }).whereType<ProjectModel>().toList();
    });
  }

}