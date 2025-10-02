
import 'package:flutter/material.dart';

/// Navigation Menu Root
class NavigationMenu extends StatefulWidget {
  final List<NavigationMenuItem> items;

  const NavigationMenu({Key? key, required this.items}) : super(key: key);

  @override
  _NavigationMenuState createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int? openIndex;

  void toggleMenu(int index) {
    setState(() {
      openIndex = openIndex == index ? null : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        widget.items.length,
        (index) {
          final item = widget.items[index];
          final isOpen = openIndex == index;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => toggleMenu(index),
                child: Row(
                  children: [
                    item.trigger,
                    const SizedBox(width: 4),
                    AnimatedRotation(
                      turns: isOpen ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: const Icon(Icons.keyboard_arrow_down, size: 16),
                    ),
                  ],
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isOpen
                    ? Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 150),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: item.content,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Each item in the menu
class NavigationMenuItem {
  final Widget trigger;
  final List<Widget> content;

  NavigationMenuItem({required this.trigger, required this.content});
}

/// NavigationMenu Link (inside content)
class NavigationMenuLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const NavigationMenuLink({Key? key, required this.text, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      hoverColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ),
    );
  }
}

/// NavigationMenu Indicator (like arrow for open menu)
class NavigationMenuIndicator extends StatelessWidget {
  const NavigationMenuIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 45 * 3.1416 / 180,
      child: Container(
        width: 8,
        height: 8,
        color: Theme.of(context).dividerColor,
      ),
    );
  }
}
