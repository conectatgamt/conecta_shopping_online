import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conecta_shopping_online/screens/login_screen.dart';
import 'package:conecta_shopping_online/screens/register_screen.dart';
import 'package:conecta_shopping_online/screens/home_screen.dart';
import 'package:conecta_shopping_online/screens/doceriajussara_screen.dart';
import 'firebase_options.dart';

// Configuração da segunda instância do Firebase (ConectaSystem)
const FirebaseOptions conectaSystemOptions = FirebaseOptions(
  apiKey: "AIzaSyDc6lT-sHYNwKkc27rS4-m4rrsEyrMVdm4",
  appId: "1:240475601676:android:6ea05724f940e745b72729",
  messagingSenderId: "240475601676",
  projectId: "conectasystem-2936f",
  storageBucket: "conectasystem-2936f.appspot.com",
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialização da instância principal (ConectaShoppingOnline)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicialização da segunda instância (ConectaSystem)
  final FirebaseApp conectaSystemApp = await Firebase.initializeApp(
    name: 'ConectaSystem',
    options: conectaSystemOptions,
  );

  // Obtenção do Firestore para ambas as instâncias
  final FirebaseFirestore conectaShoppingDB = FirebaseFirestore.instance;
  final FirebaseFirestore conectaSystemDB =
  FirebaseFirestore.instanceFor(app: conectaSystemApp);

  runApp(MyApp(
    conectaShoppingDB: conectaShoppingDB,
    conectaSystemDB: conectaSystemDB,
  ));
}

class MyApp extends StatelessWidget {
  final FirebaseFirestore conectaShoppingDB;
  final FirebaseFirestore conectaSystemDB;

  const MyApp({
    super.key,
    required this.conectaShoppingDB,
    required this.conectaSystemDB,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Conecta Shopping Online',
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return MaterialPageRoute(
              builder: (context) => HomeScreen(
                conectaShoppingDB: conectaShoppingDB,
                conectaSystemDB: conectaSystemDB,
              ),
            );
          case '/products':
            return MaterialPageRoute(
              builder: (context) => ProductsScreen(
                conectaSystemDB: conectaSystemDB,
              ),
            );
          default:
            return null;
        }
      },
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}
