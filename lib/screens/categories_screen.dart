import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../store_provider.dart';
import 'category_products_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  static String getCategoryImage(String category) {
    switch (category.toLowerCase()) {
      case 'mobile':
        return 'https://raw.githubusercontent.com/Esam-Ahmed/electronics-api/main/images/phones.jpg';
      case 'watch':
        return 'https://raw.githubusercontent.com/Esam-Ahmed/electronics-api/main/images/watches.jpg';
      case 'audio':
        return 'https://raw.githubusercontent.com/Esam-Ahmed/electronics-api/main/images/audio.jpg';
      case 'tablet':
        return 'https://raw.githubusercontent.com/Esam-Ahmed/electronics-api/main/images/tablet.jpg';
      case 'laptop':
        return 'https://raw.githubusercontent.com/Esam-Ahmed/electronics-api/main/images/laptops.jpg';
      case 'gaming':
        return 'https://raw.githubusercontent.com/Esam-Ahmed/electronics-api/main/images/gaming.jpg';
      case 'camera':
        return 'https://raw.githubusercontent.com/Esam-Ahmed/electronics-api/main/images/camera.jpg';
      case 'charger':
        return 'https://raw.githubusercontent.com/Esam-Ahmed/electronics-api/main/images/charger.jpg';
      case 'accessories':
        return 'https://raw.githubusercontent.com/Esam-Ahmed/electronics-api/main/images/accessories.jpg';
      default:
        return 'https://raw.githubusercontent.com/Esam-Ahmed/electronics-api/main/images/default.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('التصنيفات'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: store.categories.isEmpty
          ? const Center(
              child: Text(
                'لا توجد تصنيفات',
                style: TextStyle(fontSize: 18),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(15),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: store.categories.length,
              itemBuilder: (ctx, i) {
                final cat = store.categories[i];

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryProductsScreen(
                          categoryTitle: cat,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(15),
                            ),
                            child: Image.network(
                              getCategoryImage(cat),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (ctx, err, stack) => const Icon(
                                Icons.category,
                                size: 40,
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.indigo.withOpacity(0.05),
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(15),
                            ),
                          ),
                          child: Text(
                            cat.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
