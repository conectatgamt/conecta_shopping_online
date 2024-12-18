import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentScreen extends StatelessWidget {
  final List<CartItem> cartItems;

  const PaymentScreen({super.key, required this.cartItems});

  // Calcula o total do carrinho
  double calculateTotal() {
    return cartItems.fold(
      0.0,
          (total, item) => total + (item.price * item.quantity),
    );
  }

  // Processa o pagamento com o Mercado Pago
  Future<void> _processPayment(BuildContext context) async {
    try {
      // URL simulada para o checkout do Mercado Pago
      const paymentUrl = "https://www.mercadopago.com.br";

      // Abre o link no navegador ou aplicativo
      if (!await launchUrl(Uri.parse(paymentUrl),
          mode: LaunchMode.externalApplication)) {
        throw 'Não foi possível abrir o link de pagamento.';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro no pagamento: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagamento'),
        backgroundColor: Colors.red,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: Card(
              margin: const EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Resumo do Pedido',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return ListTile(
                            title: Text(item.name),
                            subtitle: Text(
                                '${item.quantity} x R\$ ${item.price.toStringAsFixed(2)}'),
                            trailing: Text(
                              'R\$ ${(item.price * item.quantity).toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'R\$ ${calculateTotal().toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              onPressed: () => _processPayment(context),
              child: const Text(
                'Pagar Agora',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
