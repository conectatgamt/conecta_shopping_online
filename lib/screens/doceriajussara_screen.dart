import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_screen.dart'; // Tela do carrinho
import '../models/cart_item.dart'; // Modelo do item do carrinho

// Lista global para os itens do carrinho
final List<CartItem> globalCartItems = [];

class ProductsScreen extends StatefulWidget {
  final FirebaseFirestore conectaSystemDB;

  const ProductsScreen({super.key, required this.conectaSystemDB});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  Map<String, int> productQuantities = {};

  // Incrementa a quantidade do produto
  void _incrementQuantity(String productId) {
    setState(() {
      productQuantities[productId] = (productQuantities[productId] ?? 0) + 1;
    });
  }

  // Decrementa a quantidade do produto
  void _decrementQuantity(String productId) {
    setState(() {
      if (productQuantities[productId] != null && productQuantities[productId]! > 0) {
        productQuantities[productId] = productQuantities[productId]! - 1;
      }
    });
  }

  // Calcula o valor total
  double _calculateTotal(List<QueryDocumentSnapshot> products) {
    double total = 0.0;
    for (var product in products) {
      final productId = product.id;
      final price = double.tryParse(product['sellingPrice'].toString()) ?? 0.0;
      final quantity = productQuantities[productId] ?? 0;

      total += price * quantity;
    }
    return total;
  }

  // Adiciona produtos selecionados ao carrinho
  void _addToCart(List<QueryDocumentSnapshot> products) {
    globalCartItems.clear(); // Limpa o carrinho antes de adicionar os novos itens

    for (var product in products) {
      final productId = product.id;
      final quantity = productQuantities[productId] ?? 0;

      if (quantity > 0) {
        globalCartItems.add(CartItem(
          name: product['name'] ?? 'Produto',
          price: (double.tryParse(product['sellingPrice'].toString()) ?? 0.0),
          imageUrl: product['imageUrl'] ?? '',
          quantity: quantity,
          options: [], // Aqui pode ser ajustado para adicionar opções selecionadas
        ));
      }
    }

    // Navega para a tela do carrinho
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(cartItems: globalCartItems),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Destaques'),
        backgroundColor: Colors.red,
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
                child: GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final productId = product.id;
                    final quantity = productQuantities[productId] ?? 0;

                    return Card(
                      elevation: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Image.network(
                              product['imageUrl'] ?? '',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image_not_supported),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              product['name'] ?? 'Produto',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                                'R\$ ${double.tryParse(product['sellingPrice'].toString())?.toStringAsFixed(2) ?? '0.00'}'),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () => _decrementQuantity(productId),
                              ),
                              Text('$quantity'),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () => _incrementQuantity(productId),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Total e botão para o carrinho
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: R\$ ${_calculateTotal(products).toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () => _addToCart(products),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Ir para o Carrinho'),
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
