import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Importation de Google Fonts
import 'database_helper.dart';
import 'notes_list_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final dbHelper = DatabaseHelper();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _createDefaultUser();
    // Pour les tests, pré-remplir les champs
    _usernameController.text = 'test';
    _passwordController.text = '1234';
  }

  void _createDefaultUser() async {
    var user = await dbHelper.getUser('test', '1234');
    if (user == null) {
      await dbHelper.createUser('test', '1234');
      print("Utilisateur de test créé.");
    }
  }

  void _login() async {
    // Démarre l'indicateur de chargement
    setState(() {
      _isLoading = true;
    });

    String username = _usernameController.text.trim();
    String password = _passwordController.text;

    await Future.delayed(const Duration(seconds: 1)); 

    var user = await dbHelper.getUser(username, password);
    
    // Arrête l'indicateur de chargement
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }

    if (user != null) {
      Navigator.pushReplacement( 
        context,
        MaterialPageRoute(builder: (context) => const NotesListPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nom d\'utilisateur ou mot de passe incorrect.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
     
      backgroundColor: Colors.grey[50], 
      body: SafeArea(
        child: SingleChildScrollView( 
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                
                Icon(
                  Icons.note_alt_rounded, 
                  size: 80,
                  color: theme.primaryColor,
                ),
                const SizedBox(height: 20),
                Text(
                  'Bienvenue !',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins( 
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Connectez-vous pour continuer',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 48),

              
                TextFormField(
                  controller: _usernameController,
                  keyboardType: TextInputType.text,
                  style: GoogleFonts.poppins(),
                  decoration: InputDecoration(
                    labelText: "Nom d'utilisateur",
                    prefixIcon: Icon(Icons.person_outline_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible, 
                  style: GoogleFonts.poppins(),
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    prefixIcon: Icon(Icons.lock_outline_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                 
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () { /* Logique pour mot de passe oublié */ },
                    child: Text(
                      'Mot de passe oublié ?',
                      style: GoogleFonts.poppins(color: theme.primaryColor),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
              
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : Text(
                          'Connexion',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
                const SizedBox(height: 48),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Vous n'avez pas de compte ?",
                      style: GoogleFonts.poppins(),
                    ),
                    TextButton(
                      onPressed: () { /* Logique pour la création de compte */ },
                      child: Text(
                        'Inscrivez-vous',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}