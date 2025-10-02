
import 'package:flutter/material.dart';

class CustomTable extends StatelessWidget {
  final List<TableRow> rows;
  final List<TableRow>? footerRows;
  final bool showBorder;
  final String? caption;

  const CustomTable({
    super.key,
    required this.rows,
    this.footerRows,
    this.showBorder = true,
    this.caption,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (caption != null)
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: Text(
              caption!,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey),
            ),
          ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: showBorder
                ? TableBorder.symmetric(
                    inside: const BorderSide(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                  )
                : null,
            children: [
              ...rows,
              if (footerRows != null) ...footerRows!,
            ],
          ),
        ),
      ],
    );
  }
}

class CustomTableHeader extends StatelessWidget {
  final List<Widget> children;

  const CustomTableHeader({super.key, required this.children});

  @override
  TableRow build(BuildContext context) {
    return TableRow(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      children: children
          .map(
            (child) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
              child: DefaultTextStyle(
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w600),
                child: child,
              ),
            ),
          )
          .toList(),
    );
  }
}

class CustomTableRow extends StatelessWidget {
  final List<Widget> children;
  final bool selected;
  final VoidCallback? onTap;

  const CustomTableRow({
    super.key,
    required this.children,
    this.selected = false,
    this.onTap,
  });

  @override
  TableRow build(BuildContext context) {
    return TableRow(
      children: children
          .map(
            (child) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
              child: child,
            ),
          )
          .toList(),
    );
  }
}

class CustomTableFooter extends StatelessWidget {
  final List<Widget> children;

  const CustomTableFooter({super.key, required this.children});

  @override
  TableRow build(BuildContext context) {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: const Border(
          top: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      children: children
          .map(
            (child) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
              child: DefaultTextStyle(
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w500),
                child: child,
              ),
            ),
          )
          .toList(),
    );
  }
}

class CustomTableCell extends StatelessWidget {
  final Widget child;
  final TextAlign align;

  const CustomTableCell({
    super.key,
    required this.child,
    this.align = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: align == TextAlign.left
          ? Alignment.centerLeft
          : align == TextAlign.right
              ? Alignment.centerRight
              : Alignment.center,
      child: child,
    );
  }
}
