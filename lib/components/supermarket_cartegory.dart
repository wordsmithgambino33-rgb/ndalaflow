import 'package:flutter/material.dart';

class SupermarketCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final String? logoText; // optional placeholder
  final String? logoAsset; // path to image asset (new)
  final String description;

  SupermarketCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.logoText,
    this.logoAsset,
    required this.description,
  });
}

class SupermarketCategories extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelect;

  const SupermarketCategories({
    Key? key,
    required this.selectedCategory,
    required this.onCategorySelect,
  }) : super(key: key);

  List<SupermarketCategory> get _items => [
        SupermarketCategory(
          id: 'chipiku',
          name: 'Chipiku Plus',
          icon: Icons.shopping_cart,
          color: Colors.red,
          logoAsset: 'assets/images/chipiku.png',
          description: "Malawi's leading supermarket chain",
        ),
        SupermarketCategory(
          id: 'ekhaya',
          name: 'Ekhaya',
          icon: Icons.home,
          color: Colors.blue,
          logoAsset: 'assets/images/ekhaya.png',
          description: 'Your neighborhood store',
        ),
        SupermarketCategory(
          id: 'sana',
          name: 'Sana',
          icon: Icons.store,
          color: Colors.green,
          // Sana logo (save attachment as assets/images/sana.png)
          logoAsset: 'assets/images/sana.png',
          description: 'Quality products, great prices',
        ),
        SupermarketCategory(
          id: 'game',
          name: 'Game Stores',
          icon: Icons.inventory_2,
          color: Colors.purple,
          logoAsset: 'assets/images/game.png',
          description: 'Electronics & lifestyle',
        ),
        SupermarketCategory(
          id: 'pep',
          name: 'Pep Stores',
          icon: Icons.storefront,
          color: Colors.orange,
          // Use provided Pep logo (save it as assets/images/pep.png)
          logoAsset: 'assets/images/pep.png',
          description: 'Fashion & value retail',
        ),
        SupermarketCategory(id: 'other', name: 'Other', icon: Icons.more_horiz, color: Colors.grey, logoText: null, description: 'Insurance, utilities & other expenses'),
      ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: _items.map((item) {
        final selected = selectedCategory == item.id;
        return GestureDetector(
          onTap: () => onCategorySelect(item.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: selected ? Theme.of(context).colorScheme.primary.withOpacity(0.08) : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: selected ? Theme.of(context).colorScheme.primary : Theme.of(context).dividerColor),
              boxShadow: selected ? [BoxShadow(color: Theme.of(context).colorScheme.primary.withOpacity(0.08), blurRadius: 8)] : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo area: prefer asset image, then logoText, then icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(color: item.logoAsset == null ? item.color : Colors.transparent, borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: item.logoAsset != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              item.logoAsset!,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // If asset missing or fails, fallback to previous behavior
                                if (item.logoText != null && item.logoText!.isNotEmpty) {
                                  return Text(item.logoText!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
                                }
                                return Icon(item.icon, color: Colors.white);
                              },
                            ),
                          )
                        : (item.logoText != null && item.logoText!.isNotEmpty
                            ? Text(item.logoText!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                            : Icon(item.icon, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 8),
                Text(item.name, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(item.description, style: const TextStyle(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}