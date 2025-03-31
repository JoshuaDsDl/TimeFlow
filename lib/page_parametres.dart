import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gestion_temps/bouton.dart';
import 'package:gestion_temps/main.dart';

const int TEMPS_TRAVAIL_DEFAUT = 30;
const int TEMPS_PAUSE_COURTE_DEFAUT = 5;
const int TEMPS_PAUSE_LONGUE_DEFAUT = 20;

const String TEMPS_TRAVAIL = 'temps_travail';
const String PAUSE_COURTE = 'pause_courte';
const String PAUSE_LONGUE = 'pause_longue';

// Palette de couleurs harmonisée
const Color couleurPrincipale = Color(0xFF9C27B0); // Violet
const Color couleurSecondaire = Color(0xFFE91E63); // Rose
const Color couleurBoutonPlus = Color(0xFF8E24AA); // Violet foncé
const Color couleurBoutonMoins = Color(0xFF5E35B1); // Indigo

class PageParametres extends StatelessWidget {
  final bool estModeSombre;
  
  const PageParametres({Key? key, required this.estModeSombre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: couleurPrincipale,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.settings),
            SizedBox(width: 8),
            Text('Paramètres'),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: estModeSombre
                ? [const Color(0xFF303030), const Color(0xFF212121)]
                : [const Color(0xFFF5F5F5), Colors.white],
          ),
        ),
        child: const Parametres(),
      ),
    );
  }
}

class Parametres extends StatefulWidget {
  const Parametres({Key? key}) : super(key: key);

  @override
  State<Parametres> createState() => _ParametresState();
}

class _ParametresState extends State<Parametres> {
  TextEditingController txtTempsTravail = TextEditingController();
  TextEditingController txtTempsPauseCourte = TextEditingController();
  TextEditingController txtTempsPauseLongue = TextEditingController();

  @override
  void initState() {
    lireParametres();
    super.initState();
  }

  @override
  void dispose() {
    txtTempsTravail.dispose();
    txtTempsPauseCourte.dispose();
    txtTempsPauseLongue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle styleTexte = const TextStyle(fontSize: 16);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildParameterCard(
            context: context,
            titre: 'Temps de travail',
            description: 'Définir la durée des sessions de travail',
            icone: Icons.work,
            controller: txtTempsTravail,
            parametre: TEMPS_TRAVAIL,
            styleTexte: styleTexte,
          ),
          const SizedBox(height: 16),
          _buildParameterCard(
            context: context,
            titre: 'Temps pour une pause courte',
            description: 'Définir la durée des pauses courtes',
            icone: Icons.coffee,
            controller: txtTempsPauseCourte, 
            parametre: PAUSE_COURTE,
            styleTexte: styleTexte,
          ),
          const SizedBox(height: 16),
          _buildParameterCard(
            context: context,
            titre: 'Temps pour une pause longue',
            description: 'Définir la durée des pauses longues',
            icone: Icons.beach_access,
            controller: txtTempsPauseLongue,
            parametre: PAUSE_LONGUE,
            styleTexte: styleTexte,
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
    );
  }

  Widget _buildParameterCard({
    required BuildContext context,
    required String titre,
    required String description,
    required IconData icone,
    required TextEditingController controller,
    required String parametre,
    required TextStyle styleTexte,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icone, color: couleurPrincipale),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titre,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark 
                              ? Colors.grey[300] 
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                BoutonParametre(
                  couleur: couleurBoutonMoins,
                  texte: '-',
                  valeur: -1,
                  parametre: parametre,
                  action: majParametres,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: controller,
                      style: styleTexte,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        labelText: 'Minutes',
                        suffixText: 'min',
                      ),
                    ),
                  ),
                ),
                BoutonParametre(
                  couleur: couleurBoutonPlus,
                  texte: '+',
                  valeur: 1,
                  parametre: parametre,
                  action: majParametres,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void majParametres(String key, int value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    
    switch (key) {
      case TEMPS_TRAVAIL:
        int tempsTravail = preferences.getInt(CLE_TEMPS_TRAVAIL) ?? TEMPS_TRAVAIL_DEFAUT;
        tempsTravail += value;
        if (tempsTravail >= 1 && tempsTravail <= 180) {
          preferences.setInt(CLE_TEMPS_TRAVAIL, tempsTravail);
          setState(() {
            txtTempsTravail.text = tempsTravail.toString();
          });
        }
        break;
      case PAUSE_COURTE:
        int tempsPauseCourte = preferences.getInt(CLE_PAUSE_COURTE) ?? TEMPS_PAUSE_COURTE_DEFAUT;
        tempsPauseCourte += value;
        if (tempsPauseCourte >= 1 && tempsPauseCourte <= 30) {
          preferences.setInt(CLE_PAUSE_COURTE, tempsPauseCourte);
          setState(() {
            txtTempsPauseCourte.text = tempsPauseCourte.toString();
          });
        }
        break;
      case PAUSE_LONGUE:
        int tempsPauseLongue = preferences.getInt(CLE_PAUSE_LONGUE) ?? TEMPS_PAUSE_LONGUE_DEFAUT;
        tempsPauseLongue += value;
        if (tempsPauseLongue >= 1 && tempsPauseLongue <= 60) {
          preferences.setInt(CLE_PAUSE_LONGUE, tempsPauseLongue);
          setState(() {
            txtTempsPauseLongue.text = tempsPauseLongue.toString();
          });
        }
        break;
    }
  }

  lireParametres() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? tempsTravail = preferences.getInt(CLE_TEMPS_TRAVAIL);
    if (tempsTravail == null) {
      await preferences.setInt(CLE_TEMPS_TRAVAIL, TEMPS_TRAVAIL_DEFAUT);
      tempsTravail = TEMPS_TRAVAIL_DEFAUT;
    }
    int? tempsPauseCourte = preferences.getInt(CLE_PAUSE_COURTE);
    if (tempsPauseCourte == null) {
      await preferences.setInt(CLE_PAUSE_COURTE, TEMPS_PAUSE_COURTE_DEFAUT);
      tempsPauseCourte = TEMPS_PAUSE_COURTE_DEFAUT;
    }
    int? tempsPauseLongue = preferences.getInt(CLE_PAUSE_LONGUE);
    if (tempsPauseLongue == null) {
      await preferences.setInt(CLE_PAUSE_LONGUE, TEMPS_PAUSE_LONGUE_DEFAUT);
      tempsPauseLongue = TEMPS_PAUSE_LONGUE_DEFAUT;
    }
    setState(() {
      txtTempsTravail.text = tempsTravail.toString();
      txtTempsPauseCourte.text = tempsPauseCourte.toString();
      txtTempsPauseLongue.text = tempsPauseLongue.toString();
    });
  }
}
