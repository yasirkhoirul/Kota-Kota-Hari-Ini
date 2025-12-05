import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kota_kota_hari_ini/domain/entity/kota_entity.dart';
import 'package:kota_kota_hari_ini/domain/usecase/get_one_kota.dart';
import 'package:kota_kota_hari_ini/domain/usecase/update_kota.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/detail_kota_dart_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/update_kota_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/upload_page_dart_cubit.dart';

class MyDialog extends StatefulWidget {
  final KotaEntity kotaEntity;
  const MyDialog({super.key, required this.kotaEntity});

  @override
  State<MyDialog> createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<UpdateKotaCubit>().onUpdate(widget.kotaEntity);
    },);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: BlocBuilder<UpdateKotaCubit,UpdateKotaState>(builder:(context, state) {
              if (state is UpdateKotaLoaded) {
                return SizedBox(
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Berhasil di ganti"),
                      ElevatedButton(onPressed: (){
                        context.read<DetailKotaDartCubit>().onGetKota(widget.kotaEntity.id.toString());
                        context.pop();
                      }, child: Text("close"))
                    ],
                  ),
                );
              }
              else if(state is UpdateKotaError){
                return Column(
                  children: [
                    Text(state.message),
                    ElevatedButton(onPressed: (){
                      context.pop();
                    }, child: Text("close"))
                  ],
                );
              }
              else if(state is UpdateKotaLoading){
                return CircularProgressIndicator();
              }else{
                return Container();
              }
            }, ),
          ),
        ),
      ),
    );
  }
}

class MyDialogUpPhoto extends StatelessWidget {
  final int id;
  const MyDialogUpPhoto({super.key, required this.id});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: BlocBuilder<UploadPageDartCubit, UploadPageDartState>(
              builder: (context, state) {
                if (state is UploadPageDartLoaded) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: state.imageBytes != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.memory(
                                    state.imageBytes!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(
                                  Icons.image,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                        ),
                    
                        const SizedBox(height: 20),
                    
                        // --- Tombol Pilih Gambar ---
                        ElevatedButton.icon(
                          onPressed: context
                              .read<UploadPageDartCubit>()
                              .pickImage,
                          icon: const Icon(Icons.photo_library),
                          label: const Text("Pilih dari Galeri"),
                        ),
                    
                        const SizedBox(height: 20),
                    
                        // --- Tombol Upload ---
                        if (state.imageBytes != null)
                          ElevatedButton.icon(
                            onPressed: () {
                              context.read<UploadPageDartCubit>().uploadForm(
                                id.toString(),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.cloud_upload),
                            label: const Text("Upload ke Database"),
                          ),
                      ],
                    ),
                  );
                } else if (state is UploadPageDartError) {
                  return Center(
                    child: Column(
                      children: [
                        Text(state.message),
                        OutlinedButton(
                          onPressed: () {
                            context.read<UploadPageDartCubit>().goinit();
                            context.pop();
                          },
                          child: Text("ok"),
                        ),
                      ],
                    ),
                  );
                } else if (state is UploadPageDartInitial) {
                  return Center(
                    child: Column(
                      spacing: 20,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Pilih dari Galeri Sukses"),
                        ElevatedButton.icon(
                          onPressed: context
                              .read<UploadPageDartCubit>()
                              .pickImage,
                          icon: const Icon(Icons.photo_library),
                          label: const Text("Pilih dari Galeri"),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            context.read<UploadPageDartCubit>().goinit();
                            context.replaceNamed(
                              'edit',
                              pathParameters: {
                                'id':"$id"
                              }
                            );
                          },
                          child: Text("cancel"),
                        ),
                      ],
                    ),
                  );
                } else if (state is UploadPageDartSuccess) {
                  return SizedBox(
                    height: 300,
                    child: Column(
                        children: [
                          const Text("upload sukses"),
                          OutlinedButton(
                            onPressed: () {
                              context.read<DetailKotaDartCubit>().onGetKota(id.toString());
                              context.read<UploadPageDartCubit>().goinit();
                              context.pop();
                            },
                            child: Text("ok"),
                          ),
                        ],
                      ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
