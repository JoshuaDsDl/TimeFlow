import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gestion_temps/main.dart';

class ModeleMinuteur {
  String? temps;
  double? pourcentage;
  ModeleMinuteur(this.temps, this.pourcentage);
}

class Minuteur {
  double _pourcentage = 0.0;
  bool _estActif = false;
  Duration _temps = const Duration();
  Duration _tempsTotal = const Duration();
  
  int tempsTravail = 30;
  int tempsPauseCourte = 5;
  int tempsPauseLongue = 20;

  static const int TEMPS_TRAVAIL_DEFAUT = 30;
  static const int TEMPS_PAUSE_COURTE_DEFAUT = 5;
  static const int TEMPS_PAUSE_LONGUE_DEFAUT = 20;
  
  double get pourcentage => _pourcentage;
  String get temps => retournerTemps(_temps);

  String retournerTemps(Duration t) {
    String minutes = t.inMinutes.toString().padLeft(2, '0');
    int numSecondes = t.inSeconds - (t.inMinutes * 60);
    String secondes = numSecondes.toString().padLeft(2, '0');
    String tempsFormate = '$minutes:$secondes';
    return tempsFormate;
  }

  // Variable pour stocker le dernier pourcentage
  double _dernierPourcentage = 0.0;
  bool _premierAppel = true;

  Stream<ModeleMinuteur> stream() async* {
    yield* Stream.periodic(const Duration(seconds: 1), (int a) {
      // Si c'est le premier appel, initialiser avec le pourcentage calculé
      if (_premierAppel) {
        _premierAppel = false;
        if (_tempsTotal.inSeconds != 0) {
          _dernierPourcentage = 1.0 - (_temps.inSeconds / _tempsTotal.inSeconds);
        } else {
          _dernierPourcentage = 0.0;
        }
      }

      if (_estActif) {
        _temps = _temps - const Duration(seconds: 1);
      
        if (_temps.inSeconds <= 0) {
          _estActif = false;
          _temps = const Duration();
          _dernierPourcentage = 1.0; // Complètement rempli quand terminé
        } else if (_tempsTotal.inSeconds != 0) {
          // Pourcentage inversé pour que le cercle se remplisse au fur et à mesure
          _dernierPourcentage = 1.0 - (_temps.inSeconds / _tempsTotal.inSeconds);
        }
      }
      
      _pourcentage = _dernierPourcentage;
      return ModeleMinuteur(retournerTemps(_temps), _pourcentage);
    });
  }

  Future<void> lireParametres() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    tempsTravail = preferences.getInt(CLE_TEMPS_TRAVAIL) ?? TEMPS_TRAVAIL_DEFAUT;
    tempsPauseCourte = preferences.getInt(CLE_PAUSE_COURTE) ?? TEMPS_PAUSE_COURTE_DEFAUT;
    tempsPauseLongue = preferences.getInt(CLE_PAUSE_LONGUE) ?? TEMPS_PAUSE_LONGUE_DEFAUT;
  }

  Future<void> demarrerTravail() async {
    await lireParametres();
    _estActif = true;
    _temps = Duration(minutes: tempsTravail);
    _tempsTotal = Duration(minutes: tempsTravail);
    _pourcentage = 0.0; // Commence vide
    _dernierPourcentage = 0.0;
    _premierAppel = true;
  }

  Future<void> demarrerPause(bool estPauseCourte) async {
    await lireParametres();
    _estActif = true;
    if (estPauseCourte) {
      _temps = Duration(minutes: tempsPauseCourte);
      _tempsTotal = Duration(minutes: tempsPauseCourte);
    } else {
      _temps = Duration(minutes: tempsPauseLongue);
      _tempsTotal = Duration(minutes: tempsPauseLongue);
    }
    _pourcentage = 0.0; // Commence vide
    _dernierPourcentage = 0.0;
    _premierAppel = true;
  }

  void arreterMinuteur() {
    _estActif = false;
  }

  void relancerMinuteur() {
    if (_temps.inSeconds > 0) {
      _estActif = true;
    }
  }
}
