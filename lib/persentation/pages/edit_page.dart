import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kota_kota_hari_ini/common/dialog.dart';
import 'package:kota_kota_hari_ini/domain/entity/kota_entity.dart';
import 'package:kota_kota_hari_ini/domain/usecase/update_kota.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/delete_image_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/detail_kota_dart_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/update_kota_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/upload_page_dart_cubit.dart';
import 'package:logger/web.dart';

class EditPage extends StatefulWidget {
  final String id;
  const EditPage({super.key, required this.id});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.id.isNotEmpty) {
        context.read<DetailKotaDartCubit>().onGetKota(widget.id);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.id.isNotEmpty
        ? BlocBuilder<DetailKotaDartCubit, DetailKotaDartState>(
            builder: (context, state) {
              if (state is DetailKotaDartLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is DetailKotaDartError) {
                return Center(
                  child: Column(
                    children: [
                      Text(state.message),
                      ElevatedButton(
                        onPressed: () {
                          context.read<DetailKotaDartCubit>().onGetKota(
                            widget.id,
                          );
                        },
                        child: Text("Coba Lagi"),
                      ),
                    ],
                  ),
                );
              } else if (state is DetailKotaDartLoaded) {
                return LayoutBuilder(
                  builder: (context, constrains) {
                    if (constrains.maxHeight < 650) {
                      return SingleChildScrollView(
                        child: SizedBox(
                          height: 650,
                          child: Card(
                            color: Colors.black,
                            child: EditContentText(
                              kotaEntity: state.data,
                              jumlahcrossgrid: constrains.maxWidth > 1200
                                  ? 6
                                  : 4,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return SizedBox(
                        height: 650,
                        child: Card(
                          color: Colors.black,
                          child: EditContentText(
                            kotaEntity: state.data,
                            jumlahcrossgrid: constrains.maxWidth > 1200 ? 6 : 4,
                          ),
                        ),
                      );
                    }
                  },
                );
              } else {
                return Container();
              }
            },
          )
        : Center(child: Text("Tidak ada kota dipilih"));
  }
}

class EditContentText extends StatefulWidget {
  final int jumlahcrossgrid;
  final KotaEntity kotaEntity;
  const EditContentText({
    super.key,
    required this.kotaEntity,
    required this.jumlahcrossgrid,
  });

  @override
  State<EditContentText> createState() => _EditContentTextState();
}

class _EditContentTextState extends State<EditContentText> {
  final GlobalKey _formkey = GlobalKey<FormState>();
  late TextEditingController namakota;
  late TextEditingController deskripsisingkat;
  late TextEditingController deskripsipanjang;
  late TextEditingController lokasi;
  bool isgalerry = false;
  @override
  void initState() {
    namakota = TextEditingController(text: widget.kotaEntity.namaKota);
    deskripsipanjang = TextEditingController(
      text: widget.kotaEntity.deskripsiPanjang,
    );
    deskripsisingkat = TextEditingController(
      text: widget.kotaEntity.deskripsiSingkat,
    );
    lokasi = TextEditingController(text: widget.kotaEntity.lokasi);

    super.initState();
  }

  @override
  void dispose() {
    namakota.dispose();
    deskripsipanjang.dispose();
    deskripsisingkat.dispose();
    lokasi.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Icon(Icons.edit, color: Colors.white, size: 50)),
            !isgalerry
                ? Column(
                    spacing: 10,
                    children: [
                      TextFormField(
                        controller: namakota,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: const Text(
                            "Nama Kota",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        maxLines: 1,
                        style: GoogleFonts.robotoFlex(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                      TextFormField(
                        controller: deskripsisingkat,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text(
                            "Deskripsi Singkat",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        maxLines: 4,
                        style: GoogleFonts.robotoFlex(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                      TextFormField(
                        controller: deskripsipanjang,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text(
                            "Deskripsi Panjang",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        maxLines: 8,
                        style: GoogleFonts.robotoFlex(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                      TextFormField(
                        controller: lokasi,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text(
                            "Lokasi",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        maxLines: 1,
                        style: GoogleFonts.robotoFlex(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  )
                : Expanded(
                    flex: 10,
                    child: BlocConsumer<DeleteImageCubit, DeleteImageState>(
                      listener: (context, state) {
                        if (state is DeleteImageLoading) {
                          Logger().d("dipanggildeletenya");
                          DialogUtils.showLoading(context);
                        } else if (state is DeleteImageError) {
                          DialogUtils.hide(context);
                          DialogUtils.showError(context, state.message);
                        } else if (state is DeleteImageLoaded) {
                          DialogUtils.hide(context);
                          DialogUtils.showSuccess(
                            context,
                            message: state.message,
                            onPressed: () {
                              context.read<DetailKotaDartCubit>().onGetKota(
                                widget.kotaEntity.id.toString(),
                              );
                            },
                          );
                        } else {}
                      },
                      builder: (context, state) {
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: widget.jumlahcrossgrid,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10, // jumlah kolom
                              ),
                          itemCount: widget.kotaEntity.imagePath.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                              ),
                              height: 50,
                              width: 50,

                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(15),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl:
                                            widget.kotaEntity.imagePath[index],
                                        placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Center(child: Icon(Icons.error)),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: -20,
                                    right: -20,
                                    child: IconButton(
                                      onPressed: () {
                                        context
                                            .read<DeleteImageCubit>()
                                            .ondelete(
                                              widget.kotaEntity.id!,
                                              widget
                                                  .kotaEntity
                                                  .imagePath[index],
                                            );
                                      },
                                      icon: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 15,
                                        child: Icon(
                                          Icons.close_rounded,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Row(
                    spacing: 10,
                    children: [
                      BlocConsumer<UpdateKotaCubit, UpdateKotaState>(
                        listener: (context, state) {
                          if (state is UpdateKotaLoading) {
                            DialogUtils.showLoading(context);
                          } else if (state is UpdateKotaLoaded) {
                            DialogUtils.hide(context);
                            DialogUtils.showSuccess(
                              context,
                              message: state.message,
                              onPressed: () {
                                context.read<DetailKotaDartCubit>().onGetKota(
                                  widget.kotaEntity.id.toString(),
                                );
                              },
                            );
                          } else if (state is UpdateKotaError) {
                            DialogUtils.hide(context);
                            DialogUtils.showError(context, state.message);
                          }
                        },
                        builder: (context, state) {
                          return Expanded(
                            child: !isgalerry
                                ? OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      textStyle: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      context.read<UpdateKotaCubit>().onUpdate(
                                        KotaEntity(
                                          widget.kotaEntity.id,
                                          namakota.text,
                                          deskripsisingkat.text,
                                          deskripsipanjang.text,
                                          widget.kotaEntity.imagePath,
                                          "",
                                          lokasi.text,
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Ubah",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                : OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      textStyle: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      final id = widget.kotaEntity.id;
                                      context.pushNamed(
                                        'editpage',
                                        pathParameters: {
                                          'id':"$id",
                                          'childId': '$id'},
                                      );
                                    },
                                    child: Text(
                                      "Upload Gambar",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                          );
                        },
                      ),
                      Expanded(
                        child: !isgalerry
                            ? OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  textStyle: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  setState(() {
                                    isgalerry = true;
                                  });
                                },
                                child: Text(
                                  "Gallery",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            : OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.yellow,
                                  textStyle: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  setState(() {
                                    isgalerry = false;
                                  });
                                },
                                child: Text(
                                  "Text",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                      ),
                    ],
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
