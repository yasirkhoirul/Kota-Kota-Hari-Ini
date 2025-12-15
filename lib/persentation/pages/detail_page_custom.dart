import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kota_kota_hari_ini/common/constant.dart';
import 'package:kota_kota_hari_ini/domain/entity/bangunan_entity.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/bangunan_kota_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/detail_kota_dart_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/widget/frostglass.dart';
import 'package:kota_kota_hari_ini/persentation/widget/slideintext.dart';

class DetailPageCustom extends StatefulWidget {
  final String id;
  const DetailPageCustom({super.key, required this.id});

  @override
  State<DetailPageCustom> createState() => _DetailPageCustomState();
}

class _DetailPageCustomState extends State<DetailPageCustom> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DetailKotaDartCubit>().onGetKota(widget.id);
      context.read<BangunanKotaCubit>().getBangunan(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. Ambil Lebar & Tinggi Layar
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 800; // Logic Responsive

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withAlpha(250),
                  Colors.black.withAlpha(40),
                  Colors.black.withAlpha(0),
                ],
                begin: AlignmentGeometry.bottomCenter,
                end: AlignmentGeometry.topCenter,
              ),
            ),
          ),
          BlocBuilder<DetailKotaDartCubit, DetailKotaDartState>(
            builder: (context, state) {
              if (state is DetailKotaDartLoaded) {
                return Positioned(
                  right: 0,
                  left: 0,
                  bottom: 0,
                  top: 0,
                  child: CachedNetworkImage(
                    imageUrl: state.data.imagePath.first,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
          BlocBuilder<DetailKotaDartCubit, DetailKotaDartState>(
            builder: (context, stateKota) {
              if (stateKota is DetailKotaDartLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (stateKota is DetailKotaDartError) {
                return Center(child: Text(stateKota.message));
              }

              if (stateKota is DetailKotaDartLoaded) {
                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // ------------------------------------------------
                    if (isDesktop) ...[
                      // ================= DESKTOP VIEW (SPLIT KIRI-KANAN) =================
                      SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(
                              32.0,
                            ), // Padding lebih besar di desktop
                            child: SizedBox(
                              width: 1500,
                              height: 830,
                              child: FrosGlassWrap(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 50,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center, // Rata atas
                                    children: [
                                      // KIRI: DESKRIPSI (Flexible agar bisa scroll jika panjang)
                                      Expanded(
                                        flex:
                                            1, // Mengambil 50% layar (atau bisa diatur misal 4)
                                        child: SlideInText(
                                          child: Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                spacing: 5,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Text(
                                                    "KOTA",
                                                    style:
                                                        GoogleFonts.robotoFlex(
                                                          color: Colors.white,
                                                          fontSize: 56,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                  ),
                                                  Text(
                                                    stateKota.data.namaKota,
                                                    style:
                                                        GoogleFonts.robotoFlex(
                                                          color: Colors.black,
                                                          fontSize: 56,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                  ),
                                                  LayoutBuilder(
                                                    builder: (context, constrainst) {
                                                      final double lebar =
                                                          constrainst.maxWidth *
                                                          0.5;
                                                      return Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                              right: lebar,
                                                            ),
                                                        child: Container(
                                                          height: 2,
                                                          width:
                                                              double.maxFinite,
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  15,
                                                                ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.location_on,
                                                        color: Color(
                                                          0xFFB7410E,
                                                        ),
                                                      ),
                                                      Text(
                                                        stateKota.data.lokasi,
                                                        style:
                                                            GoogleFonts.robotoFlex(
                                                              color: Color(
                                                                0xFFB7410E,
                                                              ),
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                  TeksDeskripsi(
                                                    namakota:
                                                        stateKota.data.namaKota,
                                                    deskiprpsi: stateKota
                                                        .data
                                                        .deskripsiPanjang,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 40), // Jarak tengah
                                      // KANAN: LIST BANGUNAN
                                      Expanded(
                                        flex: 1, // Mengambil 50% layar
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            BangunanListDesktop(
                                              kotaid: widget.id,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      // ================= MOBILE VIEW (STACK ATAS-BAWAH) =================
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 20),
                          child: FrosGlassWrap(
                            child: SizedBox(
                              height: 600,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    
                                    Text(
                                      stateKota.data.namaKota,
                                      style: GoogleFonts.robotoFlex(
                                        color: Colors.black,
                                        fontSize: 56,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    LayoutBuilder(
                                      builder: (context, constrainst) {
                                        final double lebar =
                                            constrainst.maxWidth * 0.5;
                                        return Container(
                                          height: 2,
                                          width: lebar,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                        );
                                      },
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: Color(0xFFB7410E),
                                        ),
                                        Text(
                                          stateKota.data.lokasi,
                                          style: GoogleFonts.robotoFlex(
                                            color: Color(0xFFB7410E),
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: SlideInText(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TeksDeskripsi(
                                            namakota: stateKota.data.namaKota,
                                            deskiprpsi:
                                                stateKota.data.deskripsiPanjang,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      BangunanListSliver(kotaid: widget.id),
                    ],

                    const SliverToBoxAdapter(child: SizedBox(height: 40)),
                  ],
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }
}

// --------------------------------------------------------------------------
// WIDGET KHUSUS DESKTOP (MENGGUNAKAN COLUMN BIASA, BUKAN SLIVER)
// --------------------------------------------------------------------------
class BangunanListDesktop extends StatelessWidget {
  final String kotaid;
  const BangunanListDesktop({super.key, required this.kotaid});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BangunanKotaCubit, BangunanKotaState>(
      builder: (context, state) {
        if (state is BangunanKotaLoading)
          return const Center(child: CircularProgressIndicator());
        if (state is BangunanKotaError) return Text(state.message);
        if (state is BangunanKotaLoaded) {
          if (state.data.isEmpty) return const Text("Belum ada data.");
          // Menggunakan Column agar bisa masuk di dalam Row -> Expanded
          return SizedBox(
            height: 800,
            child: ListView.builder(
              itemCount: state.data.length,
              itemBuilder: (context, index) =>
                  BangunanCardItem(bangunan: state.data[index], kotaid: kotaid),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// --------------------------------------------------------------------------
// WIDGET KHUSUS MOBILE (MENGGUNAKAN SLIVERLIST)
// --------------------------------------------------------------------------
class BangunanListSliver extends StatelessWidget {
  final String kotaid;
  const BangunanListSliver({super.key, required this.kotaid});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BangunanKotaCubit, BangunanKotaState>(
      builder: (context, state) {
        if (state is BangunanKotaLoading) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        if (state is BangunanKotaError) {
          return SliverToBoxAdapter(child: Center(child: Text(state.message)));
        }
        if (state is BangunanKotaLoaded) {
          if (state.data.isEmpty) {
            return const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Center(child: Text("Belum ada data.")),
              ),
            );
          }
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return BangunanCardItem(
                  bangunan: state.data[index],
                  kotaid: kotaid,
                );
              }, childCount: state.data.length),
            ),
          );
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}

// --------------------------------------------------------------------------
// REUSABLE CARD ITEM (Agar Desain Konsisten di Mobile & Desktop)
// --------------------------------------------------------------------------
class BangunanCardItem extends StatelessWidget {
  final BangunanEntity bangunan; // Ganti dengan tipe entity Anda
  final String kotaid;

  const BangunanCardItem({
    super.key,
    required this.bangunan,
    required this.kotaid,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: FrosGlassWrap(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              context.pushNamed(
                'detailbangunan',
                pathParameters: {
                  'idbangunan': bangunan.id.toString(),
                  'iddetail': kotaid,
                  'image': bangunan.imagePath,
                },
                extra: bangunan.imagePath,
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: bangunan.imagePath,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(
                      height: 180,
                      color: Colors.grey[200],
                      child: const Icon(Icons.error),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bangunan.deskripsi,
                        style: GoogleFonts.robotoFlex(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Lihat Detail →",
                        style: GoogleFonts.robotoFlex(
                          fontSize: 14,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TeksDeskripsi extends StatelessWidget {
  final String namakota;
  final String deskiprpsi;
  const TeksDeskripsi({
    super.key,
    required this.deskiprpsi,
    required this.namakota,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        Text(
          deskiprpsi,
          style: GoogleFonts.robotoFlex(
            color: Colors.white,
            fontSize: 16,
            height: 1.6,
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}
