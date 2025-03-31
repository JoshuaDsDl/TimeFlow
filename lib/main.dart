import 'package:flutter/material.dart';
import 'package:gestion_temps/page_accueil_minuterie.dart';

const String CLE_TEMPS_TRAVAIL = 'Temps de travail';
const String CLE_PAUSE_COURTE = 'Pause courte';
const String CLE_PAUSE_LONGUE = 'Pause longue';

// Point d'entrée de l'app
void main() {
  runApp(const MainApp());
}

// Le widget principal qui gère le thème de l'app
class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  // Pour savoir si on est en mode sombre ou clair
  bool _estModeSombre = false;

  // Pour switcher entre les modes
  void _changerTheme() {
    setState(() {
      _estModeSombre = !_estModeSombre;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion du temps',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: _estModeSombre ? Brightness.dark : Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: PageAccueilMinuterie(
        onThemeChange: _changerTheme,
        estModeSombre: _estModeSombre,
      ),
    );
  }
}
