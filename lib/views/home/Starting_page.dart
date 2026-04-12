import 'package:devmob_coloc_flutter_project/views/home/auth_screen.dart';
import 'package:flutter/material.dart';

class BinomePage extends StatelessWidget {
  const BinomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 1),

              // Image (assurez-vous d'avoir l'image dans assets/images/)
              Image.asset(
                'assets/binome.png', // Remplacez par le nom de votre fichier image
                height: 200,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 20),

              // Titre "Binome" / "Binôme"
              const Text(
                'Binôme',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                  letterSpacing: 1.2,
                ),
              ),

              // Sous-titre "Binôme"

              const SizedBox(height: 100),

              // Description
              const Text(
                'Colocation efficace et fluide',
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFF23A0EA),
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              // Bouton "Commencez Maintenant"
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // Action du bouton

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF23A0EA),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Commencez Maintenant',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Lien "Connectez-vous"
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Vous avez déjà un compte ? ',
                    style: TextStyle(
                      color: Color(0xFF444444),
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Action de connexion
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Redirection vers connexion')),
                      );
                    },
                    child: const Text(
                      'Connectez-vous',
                      style: TextStyle(
                        color: Color(0xFF444444),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
