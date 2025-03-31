import 'package:flutter/material.dart';

class BoutonGenerique extends StatelessWidget {
  final Color couleur;
  final String texte;
  final double taille;
  final VoidCallback action;
  const BoutonGenerique({
    Key? key,
    required this.couleur,
    required this.texte,
    required this.taille,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: action,
      style: ElevatedButton.styleFrom(
        backgroundColor: couleur,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12.0),
      ),
      child: Text(
        texte,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

typedef CallbackSetting = void Function(String, int);

class BoutonParametre extends StatelessWidget {
  final Color couleur;
  final String texte;
  final int valeur;
  final String parametre;
  final CallbackSetting action;

  const BoutonParametre({
    Key? key,
    required this.couleur,
    required this.texte,
    required this.valeur,
    required this.parametre,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => action(parametre, valeur),
      style: ElevatedButton.styleFrom(
        backgroundColor: couleur,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
        minimumSize: const Size(48, 48),
      ),
      child: Text(
        texte,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class BoutonMode extends StatelessWidget {
  final String texte;
  final IconData icone;
  final Color couleur;
  final VoidCallback onPressed;
  final bool estActif;

  const BoutonMode({
    Key? key,
    required this.texte,
    required this.icone,
    required this.couleur,
    required this.onPressed,
    this.estActif = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: estActif ? 8 : 2,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            color: estActif ? couleur : couleur.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: estActif ? Colors.white.withOpacity(0.5) : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icone,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                texte,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BoutonToggle extends StatelessWidget {
  final bool estActif;
  final Function(bool) onChanged;
  final String texteActif;
  final String texteInactif;
  final Color couleurActif;
  final Color couleurInactif;

  const BoutonToggle({
    Key? key,
    required this.estActif,
    required this.onChanged,
    required this.texteActif,
    required this.texteInactif,
    required this.couleurActif,
    required this.couleurInactif,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!estActif),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: estActif ? couleurActif : couleurInactif,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              estActif ? texteActif : texteInactif,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: estActif ? 16 : 14,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              estActif ? Icons.play_arrow : Icons.pause,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
