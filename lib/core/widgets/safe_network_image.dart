import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Reusable network image widget with Shimmer loading + error fallback.
/// Solves SocketException (S3/Cloudinary DNS failure) by providing errorBuilder & loadingBuilder.
class SafeNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;
  final Color shimmerBase;
  final Color shimmerHighlight;

  const SafeNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorWidget,
    this.borderRadius,
    this.shimmerBase = const Color(0xFF2A2A2A),
    this.shimmerHighlight = const Color(0xFF3D3D3D),
  });

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    if (url == null || url.trim().isEmpty) return _buildError();

    Widget image = Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildShimmer();
      },
      errorBuilder: (context, error, stackTrace) => _buildError(),
    );

    if (borderRadius != null) {
      image = ClipRRect(borderRadius: borderRadius!, child: image);
    }

    return SizedBox(width: width, height: height, child: image);
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: shimmerBase,
      highlightColor: shimmerHighlight,
      child: Container(width: width, height: height, color: shimmerBase),
    );
  }

  Widget _buildError() {
    return errorWidget ??
        Container(
          width: width,
          height: height,
          color: const Color(0xFF1E1E1E),
          child: const Icon(
            Icons.broken_image_outlined,
            color: Color(0xFF888888),
            size: 28,
          ),
        );
  }
}

/// Circular avatar widget with Shimmer loading + error fallback.
/// Replaces: CircleAvatar(backgroundImage: NetworkImage(...))
class SafeNetworkAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final Widget? errorWidget;
  final Color shimmerBase;
  final Color shimmerHighlight;

  const SafeNetworkAvatar({
    super.key,
    required this.imageUrl,
    this.radius = 24,
    this.errorWidget,
    this.shimmerBase = const Color(0xFF2A2A2A),
    this.shimmerHighlight = const Color(0xFF3D3D3D),
  });

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    final size = radius * 2;
    if (url == null || url.trim().isEmpty) return _buildError(size);

    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: Image.network(
          url,
          width: size,
          height: size,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Shimmer.fromColors(
              baseColor: shimmerBase,
              highlightColor: shimmerHighlight,
              child: Container(width: size, height: size, color: shimmerBase),
            );
          },
          errorBuilder: (context, error, stackTrace) => _buildError(size),
        ),
      ),
    );
  }

  Widget _buildError(double size) {
    return errorWidget ??
        CircleAvatar(
          radius: radius,
          backgroundColor: const Color(0xFF2A2A2A),
          child: Icon(
            Icons.person_rounded,
            color: const Color(0xFF888888),
            size: radius * 0.9,
          ),
        );
  }
}
