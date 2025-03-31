import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:gestion_temps/bouton.dart';
import 'package:gestion_temps/minuteur.dart';
import 'page_parametres.dart';

const double REMPLISSAGE_DEFAUT = 5.0;

// Palette de couleurs harmonisée
const Color couleurPrincipale = Color(0xFF9C27B0); // Violet
const Color couleurSecondaire = Color(0xFFE91E63); // Rose
const Color couleurTravail = Color(0xFF673AB7); // Violet foncé
const Color couleurPauseCourte = Color(0xFFBA68C8); // Violet clair
const Color couleurPauseLongue = Color(0xFFD81B60); // Rose foncé
const Color couleurArret = Color(0xFF7E57C2); // Indigo
const Color couleurRelance = Color(0xFFAB47BC); // Violet clair
// Ces couleurs seront utilisées dynamiquement en fonction du mode
const Color couleurFondIndicateurClair = Color(0xFFE0E0E0); // Gris clair pour mode clair
const Color couleurFondIndicateurSombre = Color(0xFF424242); // Gris foncé pour mode sombre

class PageAccueilMinuterie extends StatefulWidget {
  final VoidCallback onThemeChange;
  final bool estModeSombre;

  const PageAccueilMinuterie({
    Key? key,
    required this.onThemeChange,
    required this.estModeSombre,
  }) : super(key: key);

  @override
  State<PageAccueilMinuterie> createState() => _PageAccueilMinuterieState();
}

class _PageAccueilMinuterieState extends State<PageAccueilMinuterie> {
  final Minuteur minuteur = Minuteur();
  String? _resultat;
  bool _estErreur = false;
  bool _minuteurActif = true;
  String _modeActuel = 'travail';

  @override
  void initState() {
    super.initState();
    minuteur.demarrerTravail();
  }

  void _mettreAJourResultat(String resultat, bool estErreur) {
    setState(() {
      _resultat = resultat;
      _estErreur = estErreur;
    });
  }

  void allerParametres(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PageParametres(estModeSombre: widget.estModeSombre)),
    );
  }

  void _changerEtatMinuteur(bool estActif) {
    setState(() {
      _minuteurActif = estActif;
    });
    
    if (estActif) {
      minuteur.relancerMinuteur();
    } else {
      minuteur.arreterMinuteur();
    }
  }

  void _changerMode(String mode) {
    setState(() {
      _modeActuel = mode;
      _minuteurActif = true;
    });
    
    switch (mode) {
      case 'travail':
        minuteur.demarrerTravail();
        break;
      case 'courte':
        minuteur.demarrerPause(true);
        break;
      case 'longue':
        minuteur.demarrerPause(false);
        break;
    }
  }

  Color _getCouleurActive() {
    switch (_modeActuel) {
      case 'travail':
        return couleurTravail;
      case 'courte':
        return couleurPauseCourte;
      case 'longue':
        return couleurPauseLongue;
      default:
        return couleurPrincipale;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<PopupMenuItem<String>> elementsMenu = [];
    elementsMenu.add(
      const PopupMenuItem(
        value: 'Param',
        child: Text('Paramètres'),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: couleurPrincipale,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.timer),
            SizedBox(width: 8),
            Text('TimeFlow'),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => allerParametres(context),
            tooltip: 'Paramètres',
          ),
          IconButton(
            icon: Icon(
              widget.estModeSombre ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: widget.onThemeChange,
            tooltip: widget.estModeSombre
                ? 'Passer en mode clair'
                : 'Passer en mode sombre',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: widget.estModeSombre
                ? [const Color(0xFF303030), const Color(0xFF212121)]
                : [const Color(0xFFF5F5F5), Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: BoutonMode(
                            texte: 'Travail',
                            icone: Icons.work,
                            couleur: couleurTravail,
                            onPressed: () => _changerMode('travail'),
                            estActif: _modeActuel == 'travail',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: BoutonMode(
                            texte: 'Mini Pause',
                            icone: Icons.coffee,
                            couleur: couleurPauseCourte,
                            onPressed: () => _changerMode('courte'),
                            estActif: _modeActuel == 'courte',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: BoutonMode(
                            texte: 'Maxi Pause',
                            icone: Icons.beach_access,
                            couleur: couleurPauseLongue,
                            onPressed: () => _changerMode('longue'),
                            estActif: _modeActuel == 'longue',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: StreamBuilder(
                      initialData: ModeleMinuteur('00:00', 0),
                      stream: minuteur.stream(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        ModeleMinuteur chrono = snapshot.data;
                        return Column(
                          children: [
                            Text(
                              'Temps restant',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 20),
                            CircularPercentIndicator(
                              radius: 130.0,
                              lineWidth: 12.0,
                              percent: chrono.pourcentage ?? 0.0,
                              center: Text(
                                chrono.temps ?? '00:00',
                                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              progressColor: _getCouleurActive(),
                              backgroundColor: widget.estModeSombre
                                  ? couleurFondIndicateurSombre
                                  : couleurFondIndicateurClair,
                              animation: true,
                              animateFromLastPercent: true,
                              animationDuration: 300,
                              circularStrokeCap: CircularStrokeCap.round,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              _modeActuel == 'travail' 
                                ? 'Mode travail' 
                                : _modeActuel == 'courte' 
                                  ? 'Mode mini pause' 
                                  : 'Mode maxi pause',
                              style: TextStyle(
                                color: _getCouleurActive(),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: BoutonToggle(
                    estActif: _minuteurActif,
                    onChanged: _changerEtatMinuteur,
                    texteActif: 'Minuteur en cours',
                    texteInactif: 'Minuteur en pause',
                    couleurActif: couleurRelance,
                    couleurInactif: couleurArret,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: Text(
                    'Fait avec ❤️ par Joshua Deschietere',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).brightness == Brightness.dark 
                          ? Colors.grey[400] 
                          : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
