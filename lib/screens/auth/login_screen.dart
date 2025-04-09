import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importer provider
import '../../provider/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const SizedBox(height: 80),
            const Text(
              "SunuProjet",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "Connectez-vous pour continuer",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Adresse Email",
                prefixIcon: Icon(Icons.mail),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: "Mot de passe",
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // TODO: Ajouter reset password si besoin
              },
              child: const Text("Mot de passe oublié ?"),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                // Utilisation de provider pour l'authentification
                final authController = Provider.of<AuthController>(context, listen: false);
                bool success = await authController.login(
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim(),
                );

                // Si la connexion est réussie, rediriger vers la page d'accueil
                if (success) {
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  // Gérer l'erreur de connexion (par exemple, afficher un message)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Échec de la connexion')),
                  );
                }
              },
              child: const Text("Se connecter"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text("Pas de compte ? Inscrivez-vous"),
            )
          ],
        ),
      ),
    );
  }
}
