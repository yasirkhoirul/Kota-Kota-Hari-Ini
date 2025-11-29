import 'dart:ui'; // Penting untuk ImageFilter

import 'package:flutter/material.dart';
class FrostedGlassScreen extends StatelessWidget {
  const FrostedGlassScreen({super.key, required this.width, required this.height});
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background - Ini akan menjadi konten yang diburamkan
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://picsum.photos/id/1084/500/800'), // Ganti dengan gambar latar belakang Anda
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                boxShadow: [
                 
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 15.0, // Tingkat blur horizontal
                    sigmaY: 15.0, // Tingkat blur vertikal
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
                        width: 1.5,
                        color: Colors.white.withAlpha(210), // Border tipis untuk efek kaca
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Efek Kaca Buram',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}