import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsScreen extends StatefulWidget {
  final FirebaseFirestore conectaSystemDB;

  const ProductsScreen({super.key, required this.conectaSystemDB});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  // Mapa para armazenar a quantidade de cada produto
  Map<String, int> productQuantities = {};

  // Função para adicionar quantidade
  void _incrementQuantity(String productId) {
    setState(() {
      productQuantities[productId] = (productQuantities[productId] ?? 0) + 1;
    });
  }

  // Função para remover quantidade
  void _decrementQuantity(String productId) {
    setState(() {
      if (productQuantities[productId] != null && productQuantities[productId]! > 0) {
        productQuantities[productId] = productQuantities[productId]! - 1;
      }
    });
  }

  // Função para calcular o valor total
  double _calculateTotal(List<QueryDocumentSnapshot> products) {
    double total = 0.0;

    for (var product in products) {
      final productId = product.id;

      // Certifica que o preço é um double válido
      final price = double.tryParse(product['sellingPrice'].toString()) ?? 0.0;
      final quantity = productQuantities[productId] ?? 0;

      total += price * quantity;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loja da Doceria Jussara Gourmet'),
      ),
      body: StreamBuilder(
        stream: widget.conectaSystemDB.collection('products').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar os produtos.'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data!.docs;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final productId = product.id;

                    // Quantidade atual do produto
                    final quantity = productQuantities[productId] ?? 0;

                    return ListTile(
                      leading: Image.network(
                        product['imageUrl'] ?? '',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported),
                      ),
                      title: Text(product['name'] ?? 'Produto'),
                      subtitle: Text(
                          'R\$ ${double.tryParse(product['sellingPrice'].toString())?.toStringAsFixed(2) ?? '0.00'}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () => _decrementQuantity(productId),
                          ),
                          Text('$quantity', style: const TextStyle(fontSize: 16)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => _incrementQuantity(productId),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Rodapé com o valor total
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'R\$ ${_calculateTotal(products).toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
