import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // E-posta ve şifre ile giriş metodu
  Future<void> _loginWithEmail() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      _navigateToHomeScreen();
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Giriş başarısız: ${e.message}')),
      );
    }
  }

  // Google ile giriş metodu için güncellenmiş kod
  Future<void> _loginWithGoogle() async {
    // FirebaseAuth instance to handle authentication.
    try {
      // GoogleSignIn instance to handle Google Sign-In.
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      // Trigger the Google Sign-In flow.
      final googleUser = await _googleSignIn.signIn();

      // User canceled the sign-in.
      if (googleUser == null) {
        // Kullanıcı giriş işlemini iptal ettiyse bir şey yapma.
        _showSnackBar('Google ile giriş işlemi iptal edildi.');
        return;
      };

      // Retrieve the authentication details from the Google account.
      final googleAuth = await googleUser.authentication;

      // Create a new credential using the Google authentication details.
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential.
      await _auth.signInWithCredential(credential);

      // Navigate to the home screen
      _navigateToHomeScreen();

    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google ile giriş başarısız: ${e.message}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $e')),
      );
    }
  }


    void _navigateToHomeScreen() {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }

    void _showSnackBar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Giriş Yap')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-posta'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Şifre'),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loginWithEmail,
                child: const Text('E-posta ile Giriş Yap'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loginWithGoogle,
                icon: const Icon(Icons.g_mobiledata),
                label: const Text('Google ile Giriş Yap'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const SignupScreen()),
                  );
                },
                child: const Text('Hesabınız yok mu? Kayıt Olun'),
              ),
            ],
          ),
        ),
      );
    }
  }