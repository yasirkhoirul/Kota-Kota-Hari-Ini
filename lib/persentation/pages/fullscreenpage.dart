import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FullscreenImagePage extends StatelessWidget {
  final String imageUrl;
  final String tag;

  const FullscreenImagePage({super.key, required this.imageUrl, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: Hero(
            tag: tag,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
    );
  }
}
