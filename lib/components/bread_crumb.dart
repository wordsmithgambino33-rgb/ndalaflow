
import 'package:flutter/material.dart';

class CustomBreadcrumb extends StatelessWidget {
  final Widget child;

  const CustomBreadcrumb({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'breadcrumb',
      child: child,
    );
  }
}

class CustomBreadcrumbList extends StatelessWidget {
  final List<Widget> children;

  const CustomBreadcrumbList({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children.map((child) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3), // gap-1.5 equivalent
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: 14, // text-sm
                color: colorScheme.onSurfaceVariant, // muted-foreground
              ),
              child: child,
            ),
          )).toList(),
    );
  }
}

class CustomBreadcrumbItem extends StatelessWidget {
  final Widget child;

  const CustomBreadcrumbItem({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [child],
    );
  }
}

class CustomBreadcrumbLink extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;

  const CustomBreadcrumbLink({
    super.key,
    this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: DefaultTextStyle(
        style: TextStyle(
          color: colorScheme.onSurfaceVariant, // initial muted
        ),
        child: child,
      ),
    );
  }
}

class CustomBreadcrumbPage extends StatelessWidget {
  final Widget child;

  const CustomBreadcrumbPage({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Semantics(
      link: true,
      enabled: false,
      label: 'Current page',
      child: DefaultTextStyle(
        style: TextStyle(
          color: colorScheme.onSurface, // text-foreground
          fontWeight: FontWeight.normal,
        ),
        child: child,
      ),
    );
  }
}

class CustomBreadcrumbSeparator extends StatelessWidget {
  final Widget? child;

  const CustomBreadcrumbSeparator({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Semantics(
      excludeSemantics: true,
      child: Icon(
        Icons.chevron_right, // ChevronRight equivalent
        size: 14, // size-3.5
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class CustomBreadcrumbEllipsis extends StatelessWidget {
  const CustomBreadcrumbEllipsis({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      excludeSemantics: true,
      label: 'More',
      child: Icon(
        Icons.more_horiz, // MoreHorizontal equivalent
        size: 16, // size-4
      ),
    );
  }
}