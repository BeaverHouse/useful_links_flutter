import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:useful_links_app/firebase_options.dart';
import 'package:useful_links_app/providers/auth_provider.dart';
import 'package:useful_links_app/providers/firestore_provider.dart';
import 'package:useful_links_app/widgets/pages/home.dart';
import 'package:useful_links_app/widgets/pages/login.dart';
import 'package:useful_links_app/widgets/pages/register.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget  {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthProvider>(
          create: (_) => AuthProvider(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthProvider>().authState,
          initialData: null,
        ),
        Provider<StoreProvider>(
          create: (_) => StoreProvider(FirebaseFirestore.instance.collection("useful_links")),
        ),
        StreamProvider(
          create: (context) =>
              context.read<StoreProvider>().dataStream,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        title: 'Useful Links',
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('ko', ''),
        ],
        home: const SplashScreen(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return PageTransition(
                child: const HomePage(),
                type: PageTransitionType.rightToLeftWithFade,
                settings: settings,
                duration: const Duration(seconds: 1),
                reverseDuration: const Duration(seconds: 1),
              );
            case '/login':
              return PageTransition(
                child: const LoginPage(),
                type: PageTransitionType.rightToLeftWithFade,
                settings: settings,
                duration: const Duration(seconds: 1),
                reverseDuration: const Duration(seconds: 1),
              );
            case '/register':
              return PageTransition(
                child: const RegisterPage(),
                type: PageTransitionType.rightToLeftWithFade,
                settings: settings,
                duration: const Duration(seconds: 1),
                reverseDuration: const Duration(seconds: 1),
              );
            default:
              return null;
          }
        },
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return const HomePage();
    }
    return const LoginPage();
  }
}