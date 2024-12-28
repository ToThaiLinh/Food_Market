import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class FoodImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;

  const FoodImageWidget({
    super.key,
    required this.imageUrl,
    this.width = 48,
    this.height = 48,
  });

  String _processImageUrl(String url) {
    // Remove any potential double extensions
    final cleanUrl = url.replaceAll('.jpg.jpg', '.jpg');

    // Ensure the URL is properly encoded
    return Uri.encodeFull(cleanUrl);
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      debugPrint('FoodImageWidget: Image URL is null or empty');
      return _buildPlaceholder();
    }

    final processedUrl = _processImageUrl(imageUrl!);
    debugPrint('FoodImageWidget: Processing URL: $processedUrl');

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: CachedNetworkImage(
          imageUrl: processedUrl,
          fit: BoxFit.cover,
          fadeInDuration: Duration.zero,
          placeholderFadeInDuration: Duration.zero,
          errorWidget: (context, url, error) {
            debugPrint('FoodImageWidget Error: $error for URL: $url');
            return _buildErrorWidget();
          },
          placeholder: (context, url) => _buildPlaceholder(),
          cacheManager: DefaultCacheManager(),
          imageBuilder: (context, imageProvider) {
            debugPrint('FoodImageWidget: Image loaded successfully');
            return Image(image: imageProvider, fit: BoxFit.cover);
          },
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Icon(
        Icons.image,
        color: Colors.grey[400],
        size: width * 0.5,
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.broken_image,
            color: Colors.grey[400],
            size: width * 0.5,
          ),
          Positioned(
            bottom: 2,
            child: Text(
              'Load failed',
              style: TextStyle(
                fontSize: 8,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}