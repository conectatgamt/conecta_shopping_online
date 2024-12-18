class CartItem {
  final String name;
  final double price;
  final String imageUrl;
  int quantity;
  final List<String> options; // Lista de opções selecionadas (se houver)

  CartItem({
    required this.name,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
    this.options = const [],
  });
}
