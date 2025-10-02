
import 'package:flutter/material.dart';

/// Pagination root container
class Pagination extends StatelessWidget {
  final List<int> pages;
  final int currentPage;
  final Function(int) onPageChanged;
  final bool showPreviousNext;

  const Pagination({
    Key? key,
    required this.pages,
    required this.currentPage,
    required this.onPageChanged,
    this.showPreviousNext = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: _buildPaginationItems(context),
      ),
    );
  }

  List<Widget> _buildPaginationItems(BuildContext context) {
    List<Widget> items = [];

    if (showPreviousNext) {
      items.add(PaginationPrevious(
        onPressed: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
      ));
    }

    for (var i = 0; i < pages.length; i++) {
      final page = pages[i];
      // Add ellipsis if there is a gap
      if (i > 0 && page - pages[i - 1] > 1) {
        items.add(const PaginationEllipsis());
      }

      items.add(PaginationLink(
        page: page,
        isActive: page == currentPage,
        onPressed: () => onPageChanged(page),
      ));
    }

    if (showPreviousNext) {
      items.add(PaginationNext(
        onPressed: currentPage < pages.last ? () => onPageChanged(currentPage + 1) : null,
      ));
    }

    return items;
  }
}

/// Pagination link button
class PaginationLink extends StatelessWidget {
  final int page;
  final bool isActive;
  final VoidCallback onPressed;

  const PaginationLink({
    Key? key,
    required this.page,
    this.isActive = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: isActive ? Colors.white : Colors.transparent,
        onPrimary: isActive ? Colors.blue : Colors.black87,
        side: BorderSide(color: isActive ? Colors.blue : Colors.grey.shade300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        elevation: 0,
      ),
      onPressed: onPressed,
      child: Text(page.toString()),
    );
  }
}

/// Previous button
class PaginationPrevious extends StatelessWidget {
  final VoidCallback? onPressed;

  const PaginationPrevious({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.chevron_left),
      label: const Text("Previous"),
    );
  }
}

/// Next button
class PaginationNext extends StatelessWidget {
  final VoidCallback? onPressed;

  const PaginationNext({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      label: const Text("Next"),
      icon: const Icon(Icons.chevron_right),
    );
  }
}

/// Ellipsis for skipped pages
class PaginationEllipsis extends StatelessWidget {
  const PaginationEllipsis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 32,
      child: Center(
        child: Text("…", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
