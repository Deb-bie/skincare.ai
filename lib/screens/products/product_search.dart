import 'package:flutter/material.dart';

class ProductSearchDelegate extends SearchDelegate<String> {
  final List<dynamic> products;
  final Function(String) onQueryChanged;

  ProductSearchDelegate(this.products, this.onQueryChanged);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            onQueryChanged('');
          },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  List<dynamic> _filterProducts(String searchQuery) {
    if (searchQuery.isEmpty) {
      return products;
    }

    return products.where((p) {
      final name = p.name.toLowerCase();
      final brand = p.brandName.toLowerCase();
      final description = p.description.toString().toLowerCase();
      final query = searchQuery.toLowerCase();
      return name.contains(query) || brand.contains(query) || description.contains(query);
    }).toList();
  }

  @override
  Widget buildResults(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onQueryChanged(query);
    });

    final results = _filterProducts(query);

    if (query.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Type to search for products',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontFamily: 'Poppins',
                  letterSpacing: 1
              ),
            ),
          ],
        ),
      );
    }

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No products found for "$query"',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontFamily: 'Poppins',
                  letterSpacing: 1
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final product = results[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),

            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Image.network(
                product.image!,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.water_drop,
                    color: const Color(0xFF4FC3DC),
                  );
                }, ),
            ),

            title: Text(
              product.name,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  letterSpacing: 1
              ),
            ),

            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  product.brandName,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontFamily: 'Poppins',
                      letterSpacing: 1
                  ),
                ),

                const SizedBox(height: 4),

              ],
            ),
            onTap: () {
              close(context, product.name);
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}