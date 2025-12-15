import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kota_kota_hari_ini/common/constant.dart';
import 'package:kota_kota_hari_ini/domain/entity/detail_bangunan_entity.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/detail_bangunan_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/pages/fullscreenpage.dart';
import 'package:kota_kota_hari_ini/persentation/widget/frostglass.dart';

class DetailBangunan extends StatefulWidget {
  final int idBangunan;
  final String imageBangunan;

  const DetailBangunan({
    required this.idBangunan,
    super.key,
    required this.imageBangunan,
  });

  @override
  State<DetailBangunan> createState() => _DetailBangunanState();
}

class _DetailBangunanState extends State<DetailBangunan> {
  @override
  void initState() {
    super.initState();
    // Memanggil data
    context.read<DetailBangunanCubit>().getBangunan(widget.idBangunan);
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil ukuran layar untuk responsivitas
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      
      backgroundColor: Colors.grey[50], // Warna background lebih terang & modern
      body: Stack(
        
        children: [
          Positioned(
                  right: 0,
                  left: 0,
                  bottom: 0,
                  top: 0,
                  child: CachedNetworkImage(
                    imageUrl: widget.imageBangunan,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
          CustomScrollView(
            physics: const BouncingScrollPhysics(), // Efek scroll iOS yang halus
            slivers: [
              // 1. Header Image yang Responsive
              
          
              // 2. Content Body berdasarkan State Bloc
              BlocBuilder<DetailBangunanCubit, DetailBangunanState>(
                builder: (context, state) {
                  if (state is DetailBangunanLoading) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
          
                  if (state is DetailBangunanError) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline,
                                size: 48, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(state.message,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey[600])),
                          ],
                        ),
                      ),
                    );
                  }
          
                  if (state is DetailBangunanLoaded) {
                    if (state.data.isEmpty) {
                      return const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: Text("Belum ada detail data")),
                      );
                    }
          
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return ItemRow(data: state.data[index]);
                          },
                          childCount: state.data.length,
                        ),
                      ),
                    );
                  }
          
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
              
              // Tambahan jarak di bawah agar tidak mentok
              const SliverToBoxAdapter(child: SizedBox(height: 30)),
            ],
          ),
        ],
      ),
    );
  }
}

class ItemRow extends StatelessWidget {
  final DetailBangunanEntity data;
  const ItemRow({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // 1. Cek Lebar Layar
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return InkWell(
      onTap: () => _showFullscreenDialog(context),
      child: FrosGlassWrap(
        // Kita kirim context ke helper method
        child: SizedBox(
          child: SingleChildScrollView(
            child: isDesktop 
                ? _buildDesktopLayout(context) 
                : _buildMobileLayout(context),
          ),
        ),
      ),
    );
  }

  // === TAMPILAN MOBILE (< 800) ===
  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          // Kirim Context ke sini
          child: _buildImage(context, height: 200, width: double.infinity),
        ),
        _buildDescriptionPadding(),
      ],
    );
  }

  // === TAMPILAN DESKTOP (>= 800) ===
  Widget _buildDesktopLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: SizedBox(
            width: 500,
            // Kirim Context ke sini
            child: _buildImage(
              context,
              height: 500, // Fixed height agar stabil
              width: 500
            ),
          ),
        ),
        _buildDescriptionPadding(),
      ],
    );
  }

  // === WIDGET GAMBAR (DENGAN CLICK & HERO) ===
  Widget _buildImage(BuildContext context, {required double height, required double width}) {
    // Bungkus dengan Material & InkWell agar bisa diklik dan ada efek ripple
    return Material(
      color: Colors.transparent,
      child: Hero(
        tag: data.imagePath, // Tag Hero untuk animasi terbang
        child: CachedNetworkImage(
          imageUrl: data.imagePath,
          fit: BoxFit.cover, 
          height: height,
          width: width,
          errorWidget: (context, url, error) => Container(
            height: height,
            width: width,
            color: Colors.grey[200],
            child: const Icon(Icons.broken_image, color: Colors.grey),
          ),
          placeholder: (context, url) => Container(
            height: height,
            width: width,
            color: Colors.grey[200],
            child: const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }

  // === LOGIC POPUP DIALOG ===
  void _showFullscreenDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black, // Background belakang hitam pekat
      builder: (context) {
        // Gunakan Dialog dengan insetPadding zero agar full screen
        return Dialog(
          backgroundColor: Colors.black, 
          insetPadding: EdgeInsets.zero, // Hilangkan margin bawaan dialog
          child: Stack(
            children: [
              // 1. SINGLE CHILD SCROLL VIEW (Agar bisa discroll dari atas sampai bawah)
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // A. GAMBAR DI PALING ATAS
                    // Kita beri SafeArea top: true agar tidak ketutup notch/status bar
                    SafeArea(
                      bottom: false, // Bawah tidak perlu safe area di sini
                      child: Hero(
                        tag: data.imagePath,
                        child: CachedNetworkImage(
                          imageUrl: data.imagePath,
                          // Gunakan fitWidth agar lebar penuh, tinggi menyesuaikan
                          fit: BoxFit.fitWidth, 
                          width: double.infinity,
                          placeholder: (context, url) => const SizedBox(
                            height: 300,
                            child: Center(
                              child: CircularProgressIndicator(color: Colors.white),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 300,
                            color: Colors.grey[900],
                            child: const Icon(Icons.broken_image, color: Colors.white, size: 50),
                          ),
                        ),
                      ),
                    ),

                    // B. TEKS DESKRIPSI DI BAWAHNYA
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        data.deskripsi,
                        style: const TextStyle(
                          color: Colors.white, // Teks putih di background hitam
                          fontSize: 16,
                          height: 1.6, // Jarak antar baris agar enak dibaca
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),

                    // Tambahan jarak di paling bawah agar teks terakhir tidak terlalu mepet layar
                    const SizedBox(height: 50), 
                  ],
                ),
              ),

              // 2. TOMBOL CLOSE (Floating di Pojok Kanan Atas)
              // Menggunakan SafeArea agar pas di bawah status bar
              Positioned(
                top: 10,
                right: 10,
                child: SafeArea(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5), // Background bulat transparan
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 30),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  // Widget Deskripsi
  Widget _buildDescriptionPadding() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.deskripsi,
            style: const TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 255, 255, 255),
              height: 1.6,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}