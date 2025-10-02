
import 'package:flutter/material.dart';

// ========================
// Sidebar State Provider
// ========================
class SidebarProvider extends StatefulWidget {
  final Widget child;
  final bool defaultOpen;

  const SidebarProvider({super.key, required this.child, this.defaultOpen = true});

  @override
  State<SidebarProvider> createState() => _SidebarProviderState();

  static _SidebarProviderState of(BuildContext context) {
    final _SidebarProviderState? result =
        context.findAncestorStateOfType<_SidebarProviderState>();
    if (result == null) throw Exception("SidebarProvider not found in context");
    return result;
  }
}

class _SidebarProviderState extends State<SidebarProvider> {
  bool open = true;
  bool openMobile = false;

  @override
  void initState() {
    super.initState();
    open = widget.defaultOpen;
  }

  void toggleSidebar() {
    setState(() {
      if (isMobile(context)) {
        openMobile = !openMobile;
      } else {
        open = !open;
      }
    });
  }

  bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 768; // same as md breakpoint

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

// ========================
// Sidebar Widget
// ========================
class Sidebar extends StatelessWidget {
  final Widget? child;
  final double width;
  final double widthIcon;
  final double widthMobile;
  final String side; // left or right
  final String variant; // sidebar, floating, inset
  final String collapsible; // offcanvas, icon, none

  const Sidebar({
    super.key,
    this.child,
    this.width = 250,
    this.widthIcon = 50,
    this.widthMobile = 280,
    this.side = 'left',
    this.variant = 'sidebar',
    this.collapsible = 'offcanvas',
  });

  @override
  Widget build(BuildContext context) {
    final provider = SidebarProvider.of(context);
    final isMobile = provider.isMobile(context);
    final bool open = provider.open;
    final bool openMobile = provider.openMobile;

    if (collapsible == "none") {
      return Container(
        width: width,
        color: Colors.grey[900],
        child: child,
      );
    }

    if (isMobile) {
      // Mobile overlay
      return openMobile
          ? Positioned(
              top: 0,
              bottom: 0,
              left: side == 'left' ? 0 : null,
              right: side == 'right' ? 0 : null,
              child: Container(
                width: widthMobile,
                color: Colors.grey[900],
                child: child,
              ),
            )
          : SizedBox.shrink();
    }

    // Desktop sidebar
    double sidebarWidth;
    if (collapsible == "icon") {
      sidebarWidth = open ? width : widthIcon;
    } else {
      sidebarWidth = open ? width : 0;
    }

    return Row(
      children: [
        Container(
          width: sidebarWidth,
          height: MediaQuery.of(context).size.height,
          color: Colors.grey[900],
          child: child,
        ),
        Expanded(child: SizedBox()), // main content placeholder
      ],
    );
  }
}

// ========================
// Sidebar Trigger
// ========================
class SidebarTrigger extends StatelessWidget {
  const SidebarTrigger({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = SidebarProvider.of(context);
    return IconButton(
      icon: Icon(Icons.menu),
      onPressed: provider.toggleSidebar,
      tooltip: 'Toggle Sidebar',
    );
  }
}

// ========================
// Sidebar Header
// ========================
class SidebarHeader extends StatelessWidget {
  final Widget? child;
  const SidebarHeader({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: child,
    );
  }
}

// ========================
// Sidebar Footer
// ========================
class SidebarFooter extends StatelessWidget {
  final Widget? child;
  const SidebarFooter({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: child,
    );
  }
}

// ========================
// Sidebar Input
// ========================
class SidebarInput extends StatelessWidget {
  final TextEditingController? controller;
  const SidebarInput({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Search...',
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }
}

// ========================
// Sidebar Separator
// ========================
class SidebarSeparator extends StatelessWidget {
  const SidebarSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(color: Colors.grey[700], height: 1);
  }
}

// ========================
// Sidebar Menu Button
// ========================
class SidebarMenuButton extends StatelessWidget {
  final Widget? child;
  final bool isActive;
  final String tooltip;
  final VoidCallback? onPressed;

  const SidebarMenuButton({
    super.key,
    this.child,
    this.isActive = false,
    this.tooltip = '',
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: isActive ? Colors.blueGrey[700] : Colors.transparent,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        ),
        child: child,
      ),
    );
  }
}

// ========================
// Sidebar Group
// ========================
class SidebarGroup extends StatelessWidget {
  final Widget? child;
  const SidebarGroup({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: child,
    );
  }
}

// ========================
// Sidebar Menu Sub
// ========================
class SidebarMenuSub extends StatelessWidget {
  final Widget? child;
  const SidebarMenuSub({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16),
      child: child,
    );
  }
}
