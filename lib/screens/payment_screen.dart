import 'package:flutter/material.dart';
import 'package:mercado_pago_mobile_checkout/mercado_pago_mobile_checkout.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/cart_item.dart';
import 'confirmation_screen.dart';

class PaymentScreen extends StatelessWidget {
  final List<CartItem> cartItems;

  const PaymentScreen({super.key, required this.cartItems});

  double calculateTotal() {
    return cartItems.fold(
      0.0,
          (total, item) => total + (item.price * item.quantity),
    );
  }

  Future<void> _payInApp(BuildContext context) async {
    const publicKey = "TEST-6fcee89a-0a9a-417b-b2b7-6c4a22de533b";
    const preferenceId = "1234567890abcdef";

    try {
      final result = await MercadoPagoMobileCheckout.startCheckout(
        publicKey,
        preferenceId,
      );

      if (result.status == "approved") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmationScreen(
              totalAmount: calculateTotal(),
              paymentMethod: "App Mercado Pago",
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Pagamento não concluído: ${result.status}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro no pagamento: $e")),
      );
    }
  }

  Future<void> _payOnSite(BuildContext context) async {
    const paymentUrl = "https://www.mercadopago.com.br";

    try {
      final Uri uri = Uri.parse(paymentUrl);
      if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        // Após abrir o site, considere o pagamento concluído
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmationScreen(
              totalAmount: calculateTotal(),
              paymentMethod: "Site Mercado Pago",
            ),
          ),
        );
      } else {
        throw 'Não foi possível abrir o link de pagamento.';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao abrir o site: $e")),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Total: R\$ ${calculateTotal().toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => _payInApp(context),
                  child: const Text('Pagar no App Mercado Pago'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => _payOnSite(context),
                  child: const Text('Pagar no Site do Mercado Pago'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
