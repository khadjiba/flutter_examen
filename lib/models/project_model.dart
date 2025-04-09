import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  final String id;
  final String titre;
  final String description;
  final DateTime? dateDebut;
  final DateTime? dateFin;
  final String priorite;
  late final String statut;
  final DateTime createdAt; // <- changer ici

  ProjectModel({
    required this.id,
    required this.titre,
    required this.description,
    required this.dateDebut,
    required this.dateFin,
    required this.priorite,
    required this.statut,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'description': description,
      'dateDebut': dateDebut,
      'dateFin': dateFin,
      'priorite': priorite,
      'statut': statut,
      'createdAt': createdAt, // -> on garde DateTime
    };
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      id: map['id'],
      titre: map['titre'],
      description: map['description'],
      dateDebut: (map['dateDebut'] as Timestamp).toDate(),
      dateFin: (map['dateFin'] as Timestamp).toDate(),
      priorite: map['priorite'],
      statut: map['statut'],
      createdAt: (map['createdAt'] as Timestamp).toDate(), // <- maintenant c'est bon
    );
  }
}
