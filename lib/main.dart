import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bio_track/startScreen.dart';
import 'package:bio_track/stillStart.dart';
import 'package:bio_track/LandingPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bio_track/logInPage.dart';
import 'package:bio_track/register.dart';

// Add this global variable
bool ignoreAuthChanges = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BioTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
        primaryTextTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).primaryTextTheme,
        ),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF0383C2),
        ),
      ),
      home: StartScreen(), // Set StartScreen as the initial screen
    );
  }
}

// If you have an AuthenticationWrapper class like this:
class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Disable auto-navigation based on auth state
    return HomePage();

    // Comment out any code like this:
    /*
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return StartScreen();
        }
        return HomePage();
      },
    );
    */
  }
}
