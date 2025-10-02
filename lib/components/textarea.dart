import 'package:flutter/material.dart';

class Textarea extends StatelessWidget {
  final TextEditingController? controller;
  final String? placeholder;
  final bool enabled;
  final int minLines;
  final int? maxLines;

  const Textarea({
    Key? key,
    this.controller,
    this.placeholder,
    this.enabled = true,
    this.minLines = 3,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      minLines: minLines,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: placeholder,
        filled: true,
        fillColor: Theme.of(context).colorScheme.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Theme.of(context).dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Theme.of(context).disabledColor),
        ),
      ),
    );
  }
}
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            color: Theme.of(context).disabledColor,
          ),
        ),
      ),
    );
  }
}
    );
  }
}
  }
}
```
