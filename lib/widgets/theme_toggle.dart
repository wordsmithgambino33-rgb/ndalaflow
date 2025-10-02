
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart'; 

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    return GestureDetector(
      onTap: () => themeProvider.toggleTheme(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isDark ? 1 : 0,
              child: Transform.rotate(
                angle: isDark ? 0 : 3.14, // rotate like React motion
                child: const Icon(
                  Icons.nights_stay, // Moon icon
                  color: Colors.orange,
                  size: 24,
                ),
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isDark ? 0 : 1,
              child: Transform.rotate(
                angle: isDark ? 3.14 : 0,
                child: const Icon(
                  Icons.wb_sunny, // Sun icon
                  color: Colors.orange,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
