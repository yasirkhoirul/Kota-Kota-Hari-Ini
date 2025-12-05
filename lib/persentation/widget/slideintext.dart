import 'package:flutter/material.dart';

class SlideInText extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double delay; // Jeda sebelum mulai (opsional)

  const SlideInText({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 900),
    this.delay = 0,
  });

  @override
  State<SlideInText> createState() => _SlideInTextState();
}

class _SlideInTextState extends State<SlideInText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    // Fade dari 0 ke 1
    _opacityAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Slide dari Bawah sedikit (0.2) ke Posisi Asli (0.0)
    // Offset(0, 0.5) artinya turun 50% dari tinggi widget.
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart));

    // Jalankan animasi setelah delay (jika ada)
    Future.delayed(Duration(milliseconds: (widget.delay * 1000).toInt()), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnim,
      child: SlideTransition(position: _slideAnim, child: widget.child),
    );
  }
}
