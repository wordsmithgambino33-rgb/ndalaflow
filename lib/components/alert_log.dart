import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final Widget trigger;
  final Widget content;

  const CustomAlertDialog({
    Key? key,
    required this.trigger,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () async {
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => content,
            );
          },
          child: trigger,
        );
      },
    );
  }
}

class CustomAlertDialogTrigger extends StatelessWidget {
  final String label;

  const CustomAlertDialogTrigger({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: null, child: Text(label));
  }
}

class CustomAlertDialogOverlay extends StatelessWidget {
  const CustomAlertDialogOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.black.withOpacity(0.5));
  }
}

class CustomAlertDialogContent extends StatelessWidget {
  final Widget child;
  const CustomAlertDialogContent({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(insetPadding: const EdgeInsets.all(16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), child: child);
  }
}

class CustomAlertDialogHeader extends StatelessWidget {
  final Widget child;
  const CustomAlertDialogHeader({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 12), child: child);
}

class CustomAlertDialogFooter extends StatelessWidget {
  final List<Widget> actions;
  const CustomAlertDialogFooter({Key? key, required this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(mainAxisAlignment: MainAxisAlignment.end, children: actions);
}

class CustomAlertDialogTitle extends StatelessWidget {
  final String title;
  const CustomAlertDialogTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) => Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600));
}

class CustomAlertDialogDescription extends StatelessWidget {
  final String description;
  const CustomAlertDialogDescription({Key? key, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) => Text(description, style: TextStyle(fontSize: 14, color: Colors.grey[700]));
}

class CustomAlertDialogAction extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const CustomAlertDialogAction({Key? key, required this.label, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(onPressed: onPressed, child: Text(label));
}

class CustomAlertDialogCancel extends StatelessWidget {
  final String label;
  const CustomAlertDialogCancel({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) => OutlinedButton(onPressed: () => Navigator.of(context).pop(), child: Text(label));
}
/// Title
class CustomAlertDialogTitle extends StatelessWidget {
  final String title;

  const CustomAlertDialogTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

/// Description
class CustomAlertDialogDescription extends StatelessWidget {
  final String description;

  const CustomAlertDialogDescription({Key? key, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey[700],
      ),
    );
  }
}

/// Action
class CustomAlertDialogAction extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CustomAlertDialogAction({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

/// Cancel
class CustomAlertDialogCancel extends StatelessWidget {
  final String label;

  const CustomAlertDialogCancel({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text(label),
    );
  }
}
}
  }
}
