# <div align="center">TimeFlow ⏱️</div>

<div align="center">

![Flutter Version](https://img.shields.io/badge/Flutter-3.x-7E57C2?style=for-the-badge&logo=flutter)
![Dart Version](https://img.shields.io/badge/Dart-3.x-7E57C2?style=for-the-badge&logo=dart)
![License](https://img.shields.io/badge/License-MIT-7E57C2?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Android-7E57C2?style=for-the-badge&logo=android)

Une application de gestion du temps élégante et intuitive, inspirée de la technique Pomodoro, développée avec Flutter.

> 🎓 Projet réalisé dans le cadre du cours de Développement Mobile à l'IMT Nord Europe.

</div>

## ✨ Fonctionnalités

- Gestion des sessions de travail et de pauses
- Trois modes: Travail, Mini Pause, Maxi Pause
- Minuterie visuelle avec indicateur de progression circulaire
- Interface Material Design 3 moderne avec dégradés
- Thème clair/sombre personnalisable
- Paramètres ajustables pour les durées
- Interface responsive et adaptative
- Persistance des préférences utilisateur

## 🛠️ Technologies Utilisées

- **Framework**: Flutter 3.x
- **Language**: Dart 3.x
- **UI**: Material Design 3
- **État**: StatefulWidget
- **Persistance**: SharedPreferences
- **Visualisation**: percent_indicator

## 📦 Structure du Projet

```
lib/
├── minuteur.dart             # Logique du minuteur et gestion du temps
├── page_parametres.dart      # Page de configuration des durées
├── page_accueil_minuterie.dart # Interface principale avec minuteur
├── bouton.dart               # Composants de boutons personnalisés
└── main.dart                 # Point d'entrée et gestion du thème
```

## 🚀 Installation

1. Assurez-vous d'avoir Flutter installé sur Windows
2. Clonez le repository
3. Installez les dépendances :
```bash
flutter pub get
```

4. Lancez l'application :
```bash
flutter run
```

## 🔧 Architecture

L'application suit une architecture simple et efficace :

- **Minuteur**: Gestion du temps, calcul des pourcentages, stream de données
- **UI**: Interface utilisateur avec Material Design 3 et animations fluides
- **Paramètres**: Persistance des préférences utilisateur
- **Main**: Configuration de l'application et gestion du thème

## 📝 Licence

TimeFlow est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

```
MIT License

Copyright (c) 2025 JDSoft

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

<div align="center">
<sub>Développé avec ❤️ par Joshua DESCHIETERE</sub>
</div>
