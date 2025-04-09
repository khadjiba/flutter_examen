import 'package:flutter/material.dart';
import '../models/tache_model.dart';
import '../models/comment_model.dart';

class TacheProvider with ChangeNotifier {
  List<TacheModel> _taches = [];

  void setTaches(List<TacheModel> taches) {
    _taches = taches;
    notifyListeners();
  }

  List<TacheModel> get taches => _taches;

  List<TacheModel> getTachesByProject(String projectId) {
    return _taches.where((tache) => tache.projectId == projectId).toList();
  }

  void addTache(TacheModel tache) {
    _taches.add(tache);
    notifyListeners();
  }

  void addComment(String tacheId, CommentModel comment) {
    final index = _taches.indexWhere((t) => t.id == tacheId);
    if (index != -1) {
      _taches[index].comments.add(comment);
      notifyListeners();
    }
  }
}