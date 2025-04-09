import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Méthode d'inscription
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Créer un utilisateur avec Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Ajouter l'utilisateur dans Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': name,
        'email': email,
        'createdAt': Timestamp.now(),
      });

      // Notification pour signaler que l'utilisateur a été créé
      notifyListeners();
    } catch (e) {
      // Lancer l'erreur pour la gérer dans RegisterScreen
      throw e;
    }
  }
  // Méthode de connexion
  Future<bool> login({required String email, required String password}) async {
    try {
      // Connexion de l'utilisateur avec l'email et le mot de passe
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Connexion réussie, tu peux faire ce que tu veux ici
      return true; // Retourner true pour indiquer que la connexion a réussi
    } catch (e) {
      // Gérer les erreurs
      print('Erreur de connexion: $e');
      return false; // Retourner false si la connexion a échoué
    }
  }
}


