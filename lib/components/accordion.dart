
import 'package:flutter/material.dart';

class Accordion extends StatefulWidget {
  final List<AccordionItem> items;

  const Accordion({super.key, required this.items});

  @override
  State<Accordion> createState() => _AccordionState();
}

class AccordionItem {
  final String title;
  final Widget content;
  bool isExpanded;

  AccordionItem({
    required this.title,
    required this.content,
    this.isExpanded = false,
  });
}

class _AccordionState extends State<Accordion> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.items.map((item) {
        return AccordionTile(
          item: item,
          onToggle: () {
            setState(() {
              item.isExpanded = !item.isExpanded;
            });
          },
        );
      }).toList(),
    );
  }
}

class AccordionTile extends StatelessWidget {
  final AccordionItem item;
  final VoidCallback onToggle;

  const AccordionTile({
    super.key,
    required this.item,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // AccordionTrigger
        InkWell(
          onTap: onToggle,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: item.isExpanded ? 0.5 : 0.0, // rotate 180° if open
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),

        // AccordionContent
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            alignment: Alignment.centerLeft,
            child: item.content,
          ),
          crossFadeState: item.isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }
}
