import 'package:flutter/material.dart';

class Sliverheader extends SliverPersistentHeaderDelegate{
  final Widget child;
  final double maxheight;
  final double minheight;
  const Sliverheader({required this.child, required this.maxheight, required this.minheight});
  
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => maxheight;

  @override
  // TODO: implement minExtent
  double get minExtent => minheight;

  @override
  bool shouldRebuild(covariant Sliverheader oldDelegate) {
     return oldDelegate.child != child ||
         oldDelegate.maxheight != maxheight ||
         oldDelegate.minheight != minheight;
  }
}