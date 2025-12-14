import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/detail_kota_dart_cubit.dart';

class DetailPageCustom extends StatefulWidget {
  final String id;
  const DetailPageCustom({super.key, required this.id});

  @override
  State<DetailPageCustom> createState() => _DetailPageCustomState();
}

class _DetailPageCustomState extends State<DetailPageCustom> {
  
  @override
  void initState() {
     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<DetailKotaDartCubit>().onGetKota(widget.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailKotaDartCubit, DetailKotaDartState>(
      builder: (context, state) {
        if (state is DetailKotaDartLoaded) {
          return Scaffold(
            backgroundColor: Color(0xFF969393),
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 500,
                  flexibleSpace: FlexibleSpaceBar(
                    background: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: state.data.imagePath.first,
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
                SliverList.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) => SizedBox(
                    height: 1200,
                    child: Row(
                      children: [
                        Expanded(
                          child: TeksDeskripsi(
                            deskiprpsi: state.data.deskripsiPanjang,
                            namakota: state.data.lokasi,
                          ),
                        ),
                        Expanded(
                          child: ListBangunan(pathkota: state.data.imagePath),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        if (state is DetailKotaDartError) {
          return Center(child: Text(state.message));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class ListBangunan extends StatelessWidget {
  final List<String> pathkota;
  const ListBangunan({super.key, required this.pathkota});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pathkota.length,
      itemBuilder: (context, index) => Card(
        child: Column(
          children: [
            InkWell(
              child: SizedBox(
                height: 250,
                width: 250,
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: pathkota[index],
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                  ),
                ),
              ),
            ),
          ],
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
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          textAlign: TextAlign.start,
          namakota,
          style: GoogleFonts.robotoFlex(
            color: Colors.black,
            fontSize: 64,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          deskiprpsi,
          style: GoogleFonts.robotoFlex(
            color: Colors.black,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
