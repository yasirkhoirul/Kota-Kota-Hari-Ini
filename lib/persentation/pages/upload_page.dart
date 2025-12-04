import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/upload_page_dart_cubit.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<UploadPageDartCubit, UploadPageDartState>(
          builder: (context, state) {
            if (state is UploadPageDartLoaded) {
              return Column(
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
                        : const Icon(Icons.image, size: 50, color: Colors.grey),
                  ),

                  const SizedBox(height: 20),

                  // --- Tombol Pilih Gambar ---
                  ElevatedButton.icon(
                    onPressed: context.read<UploadPageDartCubit>().pickImage,
                    icon: const Icon(Icons.photo_library),
                    label: const Text("Pilih dari Galeri"),
                  ),

                  const SizedBox(height: 20),

                  // --- Tombol Upload ---
                  if (state.imageBytes != null)
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<UploadPageDartCubit>().uploadForm("5");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.cloud_upload),
                      label: const Text("Upload ke Database"),
                    ),
                ],
              );
            } else if (state is UploadPageDartError) {
              return Center(child: Text(state.message));
            } else if (state is UploadPageDartInitial) {
              return ElevatedButton.icon(
                onPressed: context.read<UploadPageDartCubit>().pickImage,
                icon: const Icon(Icons.photo_library),
                label: const Text("Pilih dari Galeri"),
              );
            } else if (state is UploadPageDartSuccess) {
              return ElevatedButton.icon(
                onPressed: context.read<UploadPageDartCubit>().pickImage,
                icon: const Icon(Icons.photo_library),
                label: const Text("Pilih dari Galeri Sukses"),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
