import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:conecta_shopping_online/screens/login_screen.dart';
import 'package:conecta_shopping_online/screens/register_screen.dart';
import 'package:conecta_shopping_online/screens/home_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Conecta Shopping Online',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login', // Rota inicial é a tela de Login
      routes: {
        '/login': (context) => const LoginScreen(), // Tela de Login
        '/register': (context) => const RegisterScreen(), // Tela de Cadastro
        '/home': (context) => const HomeScreen(), // Tela Inicial (Home)
      },
    );
  }
}
