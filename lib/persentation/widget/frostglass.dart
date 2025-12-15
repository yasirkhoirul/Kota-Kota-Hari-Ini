import 'dart:ui'; // Penting untuk ImageFilter

import 'package:flutter/material.dart';

class FrostedGlassScreen extends StatefulWidget {
  const FrostedGlassScreen({
    super.key,
    required this.width,
    required this.height,
    required this.child,
  });
  final double width;
  final double height;
  final Widget child;

  @override
  State<FrostedGlassScreen> createState() => _FrostedGlassScreenState();
}

class _FrostedGlassScreenState extends State<FrostedGlassScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _blurAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    ); // animasi bolak-balik

    _blurAnimation = Tween<double>(
      begin: 0,
      end: 15,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _controller.forward();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _blurAnimation,
      builder: (context, child) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: _blurAnimation.value, // Tingkat blur horizontal
                sigmaY: _blurAnimation.value, // Tingkat blur vertikal
              ),
              child: Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(50), // Warna dasar transparan
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withAlpha(70), // Gradient dari atas
                      Colors.white.withAlpha(80), // Gradient ke bawah
                    ],
                    begin: AlignmentDirectional.topStart,
                    end: AlignmentDirectional.bottomEnd,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    width: 1.5,
                    color: Colors.white.withAlpha(
                      210,
                    ), // Border tipis untuk efek kaca
                  ),
                ),
                child: widget.child,
              ),
            ),
          ),
        );
      },
    );
  }
}


class FrosGlassWrap extends StatefulWidget {
  const FrosGlassWrap({
    super.key,
    
    required this.child,
  });
  
  final Widget child;

  @override
  State<FrosGlassWrap> createState() => _FrosGlassWrapState();
}

class _FrosGlassWrapState extends State<FrosGlassWrap>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _blurAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    ); // animasi bolak-balik

    _blurAnimation = Tween<double>(
      begin: 0,
      end: 15,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _controller.forward();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _blurAnimation,
      builder: (context, child) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: _blurAnimation.value, // Tingkat blur horizontal
                sigmaY: _blurAnimation.value, // Tingkat blur vertikal
              ),
              child: Container(
                
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(50), // Warna dasar transparan
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withAlpha(70), // Gradient dari atas
                      Colors.white.withAlpha(80), // Gradient ke bawah
                    ],
                    begin: AlignmentDirectional.topStart,
                    end: AlignmentDirectional.bottomEnd,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    width: 0.5,
                    color: Colors.white.withAlpha(
                      210,
                    ), // Border tipis untuk efek kaca
                  ),
                ),
                child: widget.child,
              ),
            ),
          ),
        );
      },
    );
  }
}

