
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomAvatar extends StatelessWidget {
  final double size;
  final Widget? child; // Typically CustomAvatarImage or Stack with image and fallback

  const CustomAvatar({
    super.key,
    this.size = 40.0,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: child,
      ),
    );
  }
}

class CustomAvatarImage extends StatelessWidget {
  final String src;
  final Widget? child; // Fallback widget if image fails

  const CustomAvatarImage({
    super.key,
    required this.src,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: src,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorWidget: (context, url, error) => child ?? const SizedBox.shrink(),
    );
  }
}

class CustomAvatarFallback extends StatelessWidget {
  final Widget child;

  const CustomAvatarFallback({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant, // bg-muted equivalent
        shape: BoxShape.circle,
      ),
      child: Center(
        child: child, // e.g., Text with initials
      ),
    );
  }
}