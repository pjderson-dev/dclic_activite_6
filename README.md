# **Application de Notes - Guide d'Installation**

Ce document vous guidera à travers les étapes nécessaires pour installer, configurer et lancer l'application de notes développée en Flutter.

-----

## **Prérequis** 📋

Avant de commencer, assurez-vous d'avoir les outils suivants installés et configurés sur votre machine :

  * **Le SDK Flutter** : Si ce n'est pas le cas, suivez le [guide officiel d'installation de Flutter](https://flutter.dev/docs/get-started/install).
  * **Un éditeur de code** : [Visual Studio Code](https://code.visualstudio.com/) (recommandé) ou [Android Studio](https://developer.android.com/studio).
  * **Un appareil cible** : Un émulateur Android, un simulateur iOS ou un appareil physique connecté à votre ordinateur.

-----

## **Étapes d'Installation** 🚀

Suivez ces étapes dans votre terminal pour mettre le projet en marche.

### **1. Cloner le Dépôt**

Utilisez Git pour cloner le code source du projet sur votre machine locale.

```bash
git clone https://github.com/pjderson-dev/dclic_activite_6.git
```

### **2. Accéder au Dossier du Projet**

Naviguez dans le dossier qui vient d'être créé.

```bash
cd dclic_activite_6
```

### **3. Installer les Dépendances**

Cette commande télécharge tous les packages nécessaires au projet (comme `google_fonts`, `sqflite`, etc.) listés dans le fichier `pubspec.yaml`.

```bash
flutter pub get
```

### **4. Lancer l'Application**

Assurez-vous qu'un appareil ou un émulateur est en cours d'exécution, puis lancez l'application avec la commande suivante.

```bash
flutter run
```

Le premier démarrage peut prendre quelques minutes. Une fois terminé, l'application s'ouvrira automatiquement sur votre appareil cible.

-----

## **Utilisation** 📝

### **Identifiants de Connexion par Défaut**

Au premier lancement, l'application crée automatiquement un utilisateur de test pour vous permettre de vous connecter immédiatement.

  * **Nom d'utilisateur :** `test`
  * **Mot de passe :** `1234`

### **Fonctionnalités**

  * **Connexion sécurisée** à votre compte de notes.
  * **Création, modification et suppression** de notes.
  * **Interface utilisateur propre et moderne** pour une gestion facile.
  * **Déconnexion** pour sécuriser l'accès.

-----

## **Structure du Projet** 📂

Voici un aperçu des fichiers clés pour vous aider à naviguer dans le code :

  * `lib/main.dart`: Point d'entrée de l'application.
  * `lib/login_page.dart`: Gère l'écran et la logique de connexion.
  * `lib/notes_list_page.dart`: Affiche la liste de toutes les notes et permet la déconnexion.
  * `lib/note_edit_page.dart`: Formulaire pour créer ou modifier une note.
  * `lib/database_helper.dart`: Contient toute la logique pour interagir avec la base de données locale (SQLite).
  * `pubspec.yaml`: Fichier de configuration du projet, incluant les dépendances.

-----

