
import 'package:flutter/material.dart';

enum Screen { dashboard, transactions, budget, reports, goals, checkout }

class BottomNavigation extends StatelessWidget {
  final Screen currentScreen;
  final Function(Screen) onNavigate;

  const BottomNavigation({
    Key? key,
    required this.currentScreen,
    required this.onNavigate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navItems = [
      {'id': Screen.dashboard, 'icon': Icons.home, 'label': 'Home'},
      {'id': Screen.transactions, 'icon': Icons.credit_card, 'label': 'Transactions'},
      {'id': Screen.budget, 'icon': Icons.pie_chart, 'label': 'Budget'},
      {'id': Screen.reports, 'icon': Icons.trending_up, 'label': 'Reports'},
      {'id': Screen.goals, 'icon': Icons.flag, 'label': 'Goals'},
      {'id': Screen.checkout, 'icon': Icons.shopping_cart, 'label': 'Checkout'},
    ];

    return Container(
      margin: EdgeInsets.only(bottom: 0),
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: navItems.map((item) {
          final isActive = currentScreen == item['id'];
          return GestureDetector(
            onTap: () => onNavigate(item['id'] as Screen),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                gradient: isActive
                    ? LinearGradient(colors: [Colors.teal, Colors.blue])
                    : null,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item['icon'] as IconData,
                    size: 24,
                    color: isActive ? Colors.white : Colors.grey,
                  ),
                  SizedBox(height: 4),
                  Text(
                    item['label'] as String,
                    style: TextStyle(
                      fontSize: 10,
                      color: isActive ? Colors.white : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
