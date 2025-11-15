# caf

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

/////////////////////////////////////////////
Les rôles de chaque dossier:
    models/
        Contiennent toutes les classes représentant les données.
        Chaque modèle correspond à une table dans la base Oracle via le backend.

    services/
        Contient toute la logique de communication entre Flutter et le backend.\
        Chaque service :
            envoie les requêtes HTTP au backend,
            reçoit les données,
            les convertit en modèles.
                    auth_service.dart → login / register
                    chauffeur_service.dart → CRUD chauffeurs
                    vehicule_service.dart → CRUD véhicules

Install Flutter :

1. Aller sur : https://docs.flutter.dev/get-started/install
Télécharger la version Windows

2. Extraire dans :
    C:\src\flutter (Creer un Dossier src in disque Local C)
(ne pas utiliser Downloads / Desktop)

3. Vérifier l'installation
    Dans CMD :
    flutter doctor

4.Dans VS Code → Extensions :
    Flutter
    Dart

5. Installer Android Studio (pour l'émulateur)
    Installer Android Studio
    SDK Manager → installer Android SDK
    Virtual Device Manager → créer un émulateur

6. Créer un projet Flutter
    flutter create my_app
    cd my_app
    code .

7. Lancer l'application
    flutter run