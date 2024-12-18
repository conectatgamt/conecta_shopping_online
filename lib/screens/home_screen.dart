import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'products_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String _storeName = "Doceria Jussara Gourmet";
  final String _storeDescription = "Loja de Doces";

  void _logout() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _navigateToProducts() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProductsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Conecta Shopping Online"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Lojas Disponíveis",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                onTap: _navigateToProducts,
                borderRadius: BorderRadius.circular(10),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                      child: Container(
                        height: 200, // Aumentado a altura
                        width: double.infinity,
                        padding: const EdgeInsets.all(16), // Adicionado padding
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain, // Alterado para contain
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        _storeName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(_storeDescription),
                      trailing: const Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}