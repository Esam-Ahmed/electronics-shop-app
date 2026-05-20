import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product.dart';
import 'store_provider.dart';
import 'helpers.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late Product _product;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(_product.title),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: _product.id,
              child: Image.network(
                _product.imageUrl,
                width: double.infinity,
                height: 300,
                fit: BoxFit.contain,
                errorBuilder: (ctx, err, stack) =>
                    const Icon(Icons.broken_image, size: 100),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_product.price} \$',
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                      Chip(
                        label: Text(_product.category),
                        backgroundColor: Colors.indigo.withOpacity(0.1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    _product.title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "وصف المنتج:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _product.description,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final success = await store.addToCart(_product.id);
                            if (!success) {
                              showLoginDialog(context);
                              return;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('تمت الإضافة للسلة')),
                            );
                          },
                          icon: const Icon(Icons.add_shopping_cart),
                          label: const Text("إضافة للسلة"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      IconButton(
                        onPressed: () async {
                          final success = await store.toggleFav(_product.id);
                          if (!success) {
                            showLoginDialog(context);
                            return;
                          }
                          setState(() {
                            _product.isFavorite = !_product.isFavorite;
                          });
                        },
                        icon: Icon(
                          _product.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
