import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Heroes extends StatelessWidget {
  final String imageUrl;
  final int id;
  const Heroes(this.id, {super.key, required this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "kedetail$id",
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        errorWidget: (context, url, error) => Icon(Icons.error),
        placeholder: (context, url) =>
            Center(child: CircularProgressIndicator()),
        fit: BoxFit.cover,
      ),
    );
  }
}
