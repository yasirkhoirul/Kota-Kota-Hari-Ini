import 'package:flutter/material.dart';

class SmartSlideSwitcher extends StatefulWidget {
  final int currentIndex;
  final Widget child;

  const SmartSlideSwitcher({
    super.key,
    required this.currentIndex,
    required this.child,
  });

  @override
  State<SmartSlideSwitcher> createState() => _SmartSlideSwitcherState();
}

class _SmartSlideSwitcherState extends State<SmartSlideSwitcher> {
  int _prevIndex = 0;

  @override
  void didUpdateWidget(covariant SmartSlideSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Simpan index lama sebelum update
    if (oldWidget.currentIndex != widget.currentIndex) {
      _prevIndex = oldWidget.currentIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 0),
      // Custom Transition
      transitionBuilder: (Widget child, Animation<double> animation) {
        // Tentukan arah: Jika index baru > index lama = Geser dari Kanan
        // Jika index baru < index lama = Geser dari Kiri
        final bool isMovingRight = widget.currentIndex > _prevIndex;
        
        final Offset begin = isMovingRight 
            ? const Offset(1.0, 0.0)  // Dari Kanan
            : const Offset(-1.0, 0.0); // Dari Kiri

        // Trik: Jika ini adalah widget yang sedang "keluar" (secondary animation),
        // kita perlu membalik arahnya agar terlihat alami.
        // Namun AnimatedSwitcher agak tricky.
        
        // Alternatif Sederhana & Aman: Fade + Zoom atau Slide satu arah.
        // Jika ingin Slide sempurna kiri-kanan, gunakan package 'animations' 
        // atau kode di bawah ini:
        
        return SlideTransition(
          position: Tween<Offset>(
            begin: begin,
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
          child: child,
        );
      },
      child: KeyedSubtree(
        key: ValueKey(widget.currentIndex),
        child: widget.child,
      ),
    );
  }
}