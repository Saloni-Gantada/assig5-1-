import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Cart(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Cart',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: const ProductListPage(),
      ),
    );
  }
}

class Product {
  final String id;
  final String name;
  final String image;
  final double price;
  bool isInCart;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    this.isInCart = false,
  });
}

final List<Product> products = [
  Product(
    id: 'p1',
    name: 'Oval Mirror',
    image:
        'https://images.pexels.com/photos/1528975/pexels-photo-1528975.jpeg?auto=compress&cs=tinysrgb&w=600',
    price: 120,
  ),
  Product(
    id: 'p2',
    name: 'Classy Black Chair',
    image:
        'https://images.pexels.com/photos/2762247/pexels-photo-2762247.jpeg?auto=compress&cs=tinysrgb&w=600',
    price: 200,
  ),
  Product(
    id: 'p3',
    name: 'Aesthetic coffee mug',
    image:
        'https://images.pexels.com/photos/19716402/pexels-photo-19716402/free-photo-of-coffee-in-mug-at-dawn.jpeg?auto=compress&cs=tinysrgb&w=600',
    price: 45,
  ),
  Product(
    id: 'p4',
    name: 'Leather sling bag',
    image:
        'https://images.pexels.com/photos/1152077/pexels-photo-1152077.jpeg?auto=compress&cs=tinysrgb&w=600',
    price: 70,
  ),
  Product(
    id: 'p5',
    name: 'Cozy winter slippers ',
    image:
        'https://images.pexels.com/photos/1444417/pexels-photo-1444417.jpeg?auto=compress&cs=tinysrgb&w=600',
    price: 14,
  ),
  Product(
    id: 'p6',
    name: ' Set of 3 Potted Plants',
    image:
        'https://images.pexels.com/photos/776656/pexels-photo-776656.jpeg?auto=compress&cs=tinysrgb&w=600',
    price: 25,
  ),
  Product(
    id: 'p7',
    name: 'Green Dress',
    image:
        'https://images.pexels.com/photos/985635/pexels-photo-985635.jpeg?auto=compress&cs=tinysrgb&w=600',
    price: 200,
  ),
  Product(
    id: 'p8',
    name: 'Christmas Delight cookies',
    image:
        'https://images.pexels.com/photos/6102150/pexels-photo-6102150.jpeg?auto=compress&cs=tinysrgb&w=600',
    price: 15,
  ),
  Product(
    id: 'p9',
    name: 'Traditional Kettle',
    image:
        'https://images.pexels.com/photos/1001805/pexels-photo-1001805.jpeg?auto=compress&cs=tinysrgb&w=600',
    price: 100,
  ),
  Product(
    id: 'p10',
    name: 'homemade soaps',
    image:
        'https://images.pexels.com/photos/773252/pexels-photo-773252.jpeg?auto=compress&cs=tinysrgb&w=600',
    price: 18,
  ),
];

class Cart extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => _items;

  double get totalPrice => _items.fold(0, (sum, item) => sum + item.price);

  void addProduct(Product product) {
    if (!_items.contains(product)) {
      product.isInCart = true;
      _items.add(product);
      notifyListeners();
    }
  }

  void removeProduct(Product product) {
    if (_items.contains(product)) {
      product.isInCart = false;
      _items.remove(product);
      notifyListeners();
    }
  }

  void clearCart() {
    for (var product in products) {
      product.isInCart = false;
    }
    _items.clear();
    notifyListeners();
  }

  double totalAmt() {
    double tot = 0;
    for (var product in products) {
      tot = tot + product.price;
    }
    return tot;
  }
}

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartPage()),
              );
            },
          ),
        ],
      ),
      body: Consumer<Cart>(
        builder: (context, cart, child) {
          return ListView.builder(
            padding: const EdgeInsets.all(30.0),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                leading: Image.network(product.image),
                title: Text(product.name),
                subtitle: Text('\$${product.price}'),
                trailing: IconButton(
                  icon: product.isInCart
                      ? const Icon(Icons.remove_circle)
                      : const Icon(Icons.add_circle),
                  onPressed: () {
                    if (product.isInCart) {
                      cart.removeProduct(product);
                    } else {
                      cart.addProduct(product);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Consumer<Cart>(
        builder: (context, cart, child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final product = cart.items[index];
                    return ListTile(
                      leading: Image.network(product.image),
                      title: Text(product.name),
                      subtitle: Text('\$${product.price}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle),
                        onPressed: () {
                          cart.removeProduct(product);
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total: \$${cart.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: const Text('BUY'),
            onPressed: () {
              Provider.of<Cart>(context, listen: false).clearCart();
            },
          ),
        ],
      ),
    );
  }
}
