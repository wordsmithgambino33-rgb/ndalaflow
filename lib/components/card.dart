import 'package:flutter/material.dart';

/// A reusable Card widget
class AppCard extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const AppCard({
    Key? key,
    this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Padding(
        padding: padding!,
        child: child,
      ),
    );
  }
}

class CardHeader extends StatelessWidget {
  final String? title;
  final String? description;
  final Widget? action;

  const CardHeader({Key? key, this.title, this.description, this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) Text(title!, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              if (description != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(description!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                ),
            ],
          ),
        ),
        if (action != null) action!,
      ],
    );
  }
}

class CardContent extends StatelessWidget {
  final Widget child;
  const CardContent({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 12.0), child: child);
}

/// Card Footer
class CardFooter extends StatelessWidget {
  final Widget child;

  const CardFooter({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12.0),
      child: child,
    );
  }
}
      child: child,
    );
  }
}

/// Card Footer
class CardFooter extends StatelessWidget {
  final Widget child;

  const CardFooter({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12.0),
      child: child,
    );
  }
}
  }
}
```
